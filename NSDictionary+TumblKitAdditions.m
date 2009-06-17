//
//  NSDictionary+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSDictionary+TumblKitAdditions.h"

@interface NSDictionary (TumblKitPrivateMethods)
- (NSString *)tk_stringByEscapingString:(NSString *)string;
@end


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
         [self tk_stringByEscapingString:key],
         [self tk_stringByEscapingString:stringValue]];
    }
    [queryString deleteCharactersInRange:
     NSMakeRange([queryString length] - 1, 1)];
    return [NSString stringWithString:queryString];
}


- (NSString *)tk_stringByEscapingString:(NSString *)string
{
    CFStringRef preprocessedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedString, NULL, CFSTR("&"), kCFStringEncodingUTF8);
    return (NSString *)escapedString;
}

@end
