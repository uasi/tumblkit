//
//  NSDictionary+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSDictionary+TumblKitAdditions.h"
#import "TKMultipartFormDataBuilder.h"
#import "TKFileData.h"


@interface NSDictionary (TumblKitPrivateMethods)

- (NSString *)tk_stringByUnescapingString:(NSString *)string;
- (NSString *)tk_stringByEscapingString:(NSString *)string;

@end


@implementation NSDictionary (TumblKitAdditions)

- (NSString *)tk_queryString
{
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *key in [self keyEnumerator]) {
        NSArray *values;
        if ([[self objectForKey:key] isKindOfClass:[NSArray class]]) {
            values = [self objectForKey:key];
        }
        else {
            values = [NSArray arrayWithObject:[self objectForKey:key]];
        }
        
        for (NSObject *value in values) {
            NSString *stringValue;
            if ([value isKindOfClass:[NSString class]]) {
                stringValue = (NSString *)value;
            }
            else if ([value isKindOfClass:[NSURL class]]) {
                stringValue = [(NSURL *)value absoluteString];
            }
            else {
                stringValue = [value description];
            }
            [queryString appendFormat:
             @"%@=%@&",
             [self tk_stringByEscapingString:key],
             [self tk_stringByEscapingString:stringValue]];
        }
    }
    if ([queryString length]) {
        [queryString deleteCharactersInRange:
         NSMakeRange([queryString length] - 1, 1)];
    }
    return [NSString stringWithString:queryString];
}

- (TKMultipartFormDataBuilder *)tk_multipartFormDataBuilder
{
    TKMultipartFormDataBuilder *builder = [TKMultipartFormDataBuilder builder];

    for (NSString *key in self) {
        NSArray *values;
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSArray class]]) {
            values = object;
        }
        else {
            values = [NSArray arrayWithObject:object];
        }
        
        for (id value in values) {
            if ([value isKindOfClass:[NSString class]]) {
                [builder appendPartWithString:value
                                         name:key];
            }
            else if ([value isKindOfClass:[NSURL class]]) {
                [builder appendPartWithString:[(NSURL *)value absoluteString]
                                         name:key];
            }
            else if ([value isKindOfClass:[NSData class]]) {
                [builder appendFilePartWithData:value
                                           name:key
                                       filename:@""
                                    contentType:@"application/octet-stream"];
            }
            else if ([value isKindOfClass:[TKFileData class]]) {
                TKFileData *fileData = (TKFileData *)value;
                [builder appendFilePartWithData:[fileData data]
                                           name:key
                                       filename:[fileData filename]
                                    contentType:[fileData contentType]];
            }
            else {
                [builder appendPartWithString:[value description]
                                         name:key];
            }
        }
    }
    
    return builder;
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
