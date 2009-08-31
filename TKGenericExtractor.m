//
//  TKGenericExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "TKGenericExtractor.h"
#import "TKPost.h"


@implementation TKGenericVideoExtractor

- (NSString *)title { return @"Video"; }

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([[[source URL] host] hasSuffix:@".youtube.com"] &&
            [[[source URL] path] isEqualTo:@"/watch"]);
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType];
    [post setPageURL:[source URL]];
    [post setPageTitle:[source title]];
    [post setURL:[source URL]];
    [post setBody:[source text]];
    
    DOMDocument *doc =[[source node] ownerDocument];
    DOMXPathResult *res = [doc evaluate:@"//h1/text()"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:NULL];
    NSString *title = [(DOMText *)[res singleNodeValue] nodeValue];
    [post setTitle:title];
    
    return [post autorelease];
}

@end


@implementation TKGenericImageExtractor

- (NSString *)title { return @"Image"; }

- (BOOL)acceptsSource:(TKSource *)source
{
    return [source sourceURL] != nil;
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostImageType];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    [post setPageURL:[source URL]];
    [post setLinkURL:[source linkURL]];
    [post setURL:[source sourceURL]];
    return [post autorelease];
}

@end


@implementation TKGenericQuoteExtractor

- (NSString *)title { return @"Text"; }

- (BOOL)acceptsSource:(TKSource *)source
{
    return [source text] != nil && ! [[source text] isEqualToString:@""];
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostQuoteType];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    [post setPageURL:[source URL]];
    return [post autorelease];
}

@end


@implementation TKGenericLinkExtractor

- (NSString *)title { return @"Link"; }

- (BOOL)acceptsSource:(TKSource *)source
{
    return YES;
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostLinkType];
    
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


