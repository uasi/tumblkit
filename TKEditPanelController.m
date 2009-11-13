//
//  TKEditPanelController.m
//  TumblKitNG
//
//  Created by uasi on 09/06/15.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKEditPanelController.h"
#import "TKPostController.h"
#import "TKPost.h"


@implementation TKEditPanelController

@synthesize isPreviousPostPrivate = isPreviousPostPrivate_;
@synthesize post = post_;

- (void)awakeFromNib
{
    [[self window] setDelegate:self];
}

- (void)showWindowWithPost:(TKPost *)aPost
{
    [self showWindow:nil withPost:aPost];
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)aPost
{
    [aPost setPrivate:[self isPreviousPostPrivate]];
    [[self window] setTitle:@"TumblKit - "];
    [self setPost:aPost];
    if ([aPost type] == TKPostVideoType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Video"]];
        [tabView selectTabViewItemWithIdentifier:@"Video"];
    }
    if ([aPost type] == TKPostQuoteType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Quote"]];
        [tabView selectTabViewItemWithIdentifier:@"Quote"];
    }
    else if ([aPost type] == TKPostLinkType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Link"]];
        [tabView selectTabViewItemWithIdentifier:@"Link"];
    }
    else if ([aPost type] == TKPostImageType) {
        [[self window] setTitle:[[[self window] title] stringByAppendingString:@"Image"]];
        [tabView selectTabViewItemWithIdentifier:@"Image"];
    }
    [self showWindow:sender];
}

- (IBAction)postWithContent:(id)sender
{
    [[TKPostController sharedPostController] post:post_];
    [[self window] performClose:sender];
}


/****************
 delegate methods
 ****************/

- (void)windowWillClose:(NSNotification *)notification
{
    [self setPreviousPostPrivate:[[self post] isPrivate]];
}

@end
