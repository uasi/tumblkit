//
//  NSURLCredentialStorage+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/03/29.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSURLCredentialStorage+TumblKitAdditions.h"


@implementation NSURLCredentialStorage (TumblKitAdditions)

- (NSURLCredential *)tk_credentialForHost:(NSString *)host
{
    NSURLProtectionSpace *space = [[NSURLProtectionSpace alloc]
                                   initWithHost:host
                                   port:0
                                   protocol:@"http"
                                   realm:nil
                                   authenticationMethod:
                                   NSURLAuthenticationMethodDefault];
    NSURLCredential *credential = [self defaultCredentialForProtectionSpace:space];
    return credential;
    
    /* If credential for host is not exist,
     [credential name] == "Password not saved" && [credential password] == " "
     */
}

@end
