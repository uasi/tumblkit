//
//  TKPostController.h
//  TumblKitNG
//
//  Created by uasi on 09/11/09.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKExtraction;
@class TKPost;

@interface TKPostController : NSObject {

}

+ (id)sharedPostController;

- (void)post:(TKPost *)post;
- (void)edit:(TKPost *)post;
- (void)postWithExtraction:(TKExtraction *)extraction;
- (void)editWithExtraction:(TKExtraction *)extraction;

@end
