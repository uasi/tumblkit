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
    TKPost *post = [[TKPost alloc] initWithType:TKPostVideoType
                                         source:source];
    [post autorelease];
    [post setTitle:[source title]];
    [post setBody:[source text]];
    
    NSString *videoID = [[[[source URL] path] componentsSeparatedByString:@"/"] lastObject];
    // Embed code for Nicovideo version 9.
    NSString *snippet = [NSString stringWithFormat:
                         @"<iframe width='312' height='176'"
                         @" src='http://ext.nicovideo.jp/thumb/%@'"
                         @" scrolling='no' style='border:solid 1px #CCC;'"
                         @" frameborder='0'>"
                         @"<a href='%@'>%@</a></iframe>",
                         videoID,
                         [source URL],
                         [source title]];
    [post setObject:snippet];
    
    return post;
}

@end
