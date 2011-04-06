//
//  NSURL+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "NSURL+TumblKitAdditions.h"
#import "NSString+TumblKitAdditions.h"


@implementation NSURL (TumblKitAdditions)

- (NSString *)tk_anchorStringWithText:(NSString *)text
{
    NSString *anchor = [NSString stringWithFormat:
                        @"<a href=\"%@\">%@</a>",
                        [self absoluteString],
                        text];
    return anchor;
}

- (BOOL)tk_hostMatchesTo:(NSString *)host
{
    return ([[self host] isEqualToString:host] ||
            [[self host] hasSuffix:[@"." stringByAppendingString:host]]);
    
}

@end
