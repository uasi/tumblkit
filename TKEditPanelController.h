//
//  TKEditPanelController.h
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TKPost.h"


@interface TKEditPanelController : NSWindowController {
    
    IBOutlet NSTabView *tabView;
    TKPost *post_;
    BOOL isPreviousPostPrivate_;
    
}

@property(retain) TKPost *post;
@property(setter=setPreviousPostPrivate:) BOOL isPreviousPostPrivate;

- (void)showWindow:(id)sender
          withPost:(TKPost *)post;
- (void)showWindowWithMenuItem:(NSMenuItem *)item;
- (IBAction)postWithContent:(id)sender;
- (void)windowWillClose:(NSNotification *)notification;

@end