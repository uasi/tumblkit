//
//  TKPostingNotification.m
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPostingNotification.h"
#import "TKPost.h"


@implementation TKPostingNotifier

+ (id)sharedNotifier
{
    id sharedNotifier = nil;
    if (sharedNotifier == nil) {
        sharedNotifier = [[self alloc] init];
    }
    return sharedNotifier;
}

- (IBAction)notify:(id)sender
{
    TKPost *post = [(TKDeferredPost *)[(NSMenuItem *)sender representedObject] post];
    [self notifyWithPost:post];
}

- (void)notifyWithPost:(TKPost *)post
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:post forKey:@"post"];
    NSNotification *notification = [NSNotification notificationWithName:TKPostingNotification
                                                                 object:nil
                                                               userInfo:userInfo];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP];
}

@end
