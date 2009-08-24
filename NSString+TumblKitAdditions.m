//
//  NSString+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSString+TumblKitAdditions.h"


@implementation NSString (TumblKitAdditions)

- (NSString *)tk_stringByEscapingAngleBrackets
{
    NSString *string = [self stringByReplacingOccurrencesOfString:@"<"
                                                       withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">"
                                               withString:@"&gt;"];
    return string;
}

@end