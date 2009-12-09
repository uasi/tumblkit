//
//  TKDailymotionExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKDailymotionExtractor.h"
#import "DOM.h"


@implementation TKDailymotionExtractor

- (NSString *)title
{
    return @"Video (Dailymotion)";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return ([[[source URL] host] isEqualToString:@"www.dailymotion.com"] &&
            [[[source URL] path] hasPrefix:@"/video/"]);
}

static void *extractEmbedCode(DOMNode *node)
{
    NSString *xpath = @"//input[@id=\"video_player_embed_code_text\"]/@value";
    return [[[node ownerDocument] tk_nodeForXPath:xpath] nodeValue];
}

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType
                                         source:source];
    [post autorelease];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    
    NSString *embedCode = [TKDOMManipulator manipulateNode:[source node]
                                             usingFunction:extractEmbedCode];
    [post setObject:embedCode];
    
    return post;
}


@end
