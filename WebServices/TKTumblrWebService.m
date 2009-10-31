//
//  TKTumblrWebService.m
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKTumblrWebService.h"
#import "TKBundleController.h"
#import "TKCommonAdditions.h"
#import "TKPost.h"
#import "TKPostingNotification.h"
#import "TKGrowlHelper.h"
#import "TKDOMUtil.h"


@interface TKTumblrWebService () // Priavte Methods
- (void)postWithPost:(TKPost *)post;
- (void)abortPosting;
- (void)finishPosting;
- (void)updateQuery:(NSMutableDictionary *)query
           withPost:(TKPost *)post;
- (NSString *)postTypeStringForPost:(TKPost *)post;
@end


@implementation TKTumblrWebService

static NSURL *TKTumblrWebServiceURL;

+ (void)load
{
    TKTumblrWebServiceURL = [[NSURL alloc] initWithString:@"http://www.tumblr.com/new/"];
}

+ (void)postWithNotification:(NSNotification *)notification
{
    TKPost *post = [[notification userInfo] objectForKey:@"post"];
    [[[[[self class] alloc] init] autorelease] postWithPost:post];
}

- (id)init
{
    self = [super init];
    webView_ = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)
                                    frameName:nil
                                    groupName:nil];
    [webView_ setFrameLoadDelegate:self];
    return self;
}

- (void)dealloc
{
    [post_ release];
    [webView_ release];
    [super dealloc];
}

- (void)postWithPost:(TKPost *)post
{
    [post_ autorelease];
    post_ = [post retain];
    NSString *postTypeString = [self postTypeStringForPost:post];
    NSString *endpoint = @"http://www.tumblr.com/new/";
    endpoint = [endpoint stringByAppendingString:postTypeString];
    [webView_ setMainFrameURL:endpoint];
    [self retain];
}

- (void)webView:(WebView *)sender 
didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame != [webView_ mainFrame]) {
        return;
    }
    DOMDocument *doc = [frame DOMDocument];
    DOMXPathResult *res = [doc evaluate:@"//form[@id='edit_post']"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:nil];
    DOMElement *formElem = (DOMElement *)[res singleNodeValue];
    if (formElem == nil) {
        [self abortPosting];
        return;
    }
    NSMutableDictionary *query = (NSMutableDictionary *)TKCreateDictionaryWithForm(formElem);
    [self updateQuery:query withPost:post_];
    NSURL *requestURL = [NSURL URLWithString:[webView_ mainFrameURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPBody:[[query tk_queryString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)webView:(WebView *)sender
didFailLoadWithError:(NSError *)error
       forFrame:(WebFrame *)frame
{
    [self abortPosting];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response
{
    [self finishPosting];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self abortPosting];
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
    [self release];
}

- (void)finishPosting
{
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"Post Successful"
                                           description:@"A post was created"];
    [self release];
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
@end