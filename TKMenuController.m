//
//  TKMenuController.m
//  TumblKitNG
//
//  Created by uasi on 09/11/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKMenuController.h"
#import "TKBundleController.h"
#import "TKPostController.h"
#import "TKExtractor.h"
#import "TKPost.h"
#import "TKSource.h"
#import "TKPreferencesModule.h"


#define L(str) NSLocalizedStringFromTableInBundle(str, @"", TKBundle, @"")


@interface TKMenuController ()

- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractor
                      withSource:(TKSource *)source;
- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractor
                               withSource:(TKSource *)source;

- (void)post:(NSMenuItem *)item;
- (void)edit:(NSMenuItem *)item;

@end


@implementation TKMenuController

+ (id)sharedMenuController
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

- (void)insertItemsToMenu:(NSMenu* )menu
                forSource:(TKSource *)source
{
    NSArray *extractors = [TKExtractor extractorsForSource:source];
    if ([extractors lastObject] == nil) {
        return;
    }
    TKExtractor *firstExtractor = [extractors objectAtIndex:0];
    
    BOOL insertsOnBottom = [[[[TKPreferencesModule sharedInstance] preferences]
                             valueForKey:@"MenuItemsOnBottom"] boolValue];
    NSUInteger baseIndex = insertsOnBottom ? [menu numberOfItems] - 1 : 0;
    
    NSMenuItem *firstItem = [self itemForExtractor:firstExtractor withSource:source];
    [firstItem setTitle:[NSString stringWithFormat:L(@"Share %@"), [firstItem title]]];
    [menu insertItem:firstItem atIndex:(baseIndex + 0)];
    
    NSMenuItem *firstAltItem = [self alternateItemForExtractor:firstExtractor withSource:source];
    [firstAltItem setTitle:[[firstItem title] stringByAppendingString:@"..."]];
    [menu insertItem:firstAltItem atIndex:(baseIndex + 1)];
    
    NSMenu *submenu = [[NSMenu alloc] init];
    NSMenuItem *submenuItem = [[NSMenuItem alloc] init];
    [submenuItem setTitle:L(@"Share As...")];
    [submenuItem setSubmenu:submenu];
    [menu insertItem:[submenuItem autorelease] atIndex:(baseIndex + 2)];
    if (!insertsOnBottom) {
        [menu insertItem:[NSMenuItem separatorItem] atIndex:(baseIndex + 3)];
    }
    
    for (TKExtractor *extractor in extractors) {
        [submenu addItem:[self itemForExtractor:extractor withSource:source]];
        [submenu addItem:[self alternateItemForExtractor:extractor withSource:source]];
    }
}

#pragma mark -

- (NSMenuItem *)itemForExtractor:(TKExtractor *)extractor
                      withSource:(TKSource *)source
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:L([extractor title])
                                                  action:@selector(post:)
                                           keyEquivalent:@""];
    [item setTarget:[[self class] sharedMenuController]];
    [item setRepresentedObject:[extractor extractionForSource:source]];
    return [item autorelease];
}

- (NSMenuItem *)alternateItemForExtractor:(TKExtractor *)extractor
                               withSource:(TKSource *)source
{
    NSString *title = [L([extractor title]) stringByAppendingString:@"..."];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(edit:)
                                           keyEquivalent:@""];
    [item setTarget:[[self class] sharedMenuController]];
    [item setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [item setAlternate:YES];
    [item setRepresentedObject:[extractor extractionForSource:source]];
    return [item autorelease];
}

- (void)post:(NSMenuItem *)item
{
    TKExtraction *extraction = [item representedObject];
    [[TKPostController sharedPostController] postWithExtraction:extraction];
}

- (void)edit:(NSMenuItem *)item
{
    TKExtraction *extraction = [item representedObject];
    [[TKPostController sharedPostController] editWithExtraction:extraction];
}

@end
