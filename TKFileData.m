//
//  TKFileData.m
//  TumblKitNG
//
//  Created by uasi on 09/12/14.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKFileData.h"


@implementation TKFileData

@synthesize data = data_;
@synthesize contentType = contentType_;
@synthesize filename = filename_;

- (id)initWithData:(NSData *)data
       contentType:(NSString *)contentType
          filename:(NSString *)filename
{
    self = [super init];
    [self setData:data];
    [self setContentType:contentType];
    [self setFilename:filename];
    return self;
}

@end
