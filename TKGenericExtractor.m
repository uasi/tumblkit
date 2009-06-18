//
//  TKGenericExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKGenericExtractor.h"
#import "TKPost.h"

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
    [post setURL:[source URL]];
    [post setLinkURL:[source linkURL]];
    [post setAlternateURL:[source sourceURL]];
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
    [post setURL:[source URL]];
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
        [post setURL:[source linkURL]];
        /* Let's not setBody: */
    }
    else {
        [post setTitle:[source title]];
        [post setURL:[source URL]];
        [post setBody:[source text]];
    }
    return [post autorelease];
}

@end


