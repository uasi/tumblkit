//
//  TKSource.h
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class WebHTMLView;

@interface TKSource : NSObject {
    WebHTMLView *view_;   
    NSDictionary *element_;
    NSString *text;
    NSString *title;
    NSString *linkLabel;
    NSURL *linkURL;
    NSURL *sourceURL;
    NSURL *URL;
}

+ (TKSource *)sourceWithHTMLView:(WebHTMLView *)view
                         element:(NSDictionary *)element;

@property(readonly) NSString *text;
@property(readonly) NSString *title;
@property(readonly) NSString *linkLabel;
@property(readonly) NSURL *linkURL;
@property(readonly) NSURL *sourceURL;
@property(readonly) NSURL *URL;



@end
