//
//  WebHTMLView+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;


@interface WebHTMLView : NSControl {
}

- (WebView *)_webView;
- (NSString *)selectedString;
- (NSMenu *)menuForEvent:(NSEvent *)event;
- (NSDictionary *)elementAtPoint:(NSPoint)point
              allowShadowContent:(BOOL)yn;
- (NSPoint)convertPoint:(NSPoint)point
               fromView:(NSView *)view;

@end


@interface WebHTMLView (TumblKitAdditions) 

- (NSMenu *)tk_menuForEvent:(NSEvent *)event;

@end
