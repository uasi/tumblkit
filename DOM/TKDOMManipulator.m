//
//  TKDOMManipulator.m
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKDOMManipulator.h"


@implementation TKDOMManipulator

static void *ownerDocumentOfNode(DOMNode *node)
{
    return [node ownerDocument];
}

+ (DOMDocument *)ownerDocumentOfNode:(DOMNode *)node
{
    return [[self class] manipulateDOMNode:node
                             usingFunction:ownerDocumentOfNode];
}
            
#ifdef MAC_OS_X_VERSION_10_6

+ (id)manipulateDOMNode:(DOMNode *)node
             usingBlock:(void *(^)(DOMNode *))block
{
    return [[[[[self class] alloc] init] autorelease] manipulateDOMNode:node
                                                             usingBlock:block];
}

- (id)manipulateDOMNode:(DOMNode *)node
             usingBlock:(void *(^)(DOMNode *))block
{
    node_ = node;
    block_ = block;
    [self performSelectorOnMainThread:@selector(manipulateUsingBlock)
                           withObject:nil
                        waitUntilDone:YES];
    return result_;    
}

- (void)manipulateUsingBlock
{
    result_ = block_(node_);
}

#endif /* MAC_OS_X_VERSION_10_6 */

+ (id)manipulateDOMNode:(DOMNode *)node
             usingFunction:(void *(*)(DOMNode *))function
{
    return [[[[[self class] alloc] init] autorelease] manipulateDOMNode:node
                                                          usingFunction:function];
}

- (id)manipulateDOMNode:(DOMNode *)node
          usingFunction:(void *(*)(DOMNode *))function
{
    node_ = node;
    function_ = function;
    [self performSelectorOnMainThread:@selector(manipulateUsingFunction)
                           withObject:nil
                        waitUntilDone:YES];
    return result_;    
}

- (void)manipulateUsingFunction
{
    result_ = function_(node_);
}

@end
