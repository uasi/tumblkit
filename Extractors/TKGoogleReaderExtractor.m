//
//  TKGoogleReaderExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/12/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "TKGoogleReaderExtractor.h"

#import "DOM.h"


static DOMNode *entryNode(DOMNode *node);
static id extractURL(DOMNode *node);
static id extractTitle(DOMNode *node);
static id extractBody(DOMNode *node);


@implementation TKGoogleReaderExtractor

- (NSString *)title
{
    return @"Link (Google Reader)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    BOOL isReader = ([[[source URL] absoluteString] hasPrefix:
                      @"http://www.google.com/reader/view"] ||
                     [[[source URL] absoluteString] hasPrefix:
                      @"http://www.google.co.jp/reader/view"]);
    return isReader && entryNode([source node]);
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostLinkType
                                         source:source];
    NSString *title = [TKDOMManipulator manipulateNode:[source node]
                                         usingFunction:extractTitle];
    [post setTitle:title];
    NSURL *pageURL = [TKDOMManipulator manipulateNode:[source node]
                                        usingFunction:extractURL];
    [post setPageURL:pageURL];
    [post setURL:pageURL];
    NSString *body = [TKDOMManipulator manipulateNode:[source node]
                                        usingFunction:extractBody];
    [post setBody:body];
    return [post autorelease];
}


static DOMNode *entryNode(DOMNode *node)
{
    NSString *xpath = @"ancestor-or-self::div[starts-with(@class, \"entry \")]";
    return [node tk_nodeForXPath:xpath];
}

static id extractURL(DOMNode *node)
{
    NSString *xpath = @".//a[@class=\"entry-original\" or"
                      @"     @class=\"entry-title-link\"]/@href";
    NSString *URLString = [[entryNode(node) tk_nodeForXPath:xpath] nodeValue];
    return [NSURL URLWithString:URLString];
}

static id extractTitle(DOMNode *node)
{
    NSString *xpath = @".//h2[@class=\"entry-title\"]";
    return [(DOMHTMLElement *)[entryNode(node) tk_nodeForXPath:xpath] innerText]; 
}

static id extractBody(DOMNode *node)
{
    NSString *xpath = @".//span[@class=\"snippet\"] |"
                      @".//div[@class=\"item-body\"]/div";
    return [(DOMHTMLElement *)[entryNode(node) tk_nodeForXPath:xpath] innerText];
}

@end
