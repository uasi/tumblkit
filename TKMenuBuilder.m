//
//  TKMenuBuilder.m
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKMenuBuilder.h"
#import "TKBundleController.h"
#import "TKEditPanelController.h"
#import "TKExtractor.h"
#import "TKSource.h"
#import "TKPost.h"
#import "TKPostingNotification.h"

#define TK_L(str) NSLocalizedStringFromTableInBundle(str, @"", TKBundle, @"")

@implementation TKMenuBuilder

- (void)registerObject:(id)object
{
    TKExtractor *extractor = (TKExtractor *)object;
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:TK_L([extractor title])
                                                  action:@selector(notify:)
                                           keyEquivalent:@""];
    [item setTarget:[TKPostingNotifier sharedNotifier]];
    [item setRepresentedObject:[extractor deferredPostFromSource:source_]];
    NSMenuItem *alternateItem = [item copy];
    [alternateItem setTitle:[[alternateItem title] stringByAppendingString:@"..."]]; // XXX ...
    [alternateItem setTarget:self];
    [alternateItem setAction:@selector(openEditWindow:)];
    [alternateItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [alternateItem setAlternate:YES];
    if (preferredItem_ == nil) {
        preferredItem_ = [item copy]; // Should I retain it?
        [preferredItem_ setTitle:[NSString stringWithFormat:TK_L(@"Share %@"), [preferredItem_ title]]];
        [menu_ insertItem:preferredItem_ atIndex:0];
        
        NSMenuItem *altPreferredItem = [alternateItem copy];
        [altPreferredItem setTitle:[[preferredItem_ title] stringByAppendingString:@"..."]];
        [menu_ insertItem:altPreferredItem atIndex:1];
        
        NSMenuItem *submenuItem = [[NSMenuItem alloc] init];
        [submenuItem setTitle:TK_L(@"Share As...")];
        submenu_ = [[NSMenu alloc] init];
        [submenuItem setSubmenu:submenu_];
        [menu_ insertItem:[submenuItem autorelease] atIndex:2];
        
        [menu_ insertItem:[NSMenuItem separatorItem] atIndex:3];
        
        // DOING EVEL THING...
        NSMenuItem *item__ = [[NSMenuItem alloc] initWithTitle:@"Open Edit Window"
                                                        action:@selector(openEditWindow:)
                                                 keyEquivalent:@""];
        [item__ setTarget:self];
        [item__ setRepresentedObject:[extractor deferredPostFromSource:source_]];
        [menu_ addItem:[item__ autorelease]];
    }
    [submenu_ addItem:[item autorelease]];
    [submenu_ addItem:[alternateItem autorelease]];
}

- (id)initWithMenu:(NSMenu *)menu
            source:(TKSource *)source
{
    [self init];
    menu_ = [menu retain];
    source_ = [source retain];
    return self;
}

- (void)dealloc
{
    [menu_ release];
    [source_ release];
    [super dealloc];
}

// DOING EVEL THING...
- (void)openEditWindow:(id)sender
{
    TKPost *post = [(TKDeferredPost *)[(NSMenuItem *)sender representedObject] post];
    [[[TKBundleController sharedBundleController] editPanelController] showWindow:self withPost:post];
}

@end
