//
//  TKExtractor.h
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TKSource.h"
#import "TKPost.h"

@interface TKExtractor : NSObject {
}

@property(readonly) NSString *title;

+ (NSArray *)extractors;
+ (NSArray *)extractorsForSource:(TKSource *)source;

- (TKPost *)postFromSource:(TKSource *)source;
- (TKDeferredPost *)deferredPostFromSource:(TKSource *)source;

- (BOOL)acceptsSource:(TKSource *)source;
- (TKPost *)postFromSource:(TKSource *)source;

@end




