//
//  TKPost.h
//  TumblKitNG
//
//  Created by uasi on 09/06/04.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum TKPostType {
    TKPostNilType   = 0,
    TKPostImageType = 1,
    TKPostLinkType  = 2,
    TKPostQuoteType = 4,
    TKPostVideoType = 8,
    TKPostPageType  = 16,
} TKPostType;


@interface TKPost : NSObject {
    TKPostType type_;
    NSString *title_;
    NSString *body_;
    NSURL *URL_;
    NSURL *alternateURL_;
    NSURL *linkURL_;
    BOOL isPrivate_;
}

@property TKPostType type;
@property(retain) NSString *title;
@property(retain) NSString *body;
@property(retain) NSURL *URL;
@property(retain) NSURL *alternateURL;
@property(retain) NSURL *linkURL;
@property(setter=setPrivate:) BOOL isPrivate;

- (id)initWithType:(TKPostType)type;

@end


@class TKSource;
@class TKExtractor;
@interface TKDeferredPost : NSObject {
    TKPost *post_;
    TKSource *source_;
    TKExtractor *extractor_;
}

@property(readonly) TKPost *post;

- (id)initWithSource:(TKSource *)source
           extractor:(TKExtractor *)extractor;
+ (id)deferredPostWithSource:(TKSource *)source
                   extractor:(TKExtractor *)extractor;

@end
