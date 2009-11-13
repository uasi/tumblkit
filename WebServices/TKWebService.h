//
//  TKWebService.h
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKPost;

@interface TKWebService : NSObject {
}

+ (NSArray *)webServiceClasses;
+ (void)postToWebServices:(TKPost *)post;
+ (void)postInBackground:(TKPost *)post;

- (void)post:(TKPost *)post;

@end