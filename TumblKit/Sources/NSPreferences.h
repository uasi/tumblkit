/*
 * File: AppKit
 * Arch: Intel x86-64 (x86_64)
 *       Current version: 1038.11.0, Compatibility version: 45.0.0
 *
 *       Objective-C Garbage Collection: Supported
 */

/*
 class-dump -C 'NSPreferences*' \
    /System/Library/Frameworks/AppKit.framework/AppKit \
    | awk 'b { print }; /#pragma mark -/ { b = 1 }' > NSPreferences.h
 */

#import <AppKit/AppKit.h>

@protocol NSPreferencesModule
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
@end

@interface NSPreferences : NSObject
{
    NSWindow *_preferencesPanel;
    NSBox *_preferenceBox;
    NSMatrix *_moduleMatrix;
    NSButtonCell *_okButton;
    NSButtonCell *_cancelButton;
    NSButtonCell *_applyButton;
    NSMutableArray *_preferenceTitles;
    NSMutableArray *_preferenceModules;
    NSMutableDictionary *_masterPreferenceViews;
    NSMutableDictionary *_currentSessionPreferenceViews;
    NSBox *_originalContentView;
    BOOL _isModal;
    double _constrainedWidth;
    id _currentModule;
    void *_reserved;
}

+ (id)sharedPreferences;
+ (void)setDefaultPreferencesClass:(Class)arg1;
+ (Class)defaultPreferencesClass;
- (id)init;
- (void)dealloc;
- (void)addPreferenceNamed:(id)arg1 owner:(id)arg2;
- (void)_setupToolbar;
- (void)_setupUI;
- (struct CGSize)preferencesContentSize;
- (void)showPreferencesPanel;
- (void)showPreferencesPanelForOwner:(id)arg1;
- (long long)showModalPreferencesPanelForOwner:(id)arg1;
- (long long)showModalPreferencesPanel;
- (void)ok:(id)arg1;
- (void)cancel:(id)arg1;
- (void)apply:(id)arg1;
- (void)_selectModuleOwner:(id)arg1;
- (id)windowTitle;
- (void)confirmCloseSheetIsDone:(id)arg1 returnCode:(long long)arg2 contextInfo:(void *)arg3;
- (BOOL)windowShouldClose:(id)arg1;
- (void)windowDidResize:(id)arg1;
- (struct CGSize)windowWillResize:(id)arg1 toSize:(struct CGSize)arg2;
- (BOOL)usesButtons;
- (id)_itemIdentifierForModule:(id)arg1;
- (void)toolbarItemClicked:(id)arg1;
- (id)toolbar:(id)arg1 itemForItemIdentifier:(id)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (id)toolbarDefaultItemIdentifiers:(id)arg1;
- (id)toolbarAllowedItemIdentifiers:(id)arg1;
- (id)toolbarSelectableItemIdentifiers:(id)arg1;

@end

@interface NSPreferencesModule : NSObject <NSPreferencesModule>
{
    IBOutlet NSBox *_preferencesView;
    struct CGSize _minSize;
    BOOL _hasChanges;
    void *_reserved;
}

+ (id)sharedInstance;
- (void)dealloc;
- (void)finalize;
- (id)init;
- (id)preferencesNibName;
- (void)setPreferencesView:(id)arg1;
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
- (id)titleForIdentifier:(id)arg1;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (struct CGSize)minSize;
- (void)setMinSize:(struct CGSize)arg1;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
- (BOOL)isResizable;

@end

