//
//  DOMNode+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2011 isdead.info. All rights reserved.
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
        [nodes addObject:[res snapshotItem:(unsigned int)i]];
    }
    return nodes;
    
}

- (DOMHTMLElement *)tk_elementForXPath:(NSString *)xpath
{
    return (DOMHTMLElement *)[self tk_nodeForXPath:xpath];
}

- (NSArray *)tk_elementsForXPath:(NSString *)xpath
{
    return [self tk_nodesForXPath:xpath];
}

@end
