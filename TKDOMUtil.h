//
//  TKDOMUtil.h
//  TumblKitNG
//
//  Created by uasi on 09/07/29.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSDictionary *TKCreateDictionaryWithForm(DOMElement *formElem);
void TKDOMNodeWalk(
                   DOMNode *node,
                   NSArray *(*visitor)(DOMNode *node, void *info),
                   void *info
);
NSArray *TKCreateArrayWithNodeList(DOMNodeList *nodeList);