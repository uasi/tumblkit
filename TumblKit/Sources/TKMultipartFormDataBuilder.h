//
//  TKMultipartFormDataBuilder.h
//  TumblKitNG
//
//  Created by uasi on 09/12/12.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TKMultipartFormDataBuilder : NSObject {
    NSMutableData *data_;
    NSString *boundary_;
    
}

+ (id)builder;

- (id)initWithBoundary:(NSString *)boundary;

- (void)appendPartWithString:(NSString *)string
                        name:(NSString *)name;
- (void)appendFilePartWithData:(NSData *)data
                          name:(NSString *)name
                      filename:(NSString *)filename
                   contentType:(NSString *)contentType;
/*
- (void)appendFilePartWithPath:(NSString *)path
                          name:(NSString *)name
                      filename:(NSString *)filename
                   contentType:(NSString *)contentType;
 */
- (NSString *)HTTPContentTypeHeaderValue;
- (NSData *)formData;

@end
