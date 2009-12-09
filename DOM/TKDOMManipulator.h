//
//  TKDOMManipulator.h
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


// TKDOMManipulator
//
// Manipulate a DOMNode on the main thread
//
@interface TKDOMManipulator : NSObject {
    DOMNode *node_;
#ifdef MAC_OS_X_VERSION_10_6
    void *(^block_)(DOMNode *);
#endif
    void *(*function_)(DOMNode *);
    id result_;
}

#ifdef MAC_OS_X_VERSION_10_6
+ (id)manipulateDOMNode:(DOMNode *)node
             usingBlock:(void *(^)(DOMNode *))block;
- (id)manipulateDOMNode:(DOMNode *)node
             usingBlock:(void *(^)(DOMNode *))block
            autorelease:(BOOL)autorelease;
#endif
+ (id)manipulateDOMNode:(DOMNode *)node
          usingFunction:(void *(*)(DOMNode *))function;
- (id)manipulateDOMNode:(DOMNode *)node
          usingFunction:(void *(*)(DOMNode *))function
            autorelease:(BOOL)autorelease;

@end
