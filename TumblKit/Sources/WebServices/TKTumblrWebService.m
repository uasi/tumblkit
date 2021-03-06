//
//  TKTumblrWebService.m
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <ActorKit/ActorKit.h>

#import "TKTumblrWebService.h"
#import "TKBundleController.h"
#import "TKPost.h"
#import "TKGrowlHelper.h"
#import "TKMultipartFormDataBuilder.h"

#import "CommonAdditions.h"
#import "DOM.h"


@interface TKTumblrWebService ()

- (void)post:(TKPost *)post;
- (void)abortPosting;
- (void)finishPosting;
- (void)updateQuery:(NSMutableDictionary *)query
           withPost:(TKPost *)post;
- (NSString *)postTypeStringForPost:(TKPost *)post;
static id queryFromNode(DOMNode *node);

@end


@implementation TKTumblrWebService

- (void)post:(TKPost *)post
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *postTypeString = [self postTypeStringForPost:post];
    NSString *endpoint = @"http://www.tumblr.com/new/";
    endpoint = [endpoint stringByAppendingString:postTypeString];
    DOMDocument *doc = [TKDOMMaker makeDocumentWithContentsOfURLString:endpoint];
    if (doc == nil) {
        NSLog(@"TumblKit: post failed: failed to load post form");
        [self abortPosting];
        return;
    }
    
    NSMutableDictionary *query;
    query = [TKDOMManipulator manipulateNode:doc
                               usingFunction:queryFromNode];
    
    [self updateQuery:query withPost:post];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request setHTTPMethod:@"POST"];
    TKMultipartFormDataBuilder *builder = [query tk_multipartFormDataBuilder];
    [request setValue:[builder HTTPContentTypeHeaderValue]
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[builder formData]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];

    if (data == nil) {
        NSLog(@"TumblKit: post failed: %@", error);
        [self abortPosting];
    }
    else {
        [self finishPosting];
    }

    [TKDOMMaker destroyDocument:doc];
    [pool drain];
}

- (void)abortPosting
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"TumblKit - connection failed"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:NSLocalizedStringFromTableInBundle(@"Your post was not sent. Check your Internet connection and make sure you are logged in to Tumblr.", @"", TKBundle, @"")];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[NSApp mainWindow]
                      modalDelegate:nil
                     didEndSelector:nil
                        contextInfo:NULL];
}

- (void)finishPosting
{
    NSString *URLString = @"http://www.tumblr.com/dashboard";
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"Post Successful"
                                           description:@"A post was created"
                                  openURLStringOnClick:URLString];
}

- (void)updateQuery:(NSMutableDictionary *)query
           withPost:(TKPost *)post
{
    if ([post isPrivate]) {
        [query setObject:@"private" forKey:@"post[state]"];
    }
    [query removeObjectForKey:@"preview_post"];    
    [query setObject:[self postTypeStringForPost:post] forKey:@"post[type]"];
    if ([[post tags] lastObject] != nil) {
        NSString *tags = [[post tags] componentsJoinedByString:@","];
        [query setObject:tags forKey:@"post[tags]"];
    }
    
    if ([post type] == TKPostQuoteType) {
        NSString *body = [[post body] tk_stringByEscapingTagsAndAmpersands];
        [query setObject:body forKey:@"post[one]"];
        NSString *title = [[post title] tk_stringByEscapingTagsAndAmpersands];
        NSString *source = [[post pageURL] tk_anchorStringWithText:title];
        [query setObject:source forKey:@"post[two]"];
    }
    else if ([post type] == TKPostLinkType) {
        [query setObject:[post title] forKey:@"post[one]"];
        [query setObject:[post pageURL] forKey:@"post[two]"];
        NSString *description = [[post body] tk_stringByEscapingTagsAndAmpersands];
        [query setObject:description forKey:@"post[three]"];
    }
    else if ([post type] == TKPostImageType) {
        if ([post object]) {
            [query setObject:[post object] forKey:@"images[o1]"];
        }
        else {
            [query setObject:[post URL] forKey:@"photo_src"];
        }
        [query setObject:[post pageTitle] forKey:@"t"];
        [query setObject:[post pageURL] forKey:@"u"];
        NSString *title = [[post title] tk_stringByEscapingTagsAndAmpersands];
        NSString *caption = [[post pageURL] tk_anchorStringWithText:title];
        if (![[post body] isEqualToString:@""]) {
            NSString *body = [[post body] tk_stringByEscapingTagsAndAmpersands];
            caption = [body stringByAppendingFormat:@" (via %@)", caption];
        }
        [query setObject:caption forKey:@"post[two]"];
        // Note: post[two] might be
        //     (title ? link(title) : "") + (author ? link(author) : "") + (desc ? "\n\n" + desc : "")
        [query setObject:[post pageURL] forKey:@"post[three]"];
    }
    else if ([post type] == TKPostVideoType) {
        if ([post URL] != nil) {
            [query setObject:[post URL] forKey:@"post[one]"];
        }
        else if ([post object] != nil) {
            [query setObject:[post object] forKey:@"post[one]"];
        }
        else {
            NSLog(@"TumblKit: WebService: Video: both URL and object are nil");
        }
        NSString *title = [[post title] tk_stringByEscapingTagsAndAmpersands];
        NSString *caption = [[post pageURL] tk_anchorStringWithText:title];
        if (![[post body] isEqualToString:@""]) {
            NSString *body = [[post body] tk_stringByEscapingTagsAndAmpersands];
            caption = [body stringByAppendingFormat:@" (via %@)", caption];
        }
        [query setObject:caption forKey:@"post[two]"];
    }
}

- (NSString *)postTypeStringForPost:(TKPost *)post
{
    switch ([post type]) {
        case TKPostVideoType:
            return @"video";
        case TKPostQuoteType:
            return @"quote";
        case TKPostLinkType:
            return @"link";
        case TKPostImageType:
            return @"photo";
        default:
            return @"";
    }
}

static id queryFromNode(DOMNode *node)
{
    NSString *xpath = @"//form[@id='edit_post']";
    DOMElement *formElem = (DOMElement *)[node tk_nodeForXPath:xpath];
    if (formElem == nil) {
        return NULL;
    }
    return TKCreateDictionaryWithForm(formElem);
}

@end
