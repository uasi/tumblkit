//
//  TKDOMManipulator.h
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


typedef id (^TKDOMManipBlock)(DOMNode *);


// TKDOMManipulator
//
// Manipulate a DOMNode on the main thread
//
@interface TKDOMManipulator : NSObject {
    DOMNode *node_;
    id (^block_)(DOMNode *);
    id (*function_)(DOMNode *);
    id result_;
}

+ (id)manipulateNode:(DOMNode *)node
          usingBlock:(TKDOMManipBlock)block;
- (id)manipulateNode:(DOMNode *)node
          usingBlock:(TKDOMManipBlock)block
         autorelease:(BOOL)autorelease;
+ (id)manipulateNode:(DOMNode *)node
       usingFunction:(id (*)(DOMNode *))function;
- (id)manipulateNode:(DOMNode *)node
       usingFunction:(id (*)(DOMNode *))function
         autorelease:(BOOL)autorelease;

@end


id TKDOMManip(DOMNode *node, TKDOMManipBlock block);

