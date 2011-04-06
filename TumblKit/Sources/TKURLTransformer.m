//
//  TKURLTransformer.m
//  TumblKitNG
//
//  Created by uasi on 09/09/02.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKURLTransformer.h"


@implementation TKURLTransformer

+ (void)load
{
    id instance = [[[[self class] alloc] init] autorelease];
    NSString *name = NSStringFromClass([self class]);
    [NSValueTransformer setValueTransformer:instance forName:name];
}

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return (value == nil) ? nil : [value description];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSURL URLWithString:value];
}

@end
