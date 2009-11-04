//
//  DOMNode+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface DOMNode (TumblKitAdditions)
- (DOMNode *)tk_nodeForXPath:(NSString *)xpath;
@end
