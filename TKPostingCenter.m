//
//  TKPostingCenter.m
//  TumblKitNG
//
//  Created by uasi on 09/06/09.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKPostingCenter.h"
#import "TKPost.h"

#define TKPostingNotification @"TKPostingNotification"


@implementation TKPostingCenter

- (void)post:(NSMenuItem *)sender
{
    TKPost *post = [(TKDeferredPost *)[sender representedObject] post];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKPostingNotification
                                                        object:post];
}

@end
