//
//  DOMDocument+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface DOMDocument (TumblKitAdditions) 

- (DOMNode *)tk_firstNodeByEvaluatingXPath:(NSString *)xpath;
- (DOMNode *)tk_firstNodeByEvaluatingXPath:(NSString *)xpath
                           withContextNode:(DOMNode *)contextNode;
//- (NSArray *)tk_orderedNodesByEvaluatingXPath:(NSString *)xpath;

@end
