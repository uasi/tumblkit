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


@interface TKSource (PrivateMethods)

- (id)initWithText:(NSString *)aText
             title:(NSString *)aTitle
         linkLabel:(NSString *)aLinkLabel
           linkURL:(NSURL *)aLinkURL
         sourceURL:(NSURL *)aSourceURL
               URL:(NSURL *)anURL;

@end


@implementation TKSource

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

- (id)initWithText:(NSString *)aText
             title:(NSString *)aTitle
         linkLabel:(NSString *)aLinkLabel
           linkURL:(NSURL *)aLinkURL
         sourceURL:(NSURL *)aSourceURL
               URL:(NSURL *)anURL;
{
    self = [super init];
    if (self != nil) {
        text = [aText retain];
        title = [aTitle retain];
        linkLabel = [aLinkLabel retain];
        linkURL = [aLinkURL retain];
        sourceURL = [aSourceURL retain];
        URL = [anURL retain];
    }
    return self;
}

- (void)dealloc
{
    [text release];
    [title release];
    [linkLabel release];
    [linkURL release];
    [sourceURL release];
    [URL release];
    [super dealloc];
}

@synthesize text;
@synthesize title;
@synthesize linkLabel;
@synthesize linkURL;
@synthesize sourceURL;
@synthesize URL;

@end
