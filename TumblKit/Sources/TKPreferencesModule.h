//
//  TKPreferencesModule.h
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSPreferences.h"


@interface TKPreferencesModule : NSPreferencesModule {
    NSMutableDictionary *preferences_;
}

@property(readonly) NSMutableDictionary *preferences;

- (void)discardChanges;

@end
