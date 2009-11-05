//
//  TKWebService.m
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKWebService.h"
#import "TKPost.h"
#import "TKPostingNotification.h"


@implementation TKWebService

+ (void)registerAsObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(postWithNotification:)
                                                 name:TKPostingNotification
                                               object:nil];
}

+ (void)postWithNotification:(NSNotification *)notification
{
}

@end


