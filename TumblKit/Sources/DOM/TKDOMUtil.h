//
//  TKDOMUtil.h
//  TumblKitNG
//
//  Created by uasi on 09/07/29.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "DOMNode+TumblKitAdditions.h"


NSDictionary *TKCreateDictionaryWithForm(DOMElement *formElem);
void TKDOMNodeWalk(
                   DOMNode *node,
                   NSArray *(*visitor)(DOMNode *node, void *info),
                   void *info
);
NSArray *TKCreateArrayWithNodeList(DOMNodeList *nodeList);


