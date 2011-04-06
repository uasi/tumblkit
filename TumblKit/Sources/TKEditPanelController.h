//
//  TKEditPanelController.h
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKPost;

@interface TKEditPanelController : NSWindowController<NSWindowDelegate> {
    
    IBOutlet NSTabView *tabView;
    TKPost *post_;
    BOOL isPreviousPostPrivate_;
    
}

@property(retain) TKPost *post;
@property(setter=setPreviousPostPrivate:) BOOL isPreviousPostPrivate;

- (void)showWindowWithPost:(TKPost *)aPost;
- (void)showWindow:(id)sender
          withPost:(TKPost *)post;
- (IBAction)postWithContent:(id)sender;
- (void)windowWillClose:(NSNotification *)notification;

@end