//
//  TKExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKExtractor.h"
#import "TKGenericExtractor.h"


@implementation TKExtractor

+ (NSArray *)extractors
{
    static NSArray *extractorClasses;
    if (extractorClasses == nil) {
        extractorClasses = [[NSArray alloc] initWithObjects:
                            [TKGenericVideoExtractor class],
                            [TKGenericQuoteExtractor class],
                            [TKGenericImageExtractor class],
                            [TKGenericLinkExtractor class],
                            nil];
    }
    NSMutableArray *extractors = [NSMutableArray array];
    for (Class klass in extractorClasses) {
        [extractors addObject:[[(TKExtractor *)[klass alloc] init] autorelease]];
    }
    return extractors;
}

+ (NSArray *)extractorsForSource:(TKSource *)source
{
    NSMutableArray *extractors = [NSMutableArray array];
    for (TKExtractor *extractor in [[self class] extractors]) {
        if ([extractor acceptsSource:source]) {
            [extractors addObject:extractor];
        }
    }
    return extractors;
}

- (NSString *)title
{
    return @"TITLE";
}

- (BOOL)acceptsSource:(TKSource *)source
{
    return NO;
}

- (TKPost *)postFromSource:(TKSource *)source
{
    return [[[TKPost alloc] init] autorelease];
}

- (TKDeferredPost *)deferredPostFromSource:(TKSource *)source
{
    return [TKDeferredPost deferredPostWithSource:source extractor:self];
}

@end
