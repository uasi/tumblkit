//
//  TKExtractor.h
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TKSource.h"
#import "TKPost.h"


@class TKExtraction;

@interface TKExtractor : NSObject {
}

@property(readonly) NSString *title;

+ (NSArray *)extractors;
+ (NSArray *)extractorsForSource:(TKSource *)source;

- (TKPost *)postFromSource:(TKSource *)source;

- (BOOL)acceptsSource:(TKSource *)source;
- (TKExtraction *)extractionForSource:(TKSource *)source;
- (TKPost *)postFromSource:(TKSource *)source;

@end


@interface TKExtraction : NSObject {
    TKExtractor *extractor_;
    TKSource *source_;
}

- (TKPost *)postByInvokingExtraction;

@end





