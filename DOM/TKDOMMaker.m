//
//  TKDOMProxyMaker.m
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKDOMMaker.h"


@interface TKDOMMaker_Worker : NSObject
{
    NSString *URLString_;
    id <PLActorProcess> receiver_;
    NSMutableSet *workerPool_;
    WebView *webView_;
}

- (id)initWithURLString:(NSString *)URLString
               receiver:(id)receiver
             workerPool:(NSMutableSet *)workerPool;

@end


@implementation TKDOMMaker_Worker

- (id)initWithURLString:(NSString *)URLString
               receiver:(id <PLActorProcess>)receiver
             workerPool:(NSMutableSet *)workerPool;
{
    self = [super init];
    URLString_ = [URLString retain];
    receiver_ = [receiver retain];
    workerPool_ = [workerPool retain];
    return self;
}

- (void)dealloc
{
    [URLString_ release];
    [receiver_ release];
    [workerPool_ release];
    if (webView_ != nil) {
        [webView_ release];
    }
    [super dealloc];
}

- (void)enterToPool
{
    @synchronized (workerPool_) {
        [workerPool_ addObject:self];
    }
}

- (void)leaveFromPool
{
    @synchronized (workerPool_) {
        [workerPool_ removeObject:self];
    }
}

- (void)run
{
    [self enterToPool];
    webView_ = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)
                                    frameName:nil
                                    groupName:nil];
    [webView_ retain];
    [webView_ setFrameLoadDelegate:self];
    [webView_ setMainFrameURL:URLString_];
}

- (void)webView:(WebView *)sender 
didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame != [webView_ mainFrame]) {
        return;
    }
    DOMDocument *doc = [frame DOMDocument];
    PLActorMessage *message = [PLActorMessage messageWithObject:doc];
    [receiver_ send:message];
    [self leaveFromPool];
}

- (void)webView:(WebView *)sender
didFailLoadWithError:(NSError *)error
       forFrame:(WebFrame *)frame
{
    [receiver_ send:[PLActorMessage message]];
    [self leaveFromPool];
}

@end


@implementation TKDOMMaker

+ (id)defaultDOMMaker
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[TKDOMMaker alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    workerPool_ = [NSMutableSet set];
    return self;
}

- (void)dealloc
{
    [workerPool_ release];
    [super dealloc];
}

- (DOMDocument *)newDOMDocumentWithURLString:(NSString *)URLString
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self sendMessageContainingDOMDocumentToReceiver:[PLActorKit process]
                                       withURLString:URLString];
    PLActorMessage *message = [PLActorKit receive];
    DOMDocument *doc = [[message object] retain];
    [pool drain];
    return doc;
}

- (void)sendMessageContainingDOMDocumentToReceiver:(id <PLActorProcess>)receiver
                                     withURLString:(NSString *)URLString
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TKDOMMaker_Worker *worker;
    worker = [[TKDOMMaker_Worker alloc] initWithURLString:URLString
                                                      receiver:receiver
                                                    workerPool:workerPool_];
    [worker autorelease];
    [worker performSelectorOnMainThread:@selector(run)
                             withObject:nil
                          waitUntilDone:NO];
    [pool drain];
}

// DOMDocument MUST be released with relsaseDOM:,
// since releasing a DOMDocument in a secondary thread causes SIGABRT.
- (void)releaseDOM:(id)object
{
    [object performSelectorOnMainThread:@selector(release)
                             withObject:nil
                          waitUntilDone:NO];
}


@end
