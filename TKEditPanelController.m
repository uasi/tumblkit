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
    [[self window] setDelegate:self];
}

- (void)showWindow:(id)sender
          withPost:(TKPost *)aPost
{
    [aPost setPrivate:[self isPreviousPostPrivate]];
    [[self window] setTitle:@"TumblKit - "];
    [self setPost:aPost];
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

- (void)showWindowWithMenuItem:(NSMenuItem *)item
{
    TKPost *post = [(TKDeferredPost *)[item representedObject] post];
    [self showWindow:self withPost:post];   
}

- (IBAction)postWithContent:(id)sender
{
    [[TKPostingNotifier sharedNotifier] notifyWithPost:post];
    [[self window] performClose:sender];
}

/****************
 delegate methods
 ****************/

- (void)windowWillClose:(NSNotification *)notification
{
    [self setPreviousPostPrivate:[[self post] isPrivate]];
}

@synthesize isPreviousPostPrivate;
@synthesize post;

@end
