//
//  TKBundleController.h
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSBundle *TKBundle; /* Shared bundle instance */

@class TKEditPanelController;
@interface TKBundleController : NSObject {
    IBOutlet TKEditPanelController *editPanelController;
}

@property(readonly) TKEditPanelController *editPanelController;

+ (NSBundle *)bundle;
+ (id)sharedBundleController;
+ (void)swizzleInstanceMethod:(SEL)aMethod
                   withMethod:(SEL)otherMethod
                      ofClass:(Class)theClass;

@end
