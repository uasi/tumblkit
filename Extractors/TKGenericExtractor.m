//
//  TKGenericExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKGenericExtractor.h"
#import "DOM.h"


@implementation TKGenericVideoExtractor

- (NSString *)title {
    return @"Video";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([[[source URL] host] hasSuffix:@".youtube.com"] &&
            [[[source URL] path] isEqualTo:@"/watch"]);
}

static void *extractTitle(DOMNode *node)
{
    return [[[node ownerDocument] tk_nodeForXPath:@"//h1/text()"] nodeValue];
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType
                                         source:source];
    [post setTitle:[source title]];
    [post setURL:[source URL]];
    [post setBody:[source text]];
    
    NSString *title = [TKDOMManipulator manipulateDOMNode:[source node]
                                            usingFunction:extractTitle];
    [post setTitle:title];
    
    return [post autorelease];
}

@end


@implementation TKGenericImageExtractor

- (NSString *)title {
    return @"Image";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return [source sourceURL] != nil;
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostImageType
                                         source:source];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    [post setLinkURL:[source linkURL]];
    [post setURL:[source sourceURL]];
    return [post autorelease];
}

@end


@implementation TKGenericQuoteExtractor

- (NSString *)title {
    return @"Text";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return [source text] != nil && ! [[source text] isEqualToString:@""];
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostQuoteType
                                         source:source];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    return [post autorelease];
}

@end


@implementation TKGenericLinkExtractor

- (NSString *)title {
    return @"Link";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return YES;
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostLinkType
                                         source:source];
    
    /* This behavior may be confusing... */
    
    if ([source linkURL] != nil) {
        if ([source text] != nil && ! [[source text] isEqualToString:@""]) {
            [post setTitle:[source text]];
        }
        else {
            [post setTitle:[[source linkURL] absoluteString]];
        }
        [post setPageURL:[source linkURL]];
        [post setBody:[source linkLabel]];
    }
    else {
        [post setTitle:[source title]];
        [post setPageURL:[source URL]];
        [post setBody:[source text]];
    }
    return [post autorelease];
}

@end


