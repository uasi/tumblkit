//
//  TKTagTokenField.m
//  TumblKitNG
//
//  Created by uasi on 09/08/26.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKTagTokenField.h"


@implementation TKTagTokenField

- (void)awakeFromNib
{
    NSMutableCharacterSet *set = [[self tokenizingCharacterSet] mutableCopy];
    [set autorelease];
    [set addCharactersInString:@"#"];
    [self setTokenizingCharacterSet:set];
}

@end
