//
//  TKWebService.m
//  TumblKitNG
//
//  Created by uasi on 09/06/13.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "TKWebService.h"
#import "TKPost.h"
#import "TKPostingNotification.h"
#import "NSURLCredentialStorage+TumblKitAdditions.h"
#import "TKGrowlHelper.h"
#import "NSDictionary+TumblKitAdditions.h"


@implementation TKWebService

+ (void)registerAsObserver
{
    if (self == [TKWebService class]) { return; }
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedWebService]
                                             selector:@selector(postWithNotification:)
                                                 name:TKPostingNotification
                                               object:nil];
}

+ (id)sharedWebService
{
    id sharedWebService = nil;
    if (sharedWebService == nil) {
        sharedWebService = [[self alloc] init];
    }
    return sharedWebService;
}

- (void)postWithNotification:(NSNotification *)notification
{
}

@end


static NSURL *TKTumblrWebServiceURL;

@implementation TKTumblrWebService

+ (void)load
{
    TKTumblrWebServiceURL = [[NSURL alloc] initWithString:@"http://www.tumblr.com/api/write"];
}

- (NSURLCredential *)credential
{
    return [[NSURLCredentialStorage sharedCredentialStorage] tk_credentialForHost:
            @"www.tumblr.com"];
}

#define EVERYTHING_IS_OK 1

- (void)postWithNotification:(NSNotification *)notification
{
#if ! EVERYTHING_IS_OK
    [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"Post"
                                           description:@"Post"];
#endif
    TKPost *post = (TKPost *)[[notification userInfo] objectForKey:@"post"];
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    NSURLCredential *credential = [self credential];
    [query setObject:[credential user] forKey:@"email"];
    [query setObject:[credential password] forKey:@"password"];
    [query setObject:([post isPrivate] ? @"1" : @"0") forKey:@"private"];
    
    if ([post type] == TKPostQuoteType) {
        [query setObject:@"quote" forKey:@"type"];
        [query setObject:[post body] forKey:@"quote"];
        NSString *title = [[post title] stringByReplacingOccurrencesOfString:@"<"
                                                                  withString:@"&lt;"];
        title = [title stringByReplacingOccurrencesOfString:@">"
                                                 withString:@"&gt;"];
        NSString *source = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [post URL], title];
        [query setObject:source forKey:@"source"];
    }
    else if ([post type] == TKPostLinkType) {
        [query setObject:@"link" forKey:@"type"];
        [query setObject:[post title] forKey:@"name"];
        [query setObject:[[post URL] absoluteString] forKey:@"url"];
        [query setObject:[post body] forKey:@"description"]; // Should I escape body?
    }
    else if ([post type] == TKPostImageType) {
        [query setObject:@"photo" forKey:@"type"];
        [query setObject:[[post alternateURL] absoluteString] forKey:@"source"];
        NSString *title = [[post title] stringByReplacingOccurrencesOfString:@"<"
                                                                  withString:@"&lt;"];
        title = [title stringByReplacingOccurrencesOfString:@">"
                                                 withString:@"&gt;"];
        NSString *caption = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [post URL], title];
        if ([post body] != nil && ! [[post body] isEqualToString:@""]) {
            caption = [[post body] stringByAppendingFormat:@" (via %@)", caption];
        }
        [query setObject:caption forKey:@"caption"];
        if ([post linkURL] != nil && ! [[[post linkURL] absoluteString] isEqualToString:@""]) {
            [query setObject:[[post linkURL] absoluteString] forKey:@"click-through-url"];
        }
    }
    else {
        NSLog(@"TumblrWebService: Post type not supported");
    }

    NSLog(@"%@", [query tk_queryString]);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:TKTumblrWebServiceURL];
    [request setHTTPBody:[[query tk_queryString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
#if EVERYTHING_IS_OK
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}


/*********
 callbacks
 *********/

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response
{
    NSUInteger statusCode = [response statusCode];
    if (statusCode == 201) {
        [[TKGrowlHelper sharedGrowlHelper] notifyWithTitle:@"Post Successful"
                                               description:@"A post was created"];
        // Post was created successfully
    }
    else if (statusCode == 403) {
        // Email address or password were incorrect
        NSAlert *alert = [NSAlert alertWithMessageText:@"TumblKit - post failed"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Login information (email address or password) were incorrect. Go to http://www.tumblr.com/login, login with correct email address and password, and save them to KeyChain."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[NSApp mainWindow]
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:NULL];
    }
    else if (statusCode == 400) {
        // There was at least one error
        NSAlert *alert = [NSAlert alertWithMessageText:@"TumblKit - post failed"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"An error has occurred."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[NSApp mainWindow]
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:NULL];
    }
    else {
        // ... maybe the API has been changed
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"TumblKit - connection failed"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Your post was not sent. Check your Internet connection and try again."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[NSApp mainWindow]
                      modalDelegate:nil
                     didEndSelector:nil
                        contextInfo:NULL];
}


@end
