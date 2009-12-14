//
//  TKMultipartFormDataBuilder.m
//  TumblKitNG
//
//  Created by uasi on 09/12/12.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKMultipartFormDataBuilder.h"


@interface TKMultipartFormDataBuilder()

- (void)appendString:(NSString *)string;
- (void)appendBoundary;

@end


@implementation TKMultipartFormDataBuilder

+ (id)builder
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStrRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    TKMultipartFormDataBuilder *builder;
    builder = [[[self class] alloc] initWithBoundary:(NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    return [builder autorelease];
}

- (id)initWithBoundary:(NSString *)boundary
{
    self = [super init];
    boundary_ = [boundary retain];
    data_ = [[NSMutableData alloc] init];
    return self;
}

- (void)dealloc
{
    [data_ release];
    [boundary_ release];
    [super dealloc];
}

- (NSString *)HTTPContentTypeHeaderValue
{
    NSString *header = @"multipart/form-data; boundary=%@";
    return [NSString stringWithFormat:header, boundary_];
}

- (void)appendPartWithString:(NSString *)string
                        name:(NSString *)name
{
    [self appendString:@"\r\n"];
    NSString *header;
    header = @"Content-Disposition: form-data;"
             @" name=\"%@\"\r\n"
             @"Content-Type: text-plain;charset=utf-8\r\n\r\n";
    header = [NSString stringWithFormat:header, name];
    [self appendString:header];
    [self appendString:string];
    [self appendBoundary];
}

- (void)appendFilePartWithData:(NSData *)data
                          name:(NSString *)name
                      filename:(NSString *)filename
                   contentType:(NSString *)contentType
{
    [self appendString:@"\r\n"];
    NSString *header;
    header = @"Content-Disposition: form-data;"
             @" name=\"%@\"; filename=\"%@\"\r\n"
             @"Content-Type: %@\r\n\r\n";
    header = [NSString stringWithFormat:header, name, filename, contentType];
    [self appendString:header];
    [data_ appendData:data];
    [self appendBoundary];
}
    
- (NSData *)formData
{
    NSMutableData *data = [data_ mutableCopy];
    [data appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

#pragma mark -

- (void)appendString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [data_ appendData:data];
}

- (void)appendBoundary
{
    NSString *boundary = [NSString stringWithFormat:@"\r\n--%@", boundary_];
    [self appendString:boundary];
}

@end
