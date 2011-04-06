//
//  TKVimeoExtractor.m
//  TumblKit
//
//  Created by uasi on 11/04/04.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKVimeoExtractor.h"
#import "DOM.h"
#import "CommonAdditions.h"


@implementation TKVimeoExtractor

- (NSString *)title {
    return @"Video (Vimeo)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    BOOL isVimeo = [[source URL] tk_hostMatchesTo:@"vimeo.com"];
    BOOL hasVideoID = [[[[source URL] path] substringFromIndex:1] integerValue] > 0;
    return isVimeo && hasVideoID;
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
