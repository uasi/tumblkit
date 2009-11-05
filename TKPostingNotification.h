//
//  TKPostingNotification.h
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define TKPostingNotification @"TKPostingNotification"

@class TKPost;
@interface TKPostingNotifier : NSObject {
}

+ (id)sharedNotifier;

- (void)notify:(id)sender;
- (void)notifyWithPost:(TKPost *)post;

@end
