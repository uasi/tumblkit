//
//  TKTwitterExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/11/01.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKTwitterExtractor.h"
#import "DOM.h"


static void *extractStatusURL(DOMNode *node);
static void *extractTitle(DOMNode *doc);
static void *extractStatus(DOMNode *doc);


@implementation TKTwitterExtractor

- (NSString *)title
{
    return @"Text (Twitter)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    if (![[[source URL] host] isEqualToString:@"twitter.com"]) {
        return NO;
    }
    
    if ([[[source URL] path] rangeOfString:@"/status/"].location == NSNotFound) {
        return extractStatusURL([source node]) != nil;
    }
    else {
        return YES;
    }
}

- (TKPost *)postFromSource:(TKSource *)source
{
    DOMDocument *doc;
    NSString *statusURLString;
    if ([[[source URL] path] rangeOfString:@"/status/"].location != NSNotFound) {
        doc = [TKDOMManipulator ownerDocumentOfNode:[source node]];
        [doc performSelectorOnMainThread:@selector(retain)
                              withObject:nil
                           waitUntilDone:YES];
        statusURLString = [[source URL] absoluteString];
    }
    else {
        statusURLString = [TKDOMManipulator manipulateDOMNode:[source node]
                                                usingFunction:extractStatusURL];
        doc = [[TKDOMMaker DOMMaker] newDOMDocumentWithURLString:statusURLString];
    }

    NSString *title = [TKDOMManipulator manipulateDOMNode:doc
                                            usingFunction:extractTitle]; 
    NSString *status = [TKDOMManipulator manipulateDOMNode:doc
                                             usingFunction:extractStatus];
    TKPost *post = [[TKPost alloc] initWithType:TKPostQuoteType
                                         source:source];
    [post autorelease];
    [post setPageURL:[NSURL URLWithString:statusURLString]];
    [post setTitle:title];
    [post setBody:status];
    
    [[TKDOMMaker DOMMaker] releaseDOM:doc];
    
    return post;
}
 
 
static void *extractStatusURL(DOMNode *node)
{
    NSString *xpath = @"./ancestor-or-self::li[contains(@class, \"hentry\")]//"
    @"a[@class=\"entry-date\"]/@href";
    return [[node tk_nodeForXPath:xpath] nodeValue];
}

static void *extractTitle(DOMNode *doc)
{
    NSString *xpath = @"/html/head/title";
    return [(DOMHTMLElement *)[doc tk_nodeForXPath:xpath] innerText];
}

static void *extractStatus(DOMNode *doc)
{
    NSString *xpath = @"//span[@class=\"entry-content\"]";
    return [(DOMHTMLElement *)[doc tk_nodeForXPath:xpath] innerHTML];
}

@end
