//
//  TKMenuController.h
//  TumblKitNG
//
//  Created by uasi on 09/11/13.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKSource;

@interface TKMenuController : NSObject {

}

+ (id)sharedMenuController;

- (void)insertItemsToMenu:(NSMenu* )menu
                forSource:(TKSource *)source;

@end
