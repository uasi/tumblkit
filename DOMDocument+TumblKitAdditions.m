//
//  DOMDocument+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "DOMDocument+TumblKitAdditions.h"


@implementation DOMDocument (TumblKitAdditions)
 
- (DOMNode *)tk_firstNodeByEvaluatingXPath:(NSString *)xpath
{
    return [self tk_firstNodeByEvaluatingXPath:xpath
                               withContextNode:self];
}

- (DOMNode *)tk_firstNodeByEvaluatingXPath:(NSString *)xpath
                           withContextNode:(DOMNode*)contextNode
{
    DOMXPathResult *res = [self evaluate:xpath
                             contextNode:contextNode
                                resolver:nil
                                    type:DOM_FIRST_ORDERED_NODE_TYPE
                                inResult:nil];
    return [res singleNodeValue];
}

@end
