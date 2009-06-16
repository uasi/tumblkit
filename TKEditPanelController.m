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
    /*
    [[quoteViewController view] setHidden:YES];
    [[imageViewController view] setHidden:YES];
    [[linkViewController view] setHidden:YES];
     */
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)post
{
    [post setPrivate:[self isPreviousPostPrivate]];
    [[self window] setTitle:@"TumblKit - "];
    if ([post type] == TKPostQuoteType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Quote"]];
        [tabView selectTabViewItemWithIdentifier:@"Quote"];
        [quoteViewController setPost:post];
        [self setCurrentEditViewController:quoteViewController];
    }
    else if ([post type] == TKPostLinkType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Link"]];
        [tabView selectTabViewItemWithIdentifier:@"Link"];
        [linkViewController setPost:post];
        [self setCurrentEditViewController:linkViewController];
    }
    else if ([post type] == TKPostImageType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Image"]];
        [tabView selectTabViewItemWithIdentifier:@"Image"];
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
    [self setPreviousPostPrivate:[[currentEditViewController post] isPrivate]];
    [currentEditViewController setPost:nil];
    [self close];
}

- (IBAction)cancelToPost:(id)sender
{
    [self setPreviousPostPrivate:[[currentEditViewController post] isPrivate]];
    [currentEditViewController setPost:nil];
    [self close];
}

@synthesize isPreviousPostPrivate;

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