//
//  TKExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKExtractor.h"
#import "TKGenericExtractor.h"
#import "TKDailymotionExtractor.h"
#import "TKNicoVideoExtractor.h"
#import "TKTwitterExtractor.h"


@interface TKExtraction ()

- (id)initWithExtractor:(TKExtractor *)extractor
                 source:(TKSource *)source;

@end


@implementation TKExtractor

+ (NSArray *)extractors
{
    static NSArray *extractorClasses;
    if (extractorClasses == nil) {
        extractorClasses = [[NSArray alloc] initWithObjects:
                            [TKDailymotionExtractor class],
                            [TKNicoVideoExtractor class],
                            [TKTwitterExtractor class],
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

- (TKExtraction *)extractionForSource:(TKSource *)source
{
    TKExtraction *extraction = [[TKExtraction alloc] initWithExtractor:self
                                                                source:source];
    return [extraction autorelease];
}

@end


@implementation TKExtraction

- (id)initWithExtractor:(TKExtractor *)extractor
                 source:(TKSource *)source
{
    [self init];
    extractor_ = [extractor retain];
    source_ = [source retain];
    return self;
}

- (TKPost *)postByInvokingExtraction
{
    return [extractor_ postFromSource:source_];
}

- (void)dealloc
{
    [extractor_ release];
    [source_ release];
    [super dealloc];
}

@end
