//
//  TKTumblrWebService.h
//  TumblKitNG
//
//  Created by uasi on 09/08/24.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "TKWebService.h"


@class TKPost;
@interface TKTumblrWebService : TKWebService {
    TKPost *post_;
    WebView* webView_;
}
@end
