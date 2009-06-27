//
//  TKGrowlHelper.h
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/GrowlApplicationBridge.h>


@interface TKGrowlHelper : NSObject <GrowlApplicationBridgeDelegate> {
    
}

+ (void)loadGrowlForBundle:(NSBundle *)bundle;
+ (TKGrowlHelper *)sharedGrowlHelper;
- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description;

@end
