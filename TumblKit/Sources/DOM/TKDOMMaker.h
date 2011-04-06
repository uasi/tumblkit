//
//  TKDOMProxyMaker.h
//  TumblKitNG
//
//  Created by uasi on 09/10/31.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <ActorKit/ActorKit.h>


// TKDOMMaker
//
// Make a DOMDocument from given URL synchronously
//
@interface TKDOMMaker : NSObject {
}

// NOTE:
// - Do NOT perform makeDOMDocumentWithURLString on the main thread
// - Returned DOMDocument MUST be destroyed by performing destroyDOMDocument:
// 
+ (DOMDocument *)makeDocumentWithContentsOfURLString:(NSString *)URLString;
+ (DOMDocument *)makeOwnerDocumentOfNode:(DOMNode *)node;

+ (void)destroyDocument:(DOMDocument *)doc;

@end
