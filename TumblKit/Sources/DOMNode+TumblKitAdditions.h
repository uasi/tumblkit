//
//  DOMNode+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface DOMNode (TumblKitAdditions)
- (DOMNode *)tk_nodeForXPath:(NSString *)xpath;
- (NSArray *)tk_nodesForXPath:(NSString *)xpath;
- (DOMHTMLElement *)tk_elementForXPath:(NSString *)xpath;
- (NSArray *)tk_elementsForXPath:(NSString *)xpath;
@end
