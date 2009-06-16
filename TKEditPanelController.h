//
//  TKEditPanelController.h
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKPost;
@interface TKEditPanelController : NSWindowController {
    IBOutlet NSTabView *tabView;
    TKPost *post;
    BOOL isPreviousPostPrivate;
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)post;
- (IBAction)postWithContent:(id)sender;
- (void)windowWillClose:(NSNotification *)notification;

@property(retain) TKPost *post;
@property(setter=setPreviousPostPrivate:) BOOL isPreviousPostPrivate;

@end