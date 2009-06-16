//
//  TKExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKExtractor.h"


@implementation TKExtractor

@synthesize nextExtractor = nextExtractor_;

- (NSString *)title { return @"TITLE"; }

- (id)initWithNextExtractor:(TKExtractor *)nextExtractor
{
    [self init];
    nextExtractor_ = [nextExtractor retain];
    return self;
}

- (void)dealloc
{
    [nextExtractor_ release];
    [super dealloc];
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

- (BOOL)registerToRegistory:(id <TKRegistory>)registory
            ifAcceptsSource:(TKSource *)source
{
    if ([self acceptsSource:source]) {
        [registory registerObject:self];
        return YES;
    }
    return NO;
}

- (void)registerExtractorsToRegistory:(id <TKRegistory>)registory
                      ifAcceptsSource:(TKSource *)source
{
    [self registerToRegistory:registory ifAcceptsSource:source];
    if ([self nextExtractor] != nil) {
        [[self nextExtractor] registerExtractorsToRegistory:registory ifAcceptsSource:source];
    }
}


@end
