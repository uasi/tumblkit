//
//  TKSource.h
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class DOMNode;
@class WebView;
@class WebHTMLView;

@interface TKSource : NSObject {
    DOMNode *node_;
    NSString *text_;
    NSString *title_;
    NSString *linkLabel_;
    NSURL *linkURL_;
    NSURL *sourceURL_;
    NSURL *URL_;
}

@property(readonly) DOMNode *node;
@property(readonly) NSString *text;
@property(readonly) NSString *title;
@property(readonly) NSString *linkLabel;
@property(readonly) NSURL *linkURL;
@property(readonly) NSURL *sourceURL;
@property(readonly) NSURL *URL;

+ (TKSource *)sourceWithHTMLView:(WebHTMLView *)view
                         element:(NSDictionary *)element;

@end
