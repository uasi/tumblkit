//
//  TKMenuBuilder.h
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKSource;
@interface TKMenuBuilder : NSObject {
    NSMenu *menu_;
    TKSource *source_;
}

@property(readonly) NSMenu *menu;

- (id)initWithMenu:(NSMenu *)menu
            source:(TKSource *)source;
- (void)insertItemsToMenu;

@end
