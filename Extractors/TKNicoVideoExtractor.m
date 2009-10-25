//
//  TKNicoVideoExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/10/26.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKNicoVideoExtractor.h"


@implementation TKNicoVideoExtractor

- (NSString *)title
{
    return @"Video (Niconico)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([[[source URL] host] hasSuffix:@".nicovideo.jp"] &&
            [[[source URL] path] hasPrefix:@"/watch/"]);
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType];
    [post setPageURL:[source URL]];
    [post setPageTitle:[source title]];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    
    DOMDocument *doc =[[source node] ownerDocument];
    DOMXPathResult *res = [doc evaluate:@"//form[@name='form_iframe']/input/@value"
                            contextNode:doc
                               resolver:nil
                                   type:DOM_FIRST_ORDERED_NODE_TYPE
                               inResult:NULL];
    NSString *iframe = [(DOMText *)[res singleNodeValue] nodeValue];
    [post setObject:iframe];
    
    return [post autorelease];
}

@end
