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

@end
