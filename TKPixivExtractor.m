//
//  TKPixivExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/12/12.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPixivExtractor.h"
#import "TKFileData.h"

#import "DOM.h"


static NSString *contentTypeFromFilename(NSString *filename);


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
    [post setTitle:[source title]];
    [post setBody:[source text]];
    [post setLinkURL:[source URL]];

    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:[source sourceURL]];
    [request addValue:[[source URL] absoluteString]
   forHTTPHeaderField:@"Referer"];
    NSURLResponse *response;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:NULL];
    NSString *filename = [[[source sourceURL] absoluteString] lastPathComponent];
    NSString *contentType = contentTypeFromFilename(filename);
    TKFileData *fileData = [[TKFileData alloc] initWithData:imageData
                                                contentType:contentType
                                                   filename:filename];
    [fileData autorelease];
    [post setObject:fileData];

    return [post autorelease];
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

@end
