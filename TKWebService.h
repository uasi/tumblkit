//
//  TKWebService.h
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TKWebService : NSObject {}
+ (void)registerAsObserver;
+ (id)sharedWebService;
- (void)postWithNotification:(NSNotification *)notification;
@end

@interface TKTumblrWebService : TKWebService {}
@end
