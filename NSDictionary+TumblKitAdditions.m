//
//  NSDictionary+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSDictionary+TumblKitAdditions.h"


@implementation NSDictionary (TumblKitAdditions)

- (NSString *)tk_queryString
{
    NSMutableString *queryString = [NSMutableString string];
    NSString *key;
    NSObject *value;
    NSString *stringValue;
    for (key in [self keyEnumerator]) {
        value = [self objectForKey:key];
        stringValue = [value isKindOfClass:[NSString class]] ? (NSString *)value : [value description];
        [queryString appendFormat:
         @"%@=%@&",
         [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
         [stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [queryString deleteCharactersInRange:
     NSMakeRange([queryString length] - 1, 1)];
    return [NSString stringWithString:queryString];
}

@end
