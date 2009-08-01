//
//  TKDOMUtil.m
//  TumblKitNG
//
//  Created by uasi on 09/07/29.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "TKDOMUtil.h"

NSArray *TKCreateDictionaryWithForm_visitor(DOMNode *node, void *info);


// Stolen from Mochikit.DOM.formContents()
NSDictionary *TKCreateDictionaryWithForm(DOMElement *formElem)
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    TKDOMNodeWalk(formElem, TKCreateDictionaryWithForm_visitor, params);
    return params;
}

#define PUSH_VALUE_FOR_KEY(dict, value, key) \
    do { \
        if ([dict objectForKey:(key)] == nil) { \
            [dict setObject:[NSMutableArray array] forKey:key]; \
        } \
        [(NSMutableArray *)[dict objectForKey:key] addObject:value]; \
    } while (0)

NSArray *TKCreateDictionaryWithForm_visitor(DOMNode *node, void *info)
{
    
    if ([node nodeType] != DOM_ELEMENT_NODE) {
        return nil;
    }
    DOMElement *elem = (DOMElement *)node;
    NSMutableDictionary *params = info;
    if (! [elem hasAttribute:@"name"]) {
        return TKCreateArrayWithNodeList([elem childNodes]);
    }
    NSString *name = [elem getAttribute:@"name"];
    if (name == nil || [name isEqualToString:@""]) {
        return TKCreateArrayWithNodeList([elem childNodes]);
    }
    NSString *tagName = [[elem tagName] uppercaseString];
    DOMHTMLInputElement *input;
    DOMHTMLSelectElement *select;
    if ([tagName isEqualToString:@"INPUT"]
        && (input = (DOMHTMLInputElement *)elem)
        && ([[input type] isEqualToString:@"radio"]
            || [[input type] isEqualToString:@"checkbox"])
        && ! [input checked]
    ) {
        return nil;
    }
    if ([tagName isEqualToString:@"SELECT"]
        && (select = (DOMHTMLSelectElement *)elem)) {
        if ([[select type] isEqualToString:@"select-one"]) {
            if ([select selectedIndex] > 0) {
                DOMHTMLOptionElement *opt;
                opt = (DOMHTMLOptionElement *)[[select options] item:
                                               [select selectedIndex]];
                NSString *v = [opt value];
                if (v == nil || [v isEqualToString:@""]) {
                    v = [opt text];
                }
                PUSH_VALUE_FOR_KEY(params, v, name);
                return nil;
            }
            PUSH_VALUE_FOR_KEY(params, @"", name);
            return nil;
        }
        else {
            DOMHTMLOptionsCollection *opts = [select options];
            if (! [opts length]) {
                PUSH_VALUE_FOR_KEY(params, @"", name);
                return nil;
            }
            NSUInteger i;
            for (i = 0; i < [opts length]; i++) {
                DOMHTMLOptionElement *opt = (DOMHTMLOptionElement *)[opts item:i];
                if (! [opt selected]) {
                    continue;
                }
                NSString *v = [opt value];
                if (v == nil || [v isEqualToString:@""]) {
                    v = [opt text];
                }
                PUSH_VALUE_FOR_KEY(params, v, name);
            }
            return nil;
        }
    }
    if ([tagName isEqualToString:@"FORM"]
        || [tagName isEqualToString:@"P"]
        || [tagName isEqualToString:@"SPAN"]
        || [tagName isEqualToString:@"DIV"]
        ) {
        return TKCreateArrayWithNodeList([elem childNodes]);
    }
    PUSH_VALUE_FOR_KEY(params, [elem value] ? [elem value] : @"", name);
    return nil;
}

// Stolen from MochiKit.Base.nodeWalk()
void TKDOMNodeWalk(
                   DOMNode *node,
                   NSArray *(*visitor)(DOMNode *node, void *info),
                   void *info
)
{
    NSMutableArray *nodes = [NSMutableArray arrayWithObject:node];
    NSArray *res;
    while ([nodes count] > 0) {
        node = [nodes objectAtIndex:0];
        [nodes removeObjectAtIndex:0];
        res = visitor(node, info);
        if (res) {
            [nodes addObjectsFromArray:res];
        }
    }
}

NSArray *TKCreateArrayWithNodeList(DOMNodeList *nodeList)
{
    NSUInteger length = [nodeList length];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        [array insertObject:[nodeList item:i] atIndex:i];
    }
    return array;
}