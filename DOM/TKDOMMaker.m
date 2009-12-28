//
//  TKDOMProxyMaker.m
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKDOMMaker.h"
#import "TKDOMManipulator.h"


@interface TKDOMMaker_Worker : NSObject {
    NSString *URLString_;
    id <PLActorProcess> receiver_;
    WebView *webView_;
}

- (id)initWithURLString:(NSString *)URLString
               receiver:(id)receiver;
- (void)run;

@end


@implementation TKDOMMaker_Worker

- (id)initWithURLString:(NSString *)URLString
               receiver:(id <PLActorProcess>)receiver
{
    self = [super init];
    URLString_ = [URLString retain];
    receiver_ = [receiver retain];
    return self;
}

- (void)dealloc
{
    [URLString_ release];
    [receiver_ release];
    if (webView_ != nil) {
        [webView_ release];
    }
    [super dealloc];
}

- (void)run
{
    webView_ = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)
                                    frameName:nil
                                    groupName:nil];
    [webView_ setFrameLoadDelegate:self];
    [webView_ setMainFrameURL:URLString_];
}

- (void)webView:(WebView *)sender 
didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame != [sender mainFrame]) {
        return;
    }
    DOMDocument *doc = [frame DOMDocument];
    PLActorMessage *message = [PLActorMessage messageWithObject:doc];
    [receiver_ send:message];
}

- (void)webView:(WebView *)sender
didFailLoadWithError:(NSError *)error
       forFrame:(WebFrame *)frame
{
    [receiver_ send:[PLActorMessage message]];
}

@end


@interface TKDOMMaker ()

- (DOMDocument *)makeDocumentWithURLString:(NSString *)URLString;

@end


@implementation TKDOMMaker


+ (DOMDocument *)makeDocumentWithContentsOfURLString:(NSString *)URLString
{
    TKDOMMaker *maker = [[[[self class] alloc] init] autorelease];
    return [maker makeDocumentWithURLString:URLString];
}

static id ownerDocumentOfNode(DOMNode *node)
{
    return [node ownerDocument];
}

+ (DOMDocument *)makeOwnerDocumentOfNode:(DOMNode *)node
{
    TKDOMManipulator *manip = [[[TKDOMManipulator alloc] init] autorelease];
    return [manip manipulateNode:node
                   usingFunction:ownerDocumentOfNode
                     autorelease:NO];
}


+ (void)destroyDocument:(DOMDocument *)doc
{
    [doc performSelectorOnMainThread:@selector(release)
                          withObject:nil
                       waitUntilDone:YES];
}

- (DOMDocument *)makeDocumentWithURLString:(NSString *)URLString
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TKDOMMaker_Worker *worker;
    worker = [[TKDOMMaker_Worker alloc] initWithURLString:URLString
                                                 receiver:[PLActorKit process]];
    [worker autorelease];
    [worker performSelectorOnMainThread:@selector(run)
                             withObject:nil
                          waitUntilDone:NO];
    PLActorMessage *message = [PLActorKit receive];
    DOMDocument *doc = [[message object] retain];
    [pool drain];
    return doc;
}

@end
