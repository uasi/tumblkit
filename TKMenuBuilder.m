//
//  TKMenuBuilder.m
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "TKMenuBuilder.h"
#import "TKBundleController.h"
#import "TKEditPanelController.h"
#import "TKExtractor.h"
#import "TKSource.h"
#import "TKPost.h"
#import "TKPostingNotification.h"
#import "TKPreferencesModule.h"
#import "DOM.h"
#import "NSDictionary+TumblKitAdditions.h"
#import "TKGrowlHelper.h"


#define TK_L(str) NSLocalizedStringFromTableInBundle(str, @"", TKBundle, @"")

@interface TKMenuBuilder () // Private Methods
- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractactor;
- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractactor;
@end


@implementation TKMenuBuilder

@synthesize menu = menu_;

- (void)insertItemsToMenu
{
    NSArray *extractors = [TKExtractor extractorsForSource:source_];
    if ([extractors lastObject] == nil) {
        return;
    }
    TKExtractor *firstExtractor = [extractors objectAtIndex:0];
    
    BOOL insertsOnBottom = [[[[TKPreferencesModule sharedInstance] preferences]
                             valueForKey:@"MenuItemsOnBottom"] boolValue];
    NSUInteger baseIndex = insertsOnBottom ? [menu_ numberOfItems] - 1 : 0;
    
    NSMenuItem *firstItem = [self itemForExtractor:firstExtractor];
    [firstItem setTitle:[NSString stringWithFormat:TK_L(@"Share %@"), [firstItem title]]];
    [menu_ insertItem:firstItem atIndex:(baseIndex + 0)];
    
    NSMenuItem *firstAltItem = [self alternateItemForExtractor:firstExtractor];
    [firstAltItem setTitle:[[firstItem title] stringByAppendingString:@"..."]];
    [menu_ insertItem:firstAltItem atIndex:(baseIndex + 1)];
    
    NSMenu *submenu = [[NSMenu alloc] init];
    NSMenuItem *submenuItem = [[NSMenuItem alloc] init];
    [submenuItem setTitle:TK_L(@"Share As...")];
    [submenuItem setSubmenu:submenu];
    [menu_ insertItem:[submenuItem autorelease] atIndex:(baseIndex + 2)];
    if (!insertsOnBottom) {
        [menu_ insertItem:[NSMenuItem separatorItem] atIndex:(baseIndex + 3)];
    }
    
    for (TKExtractor *extractor in extractors) {
        [submenu addItem:[self itemForExtractor:extractor]];
        [submenu addItem:[self alternateItemForExtractor:extractor]];
    }
}

- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractor
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:TK_L([extractor title])
                                                  action:@selector(notify:)
                                           keyEquivalent:@""];
    [item setTarget:[TKPostingNotifier sharedNotifier]];
    [item setRepresentedObject:[extractor deferredPostFromSource:source_]];
    return [item autorelease];
}

- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractor
{
    NSString *title = [TK_L([extractor title]) stringByAppendingString:@"..."];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(notify:)
                                           keyEquivalent:@""];
    [item setTarget:[[TKBundleController sharedBundleController] editPanelController]];
    [item setAction:@selector(showWindowWithMenuItem:)];
    [item setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [item setAlternate:YES];
    [item setRepresentedObject:[extractor deferredPostFromSource:source_]];
    return [item autorelease];
}

- (id)initWithMenu:(NSMenu *)menu
            source:(TKSource *)source
{
    [super init];
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

@end
