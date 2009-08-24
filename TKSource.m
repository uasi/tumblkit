//
//  TKSource.m
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "TKSource.h"
#import "WebHTMLView+TumblKitAdditions.h"


@interface TKSource () // Private Methods

- (id)initWithText:(NSString *)text
             title:(NSString *)title
         linkLabel:(NSString *)linkLabel
           linkURL:(NSURL *)linkURL
         sourceURL:(NSURL *)sourceURL
               URL:(NSURL *)URL;

@end


@implementation TKSource

@synthesize text = text_;
@synthesize title = title_;
@synthesize linkLabel = linkLabel_;
@synthesize linkURL = linkURL_;
@synthesize sourceURL = sourceURL_;
@synthesize URL = URL_;

+ (TKSource *)sourceWithHTMLView:(WebHTMLView *)view
                         element:(NSDictionary *)element
{
    NSString *text;
    NSString *title;
    NSString *linkLabel;    
    NSURL *linkURL;
    NSURL *sourceURL;
    NSURL *URL;
    
    text = [view selectedString];
    title = [[view _webView] mainFrameTitle];
    URL = [NSURL URLWithString:[[view _webView] mainFrameURL]];
    
    linkLabel = [element objectForKey:WebElementLinkLabelKey];
    linkURL = [element objectForKey:WebElementLinkURLKey];
    
    sourceURL = [element objectForKey:WebElementImageURLKey];

    TKSource *source = [[TKSource alloc] initWithText:text
                                                title:title
                                            linkLabel:linkLabel
                                              linkURL:linkURL 
                                            sourceURL:sourceURL
                                                  URL:URL];
    return [source autorelease];
}

- (id)initWithText:(NSString *)text
             title:(NSString *)title
         linkLabel:(NSString *)linkLabel
           linkURL:(NSURL *)linkURL
         sourceURL:(NSURL *)sourceURL
               URL:(NSURL *)URL
{
    self = [super init];
    text_ = [text retain];
    title_ = [title retain];
    linkLabel_ = [linkLabel retain];
    linkURL_ = [linkURL retain];
    sourceURL_ = [sourceURL retain];
    URL_ = [URL retain];
    return self;
}

- (void)dealloc
{
    [text_ release];
    [title_ release];
    [linkLabel_ release];
    [linkURL_ release];
    [sourceURL_ release];
    [URL_ release];
    [super dealloc];
}

@end
