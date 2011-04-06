//
//  TKPostController.m
//  TumblKitNG
//
//  Created by uasi on 09/11/09.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKPostController.h"
#import "TKBundleController.h"
#import "TKEditPanelController.h"
#import "TKExtractor.h"
#import "TKWebService.h"


@interface TKPostController ()

- (void)extractAndPost:(TKExtraction *)extraction;
- (void)extractAndEdit:(TKExtraction *)extraction;

@end


@implementation TKPostController

+ (id)sharedPostController
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

- (void)post:(TKPost *)post
{
    [TKWebService postToWebServices:post];
}

- (void)edit:(TKPost *)post
{
    [[[TKBundleController sharedBundleController] editPanelController]
     showWindowWithPost:post];
}

- (void)postWithExtraction:(TKExtraction *)extraction
{
    [self performSelectorInBackground:@selector(extractAndPost:)
                           withObject:extraction];
}

- (void)editWithExtraction:(TKExtraction *)extraction
{
    [self performSelectorInBackground:@selector(extractAndEdit:)
                           withObject:extraction];
}

#pragma mark -

- (void)extractAndPost:(TKExtraction *)extraction
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TKPost *post = [extraction postByInvokingExtraction];
    if (post != nil) {
        [TKWebService postToWebServices:post];
    }
    else {
        NSLog(@"TumblKit: extraction failed");
    }
    [pool drain];
}

- (void)extractAndEdit:(TKExtraction *)extraction
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TKPost *post = [extraction postByInvokingExtraction];
    if (post != nil) {
        [self performSelectorOnMainThread:@selector(edit:)
                               withObject:post
                            waitUntilDone:NO];
    }
    else {
        NSLog(@"TumblKit: extraction failed");
    }
    [pool drain];
}

@end
