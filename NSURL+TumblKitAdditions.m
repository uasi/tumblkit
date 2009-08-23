//
//  NSURL+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSURL+TumblKitAdditions.h"
#import "NSString+TumblKitAdditions.h"


@implementation NSURL (TumblKitAdditions)

- (NSString *)tk_anchorStringWithText:(NSString *)text
{
    NSString *anchor = [NSString stringWithFormat:
                        @"<a href=\"%@\">%@</a>",
                        [self absoluteString],
                        [text tk_stringByEscapingAngleBrackets]];
    return anchor;
}

@end
