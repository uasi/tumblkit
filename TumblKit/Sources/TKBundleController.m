//
//  TKBundleController.m
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2011 isdead.info. All rights reserved.
//


#import <objc/runtime.h>

#import "SUUpdateAlert+TumblKitAdditions.h"
#import <Sparkle/Sparkle.h>

#import "TKBundleController.h"
#import "WebHTMLView+TumblKitAdditions.h"
#import "TKTumblrWebService.h"
#import "TKGrowlHelper.h"
#import "TKPreferencesModule.h"


NSBundle *TKBundle; /* Shared bundle instance */

@implementation TKBundleController

@synthesize editPanelController;

+ (void)load
{
    TKBundle = [TKBundleController bundle];
    [TKBundleController swizzleInstanceMethod:@selector(menuForEvent:)
                                   withMethod:@selector(tk_menuForEvent:)
                                      ofClass:[WebHTMLView class]];
    
    [TKGrowlHelper loadGrowlForBundle:TKBundle];
    [SUUpdater updaterForBundle:TKBundle];
    
    [NSPreferences setDefaultPreferencesClass:NSClassFromString(@"WBPreferences")];
    NSPreferences *prefs = [NSPreferences sharedPreferences];
    [prefs addPreferenceNamed:@"TumblKit"
                        owner:[TKPreferencesModule sharedInstance]];

    NSLog(@"TumblKit loaded");    
}

+ (id)sharedBundleController
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
        [NSBundle loadNibNamed:@"TKEditPanel" owner:instance];
    }
    return instance;
}

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleForClass:self];
    }
    return bundle;
}

+ (void)swizzleInstanceMethod:(SEL)aSelector
                   withMethod:(SEL)otherSelector
                      ofClass:(Class)theClass
{
    Method orig = class_getInstanceMethod(theClass, aSelector);
    Method alt = class_getInstanceMethod(theClass, otherSelector);
    method_exchangeImplementations(orig, alt);
}

@end
