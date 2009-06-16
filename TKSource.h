//
//  TKSource.h
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebHTMLView;


typedef enum TKSourceType {
    TKSourceTypeNil   = 0,
    TKSourceTypeImage = 1,
    TKSourceTypeLink  = 2,
    TKSourceTypeQuote = 4,
    TKSourceTypeVideo = 8,
    TKSourceTypePage  = 16,
    // TKSourceTypeAudio = 32,
    // TKSourceTypeConversation = 64
} TKSourceType;


@interface TKSource : NSObject {
    TKSourceType type_;
    WebHTMLView *view_;   
    NSDictionary *element_;
    NSString *text_;
    NSString *title_;
    NSString *linkLabel_;
    NSURL *linkURL_;
    NSURL *sourceURL_;
    NSURL *URL_;
}

+ (TKSource *)sourceWithHTMLView:(WebHTMLView *)view
                         element:(NSDictionary *)element;

@property(readonly) TKSourceType type;
@property(readonly) NSString *text;
@property(readonly) NSString *title;
@property(readonly) NSString *linkLabel;
@property(readonly) NSURL *linkURL;
@property(readonly) NSURL *sourceURL;
@property(readonly) NSURL *URL;



@end
