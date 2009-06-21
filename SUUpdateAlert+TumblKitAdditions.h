//
//  SUUpdateAlert+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/06/21.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUUpdateAlert : NSObject {}
- (void)displayReleaseNotes;
@end

@interface SUUpdateAlert (TumblKitAdditions)
- (void)tk_displayReleaseNotes;
@end
