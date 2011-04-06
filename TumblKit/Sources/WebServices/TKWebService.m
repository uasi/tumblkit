//
//  TKWebService.m
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKWebService.h"
#import "TKPost.h"

#import "TKTumblrWebService.h"


@implementation TKWebService

+ (NSArray *)webServiceClasses
{
    static id webServiceClasses = nil;
    if (webServiceClasses == nil) {
        webServiceClasses = [[NSArray alloc] initWithObjects:
                       [TKTumblrWebService class],
                       nil];
    }
    return webServiceClasses;
}

+ (void)postToWebServices:(TKPost *)post
{
    for (Class webServiceClass in [[self class] webServiceClasses]) {
        [webServiceClass postInBackground:post];
    }
}

+ (void)postInBackground:(TKPost *)post
{
    id webService = [[[[self class] alloc] init] autorelease];
    [webService performSelectorInBackground:@selector(post:)
                                 withObject:post];
}

- (void)post:(TKPost *)post
{
    NSLog(@"TumblKit: Abstract method -[TKWebService post:] called");
}

@end


