//
//  TKExtractor+DefaultExtractor.m
//  TumblKitNG
//
//  Created by uasi on 09/06/08.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKExtractor+DefaultExtractor.h"
#import "TKGenericExtractor.h"


@implementation TKExtractor (DefaultExtractor)

+ (id <TKExtractor>)defaultExtractor
{
    if (self != [TKExtractor class]) {
        return [TKExtractor defaultExtractor];
    }
    
    id <TKExtractor> defaultExtractor = nil;
    if (defaultExtractor == nil) {
        defaultExtractor = [[TKGenericImageExtractor alloc] initWithNextExtractor:
                            [[TKGenericQuoteExtractor alloc] initWithNextExtractor:
                            [[TKGenericLinkExtractor alloc] initWithNextExtractor:
                             nil]]];
    }
    return defaultExtractor;
}

@end
