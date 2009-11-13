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


@class TKSource;

@interface TKPost : NSObject {
    TKPostType type_;
    BOOL isPrivate_;    
    NSArray *tags_; 
    
    NSString *pageTitle_;
    NSURL *pageURL_; 
    
    NSString *authorName_;
    NSURL *authorURL_;
    
    NSString *title_;
    NSString *body_;
    id object_;
    NSURL *URL_;
    NSURL *linkURL_;
}

@property TKPostType type;
@property(setter=setPrivate:) BOOL isPrivate;
@property(copy) NSArray *tags;

@property(copy) NSString *pageTitle;
@property(copy) NSURL *pageURL;

@property(copy) NSString *authorName;
@property(copy) NSURL *authorURL;

@property(copy) NSString *title;
@property(copy) NSString *body;
@property(retain) id object;
@property(copy) NSURL *URL;
@property(copy) NSURL *linkURL;

- (id)initWithType:(TKPostType)type;
- (id)initWithType:(TKPostType)type
            source:(TKSource *)source;

@end

