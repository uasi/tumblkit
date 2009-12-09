//
//  DOMNode+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "DOMNode+TumblKitAdditions.h"


@implementation DOMNode (TumblKitAdditions)

- (DOMNode *)tk_nodeForXPath:(NSString *)xpath
{
    DOMDocument *doc = [self ownerDocument];
    if (doc == nil) {
        doc = (DOMDocument *)self;
    }
    DOMXPathResult *res = [doc evaluate:xpath
                            contextNode:self
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:nil];
    return [res singleNodeValue];
}

- (NSArray *)tk_nodesForXPath:(NSString *)xpath
{
    DOMDocument *doc = [self ownerDocument];
    if (doc == nil) {
        doc = (DOMDocument *)self;
    }
    DOMXPathResult *res = [doc evaluate:xpath
                            contextNode:self
                               resolver:nil
                                   type:DOM_ORDERED_NODE_SNAPSHOT_TYPE
                               inResult:nil];
    NSMutableArray *nodes = [NSMutableArray array];
    NSUInteger len = [res snapshotLength];
    for (NSUInteger i = 0; i < len; i++) {
        [nodes addObject:[res snapshotItem:i]];
    }
    return nodes;
    
}

@end
