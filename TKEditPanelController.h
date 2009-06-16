//
//  TKEditPanelController.h
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKPost;
@protocol TKEditViewController
@property(retain) TKPost *post;
@end


@class TKQuoteViewController;
@class TKLinkViewController;
@class TKImageViewController;
@interface TKEditPanelController : NSWindowController {
    NSViewController <TKEditViewController> *currentEditViewController;
    IBOutlet NSTabView *tabView;
    IBOutlet TKQuoteViewController *quoteViewController;
    IBOutlet TKLinkViewController *linkViewController;
    IBOutlet TKImageViewController *imageViewController;
    
    BOOL isPreviousPostPrivate;
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)post;
- (void)setCurrentEditViewController:(NSViewController <TKEditViewController> *)controller;

- (IBAction)postWithContent:(id)sender;
- (IBAction)cancelToPost:(id)sender;

@property(setter=setPreviousPostPrivate:) BOOL isPreviousPostPrivate;

@end


@interface TKQuoteViewController : NSViewController <TKEditViewController> {
    TKPost *post_;
    IBOutlet NSView *quoteTextView;
    IBOutlet NSView *sourceTextView;
}
@end

@interface TKLinkViewController : NSViewController <TKEditViewController> {
    TKPost *post_;
    IBOutlet NSTextField *linkURLField;
    IBOutlet NSView *linkDescriptionView;
}
@end

@interface TKImageViewController : NSViewController <TKEditViewController> {
    TKPost *post_;
    IBOutlet NSTextField *imageURLField;
    IBOutlet NSView *imageCaptionView;
}

@end