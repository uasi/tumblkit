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
#import "TKMenuBuilder.h"

@interface TKExtractor : NSObject {
    TKExtractor *nextExtractor_;
}

- (id)initWithNextExtractor:(TKExtractor *)nextExtractor;
- (TKPost *)postFromSource:(TKSource *)source;
- (TKDeferredPost *)deferredPostFromSource:(TKSource *)source;

- (BOOL)acceptsSource:(TKSource *)source;
- (TKPost *)postFromSource:(TKSource *)source;

- (BOOL)registerToRegistory:(id <TKRegistory>)registory
            ifAcceptsSource:(TKSource *)source;
- (void)registerExtractorsToRegistory:(id <TKRegistory>)registory
                      ifAcceptsSource:(TKSource *)source;

@property(readonly) id nextExtractor;
@property(readonly) NSString *title;

@end


@interface TKExtractor (DefaultExtractor)

+ (TKExtractor *)defaultExtractor;

@end



