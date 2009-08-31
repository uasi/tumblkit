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
    NSURL *pageURL_;
    NSURL *URL_;
    NSURL *linkURL_;
    NSArray *tags_;
    BOOL isPrivate_;
}

/*
@property TKPostType type;
@property(copy) NSString *pageTitle;
@property(copy) NSURL *pageURL;
@property(copy) NSString *title; // Content title
@property(copy) NSString *body;  // Content body
@property(copy) NSString *authorName; // Author of content
@property(copy) NSString *selectedText; // Selection
@property(copy) NSURL *URL;      // Content URL
@property(copy) NSURL *linkURL;  // Link URL
@property(copy) NSURL *authorURL; // URL for author
@property(copy) NSArray *tags;
@property(setter=setPrivate:) BOOL isPrivate;
 */

@property TKPostType type;
@property(retain) NSString *title;
@property(retain) NSString *body;
@property(retain) NSURL *pageURL;
@property(retain) NSURL *URL;
@property(retain) NSURL *linkURL;
@property(copy) NSArray *tags;
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
