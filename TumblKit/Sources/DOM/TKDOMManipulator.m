//
//  TKDOMManipulator.m
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKDOMManipulator.h"


@implementation TKDOMManipulator

+ (id)manipulateNode:(DOMNode *)node
          usingBlock:(id (^)(DOMNode *))block
{
    return [[[[[self class] alloc] init] autorelease] manipulateNode:node
                                                          usingBlock:block
                                                         autorelease:YES];
}

- (id)manipulateNode:(DOMNode *)node
          usingBlock:(id (^)(DOMNode *))block
         autorelease:(BOOL)autorelease
{
    node_ = node;
    block_ = block;
    [self performSelectorOnMainThread:@selector(manipulateUsingBlock)
                           withObject:nil
                        waitUntilDone:YES];
    
    if (autorelease) {
        [result_ autorelease];
    }
    return result_;
}

- (void)manipulateUsingBlock
{
    result_ = block_(node_);
    [result_ retain];
}

+ (id)manipulateNode:(DOMNode *)node
       usingFunction:(id (*)(DOMNode *))function
{
    return [[[[[self class] alloc] init] autorelease] manipulateNode:node
                                                       usingFunction:function
                                                         autorelease:YES];
}

- (id)manipulateNode:(DOMNode *)node
       usingFunction:(id (*)(DOMNode *))function
         autorelease:(BOOL)autorelease
{
    node_ = node;
    function_ = function;
    [self performSelectorOnMainThread:@selector(manipulateUsingFunction)
                           withObject:nil
                        waitUntilDone:YES];
    // autorelease の理由は manipulateUsingFunction のコメントを参照
    if (autorelease) {
        [result_ autorelease];
    }
    return result_;
}

- (void)manipulateUsingFunction
{
    result_ = function_(node_);
    // result_ はメインスレッドの autorelease pool に登録されているかもしれない。
    // しかし result_ はメインスレッド以外のスレッドに渡されるので、
    // 予期せぬ時点でメインスレッドの pool に解放されうる。
    // そこで一旦 retain しておき、後で改めて別の pool に登録する。
    [result_ retain];
}

@end


inline id TKDOMManip(DOMNode *node, TKDOMManipBlock block)
{
    return [TKDOMManipulator manipulateNode:node
                                 usingBlock:block];
}
