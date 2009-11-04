//
//  TKDOMProxyMaker.h
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <ActorKit/ActorKit.h>


// TKDOMMaker
//
// Make a DOMDocument from given URL synchronously
//
@interface TKDOMMaker : NSObject {
    NSMutableSet *workerPool_;
}

+ (id)DOMMaker;

// NOTE:
// - Do NOT perform newDOMDocumentWithURLString on the main thread
// - Returned DOMDocument MUST be released with releaseDOM:
// 
- (DOMDocument *)newDOMDocumentWithURLString:(NSString *)URLString;
- (void)releaseDOM:(id)object;

@end
