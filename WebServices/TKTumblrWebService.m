//
//  TKTumblrWebServiceActor.m
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <ActorKit/ActorKit.h>

#import "TKTumblrWebService.h"
#import "TKBundleController.h"
#import "TKCommonAdditions.h"
#import "TKPost.h"
#import "TKPostingNotification.h"
#import "TKGrowlHelper.h"
#import "DOM.h"


@interface TKTumblrWebService () // Priavte Methods
- (void)postWithPost:(TKPost *)post;
- (void)abortPosting;
- (void)finishPosting;
- (void)updateQuery:(NSMutableDictionary *)query
           withPost:(TKPost *)post;
- (NSString *)postTypeStringForPost:(TKPost *)post;
static void *queryFromDOMNode(DOMNode *node);
@end


@implementation TKTumblrWebService

+ (void)postWithNotification:(NSNotification *)notification
{
    TKPost *post = [[notification userInfo] objectForKey:@"post"];
    [PLActorKit spawnWithTarget:[[[[self class] alloc] init] autorelease]
                       selector:@selector(postWithPost:)
                         object:post];
}

- (void)postWithPost:(TKPost *)post
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *postTypeString = [self postTypeStringForPost:post];
    NSString *endpoint = @"http://www.tumblr.com/new/";
    endpoint = [endpoint stringByAppendingString:postTypeString];
    DOMDocument *doc = [[TKDOMMaker defaultDOMMaker]
                        newDOMDocumentWithURLString:endpoint];
    if (doc == nil) {
        NSLog(@"TumblKit: post failed: failed to load post form");
        [self abortPosting];
        return;
    }
    
    NSMutableDictionary *query;
    query = [TKDOMManipulator manipulateDOMNode:doc
                                  usingFunction:queryFromDOMNode];
    
    [self updateQuery:query withPost:post];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request setHTTPBody:[[query tk_queryString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *response;
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
    
    [[TKDOMMaker defaultDOMMaker] releaseDOM:doc];
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
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"Post Successful"
                                           description:@"A post was created"];
}

- (void)updateQuery:(NSMutableDictionary *)query
           withPost:(TKPost *)post
{
    if ([post isPrivate]) {
        [query setObject:@"private" forKey:@"post[state]"];
    }
    [query removeObjectForKey:@"preview_post"];    
    [query setObject:[self postTypeStringForPost:post] forKey:@"post[type]"];
    if ([post tags] != nil && [[post tags] lastObject] != nil) {
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
        [query setObject:[post URL] forKey:@"photo_src"];
        NSString *title = [[post title] tk_stringByEscapingTagsAndAmpersands];
        NSString *caption = [[post pageURL] tk_anchorStringWithText:title];
        if ([post body] != nil && ! [[post body] isEqualToString:@""]) {
            NSString *body = [[post body] tk_stringByEscapingTagsAndAmpersands];
            caption = [body stringByAppendingFormat:@" (via %@)", caption];
        }
        [query setObject:caption forKey:@"post[two]"];
        // Note: post[two] might be
        //     (title ? link(title) : "") + (author ? link(author) : "") + (desc ? "\n\n" + desc : "")
        if ([post linkURL] != nil) {
            [query setObject:[post linkURL] forKey:@"post[three]"];
        }
    }
    else if ([post type] == TKPostVideoType) {
        //[query setObject:[post pageURL] forKey:@"post[one]"];
        if ([post URL]) {
            [query setObject:[post URL] forKey:@"post[one]"];
        }
        else if ([post object]) {
            [query setObject:[post object] forKey:@"post[one]"];
        }
        else {
            NSLog(@"TumblKit: WebService: Video: both URL and object are nil");
        }
        NSString *title = [[post title] tk_stringByEscapingTagsAndAmpersands];
        NSString *caption = [[post pageURL] tk_anchorStringWithText:title];
        if ([post body] != nil && ! [[post body] isEqualToString:@""]) {
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

static void *queryFromDOMNode(DOMNode *node)
{
    DOMDocument *doc = (DOMDocument *)node;
    DOMXPathResult *res = [doc evaluate:@"//form[@id='edit_post']"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:nil];
    DOMElement *formElem = (DOMElement *)[res singleNodeValue];
    if (formElem == nil) {
        return NULL;
    }
    return (void *)TKCreateDictionaryWithForm(formElem);
}

@end
