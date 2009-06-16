//
//  TKEditPanelController.m
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKEditPanelController.h"
#import "TKPost.h"
#import "TKPostingNotification.h"


@implementation TKEditPanelController

- (void)awakeFromNib
{
    [[quoteViewController view] setHidden:YES];
    [[imageViewController view] setHidden:YES];
    [[linkViewController view] setHidden:YES];
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)post
{
    if ([post type] == TKPostQuoteType) {
        [quoteViewController setPost:post];
        [self setCurrentEditViewController:quoteViewController];
    }
    else if ([post type] == TKPostLinkType) {
        [linkViewController setPost:post];
        [self setCurrentEditViewController:linkViewController];
    }
    else if ([post type] == TKPostImageType) {
        [imageViewController setPost:post];
        [self setCurrentEditViewController:imageViewController];
    }
    [self showWindow:sender];
}

- (void)setCurrentEditViewController:(NSViewController <TKEditViewController> *)controller
{
    if (currentEditViewController != nil) {
        [[currentEditViewController view] setHidden:YES];
    }
    [[controller view] setHidden:NO];
    currentEditViewController = controller;
}

- (IBAction)postWithContent:(id)sender
{
    [[TKPostingNotifier sharedNotifier] notifyWithPost:[currentEditViewController post]];
    [currentEditViewController setPost:nil];
    [self close];
}

@end


@implementation TKQuoteViewController
@synthesize post = post_;
@end

@implementation TKLinkViewController
@synthesize post = post_;
@end

@implementation TKImageViewController
@synthesize post = post_;
@end