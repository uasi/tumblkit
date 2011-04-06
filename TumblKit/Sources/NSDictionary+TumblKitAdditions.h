//
//  NSDictionary+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/06/14.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TKMultipartFormDataBuilder;

@interface NSDictionary (TumblKitAdditions)

- (NSString *)tk_queryString;
- (TKMultipartFormDataBuilder *)tk_multipartFormDataBuilder;

@end
