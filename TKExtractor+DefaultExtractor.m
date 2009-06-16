//
//  TKExtractor+DefaultExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/17.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKExtractor.h"
#import "TKGenericExtractor.h"


@implementation TKExtractor (DefaultExtractor)

+ (TKExtractor *)defaultExtractor
{
    if (self != [TKExtractor class]) {
        return [TKExtractor defaultExtractor];
    }
    
    TKExtractor *defaultExtractor = nil;
    if (defaultExtractor == nil) {
        defaultExtractor = [[TKGenericImageExtractor alloc] initWithNextExtractor:
                            [[TKGenericQuoteExtractor alloc] initWithNextExtractor:
                             [[TKGenericLinkExtractor alloc] initWithNextExtractor:
                              nil]]];
    }
    return defaultExtractor;
}

@end
