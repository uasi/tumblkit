//
//  TKPost.m
//  TumblKitNG
//
//  Created by uasi on 09/06/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPost.h"
#import "TKExtractor.h"
#import "TKSource.h"


@implementation TKPost

@synthesize type = type_;
@synthesize title = title_;
@synthesize body = body_;
@synthesize URL = URL_;
@synthesize alternateURL = alternateURL_;
@synthesize linkURL = linkURL_;
@synthesize tags = tags_;
@synthesize isPrivate = isPrivate_;

- (id)initWithType:(TKPostType)type
{
    [self init];
    type_ = type;
    return self;
}

- (void)dealloc
{
    [title_ release];
    [body_ release];
    [URL_ release];
    [alternateURL_ release];
    [linkURL_ release];
    [tags_ release];
    [super dealloc];
}

@end


@implementation TKDeferredPost

@dynamic post;

- (id)initWithSource:(TKSource *)source
           extractor:(TKExtractor *)extractor
{
    [self init];
    source_ = [source retain];
    extractor_ = [extractor retain];
    return self;
}

+ (id)deferredPostWithSource:(TKSource *)source
                   extractor:(TKExtractor *)extractor
{
    return [[[TKDeferredPost alloc] initWithSource:source extractor:extractor] autorelease];
}

- (void)dealloc
{
    [source_ release];
    [extractor_ release];
    if (post_ != nil) {
        [post_ release];
    }
    [super dealloc];
}

- (TKPost *)post
{
    if (post_ == nil) {
        post_ = [[extractor_ postFromSource:source_] retain];
    }
    return post_;
}
        
@end
