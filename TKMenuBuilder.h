//
//  TKMenuBuilder.h
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TKRegistory
- (void)registerObject:(id)object;
@end

@class TKSource;
@interface TKMenuBuilder : NSObject <TKRegistory> {
    NSMenu *menu_;
    NSMenu *submenu_;
    NSMenuItem *preferredItem_;
    TKSource *source_;
}

- (id)initWithMenu:(NSMenu *)menu
            source:(TKSource *)source;

@end
