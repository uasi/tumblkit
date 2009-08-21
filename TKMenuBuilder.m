//
//  TKMenuBuilder.m
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "TKMenuBuilder.h"
#import "TKBundleController.h"
#import "TKEditPanelController.h"
#import "TKExtractor.h"
#import "TKSource.h"
#import "TKPost.h"
#import "TKPostingNotification.h"
#import "TKDOMUtil.h"
#import "NSDictionary+TumblKitAdditions.h"
#import "TKGrowlHelper.h"

#define TK_L(str) NSLocalizedStringFromTableInBundle(str, @"", TKBundle, @"")

@interface TKMenuBuilder () // Private Methods
- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractactor;
- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractactor;
@end


@implementation TKMenuBuilder

@synthesize menu = menu_;

- (void)insertItemsToMenu
{
    NSArray *extractors = [TKExtractor extractorsForSource:source_];
    if ([extractors lastObject] == nil) {
        return;
    }
    TKExtractor *firstExtractor = [extractors objectAtIndex:0];
    
    NSMenuItem *firstItem = [self itemForExtractor:firstExtractor];
    [firstItem setTitle:[NSString stringWithFormat:TK_L(@"Share %@"), [firstItem title]]];
    [menu_ insertItem:firstItem atIndex:0];
    
    NSMenuItem *firstAltItem = [self alternateItemForExtractor:firstExtractor];
    [firstAltItem setTitle:[[firstItem title] stringByAppendingString:@"..."]];
    [menu_ insertItem:firstAltItem atIndex:1];
    
    NSMenu *submenu = [[NSMenu alloc] init];
    NSMenuItem *submenuItem = [[NSMenuItem alloc] init];
    [submenuItem setTitle:TK_L(@"Share As...")];
    [submenuItem setSubmenu:submenu];
    [menu_ insertItem:[submenuItem autorelease] atIndex:2];
    [menu_ insertItem:[NSMenuItem separatorItem] atIndex:3];
    
    for (TKExtractor *extractor in extractors) {
        [submenu addItem:[self itemForExtractor:extractor]];
        [submenu addItem:[self alternateItemForExtractor:extractor]];
    }
}

- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractor
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:TK_L([extractor title])
                                                  action:@selector(notify:)
                                           keyEquivalent:@""];
    [item setTarget:[TKPostingNotifier sharedNotifier]];
    [item setRepresentedObject:[extractor deferredPostFromSource:source_]];
    return [item autorelease];
}

- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractor
{
    NSString *title = [TK_L([extractor title]) stringByAppendingString:@"..."];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(notify:)
                                           keyEquivalent:@""];
    [item setTarget:[[TKBundleController sharedBundleController] editPanelController]];
    [item setAction:@selector(showWindowWithMenuItem:)];
    [item setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [item setAlternate:YES];
    return [item autorelease];
}

- (void)post:(id)sender
{
    NSString *source = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.tumblr.com/new/quote"]
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];

    WebView *webView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)
                                            frameName:nil
                                            groupName:nil];
    [[webView mainFrame] loadHTMLString:source baseURL:[NSURL URLWithString:@"http://www.tumblr.com/"]];
    BOOL isRunning;
    do {
		NSDate* next = [NSDate dateWithTimeIntervalSinceNow:0.25];
		isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
											 beforeDate:next];
	} while (isRunning && [webView isLoading]);
    DOMDocument *doc = [webView mainFrameDocument];
    NSLog(@"Document loaded %@", doc);
    DOMXPathResult *res = [doc evaluate:@"//form[@id='edit_post']"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:nil];
    NSLog(@"Got res %@", res);
    DOMElement *formElem = (DOMElement *)[res singleNodeValue];
    NSMutableDictionary *content = (NSMutableDictionary *)TKCreateDictionaryWithForm(formElem);
    
    
    
#if 0
    WebView *webView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)
                                            frameName:nil
                                            groupName:nil];
    [webView setMainFrameURL:@"http://www.tumblr.com/new/text"];
    BOOL isRunning;
    do {
		NSDate* next = [NSDate dateWithTimeIntervalSinceNow:0.25];
		isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
											 beforeDate:next];
	} while (isRunning && [webView isLoading]);
    DOMDocument *doc = [webView mainFrameDocument];
    DOMXPathResult *res = [doc evaluate:@"//form[@id='edit_post']"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:nil];
    DOMElement *formElem = (DOMElement *)[res singleNodeValue];
    NSMutableDictionary *dict = (NSMutableDictionary *)TKCreateDictionaryWithForm(formElem);
    [dict setObject:@"Title" forKey:@"post[one]"];
    [dict setObject:@"Body" forKey:@"post[two]"];
    [dict removeObjectForKey:@"preview_post"]; // REQUIRED!
    [dict setObject:@"private" forKey:@"post[state]"];
    NSLog(@"%@", dict);
    NSLog(@"%@", [dict tk_queryString]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tumblr.com/new/text"]];
    [request setHTTPBody:[[dict tk_queryString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response
{
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"POST Test"
                                           description:[NSString stringWithFormat:@"Code %d", 
                                                        [response statusCode]]];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"POST Test"
                                           description:@"POST failed"];
}

- (id)initWithMenu:(NSMenu *)menu
            source:(TKSource *)source
{
    [super init];
    menu_ = [menu retain];
    source_ = [source retain];
    return self;
}

- (void)dealloc
{
    [menu_ release];
    [source_ release];
    [super dealloc];
}

@end
