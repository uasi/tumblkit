//
//  TKPixivExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/12/12.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKPixivExtractor.h"
#import "TKFileData.h"

#import "DOM.h"


static NSURL *originalImageURLFromImageURL(NSURL *imageURL);
static NSURL *illustPageURLFromImageURL(NSURL *imageURL);
static NSString *contentTypeFromFilename(NSString *filename);
static id extractTitle(DOMNode *node);


@implementation TKPixivExtractor

- (NSString *)title
{
    return @"Image (pixiv)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([source sourceURL] != nil &&
            [[[source sourceURL] host] hasSuffix:@".pixiv.net"] &&
            [[[source sourceURL] host] hasPrefix:@"img"]);
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostImageType
                                         source:source];
    [post setBody:[source text]];
    
    NSURL *illustPageURL = illustPageURLFromImageURL([source sourceURL]);
    [post setPageURL:illustPageURL];
    
    if ([illustPageURL isEqual:[source sourceURL]]) {
        [post setTitle:[source title]];
    }
    else {
        DOMDocument *doc = [TKDOMMaker makeDocumentWithContentsOfURLString:
                            [illustPageURL absoluteString]];
        if (doc != nil) {
            NSString *title = [TKDOMManipulator manipulateNode:doc
                                                 usingFunction:extractTitle];
            [post setTitle:title];
        }
        else {
            return nil;
        }
        [TKDOMMaker destroyDocument:doc];
    }

    NSURL *originalImageURL = originalImageURLFromImageURL([source sourceURL]);
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:originalImageURL];
    [request addValue:[illustPageURL absoluteString]
   forHTTPHeaderField:@"Referer"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
    if (error != nil || imageData == nil) {
        return nil;
    }
    NSString *filename = [[originalImageURL absoluteString] lastPathComponent];
    NSString *contentType = contentTypeFromFilename(filename);
    TKFileData *fileData = [[TKFileData alloc] initWithData:imageData
                                                contentType:contentType
                                                   filename:filename];
    [fileData autorelease];
    [post setObject:fileData];

    return [post autorelease];
}


static NSURL *originalImageURLFromImageURL(NSURL *imageURL)
{
    // imageURL is http://img<num>.pixiv.net/<userID>/<imageID><size>.<ext>
    // where
    //     <num>     =~ /\d+/
    //     <userID>  =~ /\w+/
    //     <imageID> =~ /\d+/
    //     <size>    =~ /|_s|_m/  # original, small or medium
    //     <ext>     =~ /jpg|jpeg|gif|png/ 

    NSString *URLString = [imageURL absoluteString];
    NSUInteger length = [URLString length];
    NSRange range = [URLString rangeOfString:@"_"
                                     options:NSBackwardsSearch];
    
    if (range.location != NSNotFound && range.location >= length - 7) {
        NSString *originalURLString;
        originalURLString = [NSString stringWithFormat:
                             @"%@%@",
                             [URLString substringToIndex:range.location],
                             [URLString substringFromIndex:range.location + 2]];
        return [NSURL URLWithString:originalURLString];
    }
    else {
        return [[imageURL copy] autorelease];
    }
}

static NSURL *illustPageURLFromImageURL(NSURL *imageURL)
{
    NSURL *originalImageURL = originalImageURLFromImageURL(imageURL);
    NSString *filename = [[originalImageURL absoluteString] lastPathComponent];
    NSRange range = [filename rangeOfString:@"."];
    NSString *imageID = [filename substringToIndex:range.location];
    return [NSURL URLWithString:
            [NSString stringWithFormat:
             @"http://www.pixiv.net/member_illust.php?mode=medium&illust_id=%@",
             imageID]];
}

static NSString *contentTypeFromFilename(NSString *filename)
{
    static NSDictionary *contentTypeDictionary = nil;
    if (contentTypeDictionary == nil) {
        contentTypeDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"jpg",
                                 @"image/jpg",
                                 @"jpeg",
                                 @"image/jpg",
                                 @"png",
                                 @"image/png",
                                 @"gif",
                                 @"image/gif",
                                 nil];
    }
    NSString *extension = [filename pathExtension];
    NSString *contentType = [contentTypeDictionary objectForKey:extension];
    return contentType != nil ? contentType : @"application/octet-stream";
}

static id extractTitle(DOMNode *doc)
{
    NSString *xpath = @"/html/head/title";
    return [[doc tk_elementForXPath:xpath] innerText];
}

@end
