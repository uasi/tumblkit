//
//  TKBundleController.h
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSBundle *TKBundle; /* Shared bundle instance */

@class TKEditPanelController;
@interface TKBundleController : NSObject {
    IBOutlet TKEditPanelController *editPanelController;
}

+ (NSBundle *)bundle;
+ (id)sharedBundleController;
+ (void)swizzleInstanceMethod:(SEL)aMethod
                   withMethod:(SEL)otherMethod
                      ofClass:(Class)theClass;

@property(readonly) TKEditPanelController *editPanelController;

@end
