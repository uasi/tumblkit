//
//  TKPost.m
//  TumblKitNG
//
//  Created by uasi on 09/06/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPost.h"
#import "TKSource.h"


@implementation TKPost

@synthesize type = type_;
@synthesize isPrivate = isPrivate_;
@synthesize tags = tags_;

@synthesize pageTitle = pageTitle_;
@synthesize pageURL = pageURL_;

@synthesize authorName = authorName_;
@synthesize authorURL = authorURL_;

@synthesize title = title_;
@synthesize body = body_;
@synthesize object = object_;
@synthesize URL = URL_;
@synthesize linkURL = linkURL_;

- (id)initWithType:(TKPostType)type
{
    self = [super init];
    type_ = type;
    return self;
}

- (id)initWithType:(TKPostType)type
            source:(TKSource *)source
{
    [self initWithType:type];
    [self setPageURL:[source URL]];
    [self setPageTitle:[source title]];
    return self;
}

- (void)dealloc
{
    [tags_ release];

    [pageTitle_ release];
    [pageURL_ release];
    
    [authorName_ release];
    [authorURL_ release];
    
    [title_ release];
    [body_ release];
    [object_ release];
    [URL_ release];
    [linkURL_ release];

    [super dealloc];
}

@end
