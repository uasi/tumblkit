//
//  TKPreferencesModule.m
//  TumblKitNG
//
//  Created by uasi on 09/11/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPreferencesModule.h"


#define DOMAIN_NAME @"org.99cm.TumblKit"


@implementation TKPreferencesModule

@synthesize preferences = preferences_;

- (id)init
{
    self = [super init];
    preferences_ = [[[NSUserDefaults standardUserDefaults]
                     persistentDomainForName:DOMAIN_NAME] mutableCopy];
    if (preferences_ == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserDefaults"
                                                         ofType:@"plist"];
        preferences_ = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

- (void)dealloc
{
    [preferences_ release];
    [super dealloc];
}

- (void)saveChanges
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:preferences_
                                                       forName:DOMAIN_NAME];
}

- (void)discardChanges
{
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME];
    [preferences_ removeAllObjects];
    [preferences_ addEntriesFromDictionary:dictionary];
}

- (NSImage *)imageForPreferenceNamed:(id)arg1
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)preferencesNibName
{
    return @"TKPreferencesModule";
}

@end
