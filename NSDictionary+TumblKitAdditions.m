//
//  NSDictionary+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSDictionary+TumblKitAdditions.h"

@interface NSDictionary (TumblKitPrivateMethods)
- (NSString *)tk_stringByUnescapingString:(NSString *)string;
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
        if ([value isKindOfClass:[NSString class]]) {
            stringValue = (NSString *)value;
        }
        else if ([value isKindOfClass:[NSURL class]]) {
            stringValue = [self tk_stringByUnescapingString:[(NSURL *)value absoluteString]];
        }
        else {
            stringValue = [value description];
        }
        [queryString appendFormat:
         @"%@=%@&",
         [self tk_stringByEscapingString:key],
         [self tk_stringByEscapingString:stringValue]];
    }
    if ([queryString length]) {
        [queryString deleteCharactersInRange:
         NSMakeRange([queryString length] - 1, 1)];
    }
    return [NSString stringWithString:queryString];
}

- (NSString *)tk_stringByUnescapingString:(NSString *)string
{
    CFStringRef newString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
    return [(NSString *)newString autorelease];
}

- (NSString *)tk_stringByEscapingString:(NSString *)string
{
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR (";,/?:@&=+$#"), kCFStringEncodingUTF8);
    return [(NSString *)newString autorelease];
}

@end
