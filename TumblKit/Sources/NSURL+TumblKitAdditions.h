//
//  NSURL+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSURL (TumblKitAdditions)

- (NSString *)tk_anchorStringWithText:(NSString *)text;
- (BOOL)tk_hostMatchesTo:(NSString *)host;

@end
