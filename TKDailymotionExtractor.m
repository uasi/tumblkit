//
//  TKDailymotionExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKDailymotionExtractor.h"


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

- (TKPost *)postFromSource:(TKSource *)source
{
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType];
    [post autorelease];
    [post setPageURL:[source URL]];
    [post setPageTitle:[source title]];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    
    NSString *xpath = @"//input[@id=\"video_player_embed_code_text\"]/@value";
    DOMNode *node = [[[source node] ownerDocument] tk_firstNodeByEvaluatingXPath:xpath];
    NSString* embedCode = [node value];
    [post setObject:embedCode];
    
    return post;
}


@end
