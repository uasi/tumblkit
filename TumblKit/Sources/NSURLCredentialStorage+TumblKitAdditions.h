//
//  NSURLCredentialStorage+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSURLCredentialStorage (TumblKitAdditions) 

- (NSURLCredential *)tk_credentialForHost:(NSString *)host;

@end
