//
//  TKFileData.h
//  TumblKitNG
//
//  Created by uasi on 09/12/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TKFileData : NSObject {
    NSData *data_;
    NSString *contentType_;
    NSString *filename_;
}

@property(copy) NSData* data;
@property(copy) NSString *contentType;
@property(copy) NSString *filename;

- (id)initWithData:(NSData *)data
       contentType:(NSString *)contentType
          filename:(NSString *)filename;

@end
