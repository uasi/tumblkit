//
//  TKGenericExtractor.h
//  TumblKitNG
//
//  Created by uasi on 09/06/07.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKExtractor.h"


@interface TKGenericImageExtractor :TKExtractor <TKExtractor>  {}
@end

@interface TKGenericQuoteExtractor : TKExtractor <TKExtractor> {}
@end

@interface TKGenericLinkExtractor :TKExtractor <TKExtractor> {}
@end


