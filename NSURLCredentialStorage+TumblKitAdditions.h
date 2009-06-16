//
//  NSURLCredentialStorage+TumblKitAdditions.h
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSURLCredentialStorage (TumblKitAdditions) 

- (NSURLCredential *)tk_credentialForHost:(NSString *)host;

@end
