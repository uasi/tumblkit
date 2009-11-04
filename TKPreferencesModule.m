//
//  TKPreferencesModule.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPreferencesModule.h"


@implementation TKPreferencesModule

- (NSImage *)imageForPreferenceNamed:(id)arg1
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)preferencesNibName
{
    return @"TKPreferencesModule";
}

@end
