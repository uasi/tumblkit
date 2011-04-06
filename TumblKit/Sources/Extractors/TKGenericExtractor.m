//
//  TKGenericExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKGenericExtractor.h"
#import "DOM.h"


@implementation TKGenericVideoExtractor

- (NSString *)title {
    return @"Video (YouTube)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([[[source URL] host] hasSuffix:@".youtube.com"] &&
            [[[source URL] path] isEqualTo:@"/watch"]);
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType
                                         source:source];
    [post setTitle:[source title]];
    [post setURL:[source URL]];
    [post setBody:[source text]];
    
    NSString *title = TKDOMManip([source node], ^(DOMNode *node) {
        NSString *xpath = @"/html/head/meta[@name=\"title\"]/@content";
        return [[[node ownerDocument] tk_nodeForXPath:xpath] nodeValue];
    });
    [post setTitle:(title != nil ? title : @"")];
    
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
