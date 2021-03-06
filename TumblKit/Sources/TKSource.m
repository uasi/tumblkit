//
//  TKSource.m
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2011 isdead.info. All rights reserved.
//

#import "TKSource.h"
#import "WebHTMLView+TumblKitAdditions.h"


@interface TKSource ()

- (id)initWithDOMNode:(DOMNode *)node
                 text:(NSString *)text
                title:(NSString *)title
            linkLabel:(NSString *)linkLabel
              linkURL:(NSURL *)linkURL
            sourceURL:(NSURL *)sourceURL
                  URL:(NSURL *)URL;

@end


@implementation TKSource

@synthesize node = node_;
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

    DOMNode *node = [element objectForKey:WebElementDOMNodeKey];
    TKSource *source = [[TKSource alloc] initWithDOMNode:node
                                                    text:text
                                                   title:title
                                               linkLabel:linkLabel
                                                 linkURL:linkURL 
                                               sourceURL:sourceURL
                                                     URL:URL];
    return [source autorelease];
}

- (id)initWithDOMNode:(DOMNode *)node
                 text:(NSString *)text
                title:(NSString *)title
            linkLabel:(NSString *)linkLabel
              linkURL:(NSURL *)linkURL
            sourceURL:(NSURL *)sourceURL
                  URL:(NSURL *)URL
{
    self = [super init];
    node_ = [node retain];
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
    [node_ release];
    [text_ release];
    [title_ release];
    [linkLabel_ release];
    [linkURL_ release];
    [sourceURL_ release];
    [URL_ release];
    [super dealloc];
}

@end
