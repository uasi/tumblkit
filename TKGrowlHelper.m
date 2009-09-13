//
//  TKGrowlHelper.m
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKGrowlHelper.h"


#define TUBMLKIT_NOTIFICATION @"TumblKitNotification"

@implementation TKGrowlHelper

+ (void)loadGrowlForBundle:(NSBundle *)bundle
{
    NSString *growlPath = [[bundle privateFrameworksPath]
                           stringByAppendingPathComponent:@"Growl.framework"];
    NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
    if (growlBundle) {
        [growlBundle load];
    }
    else {
        NSLog(@"Could not load Growl.framework");
    }
}

+ (TKGrowlHelper *)sharedGrowlHelper
{
    static TKGrowlHelper *sharedGrowlHelper;
    if (sharedGrowlHelper == nil) {
        sharedGrowlHelper = [[TKGrowlHelper alloc] init];
    }
    return sharedGrowlHelper;
}

- (id)init
{
    self = [super init];
    [GrowlApplicationBridge setGrowlDelegate:self];
    return self;
}

- (void)dealloc
{
    [GrowlApplicationBridge setGrowlDelegate:(NSString <GrowlApplicationBridgeDelegate>*)@""];
    [super dealloc];
}

- (NSDictionary *) registrationDictionaryForGrowl
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSArray arrayWithObject:TUBMLKIT_NOTIFICATION],
                          GROWL_NOTIFICATIONS_ALL,
                          [NSArray arrayWithObject:TUBMLKIT_NOTIFICATION],
                          GROWL_NOTIFICATIONS_DEFAULT,
                          nil];
    return dict;
}

- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
{
    [GrowlApplicationBridge notifyWithTitle:title
                                description:description
                           notificationName:TUBMLKIT_NOTIFICATION
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
}

@end
