//
//  WebHTMLView+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "WebHTMLView+TumblKitAdditions.h"
#import "TKBundleController.h"
#import "TKMenuController.h"
#import "TKExtractor.h"
#import "TKPost.h"
#import "TKSource.h"


@interface WebHTMLView (TumblKitPrivateMethods)

- (TKSource *)tk_sourceForEvent:(NSEvent *)event;

@end


@implementation WebHTMLView (TumblKitPrivateMethods)

- (TKSource *)tk_sourceForEvent:(NSEvent *)event
{
    NSPoint point = [event locationInWindow];
    point = [self convertPoint:point fromView:nil];
    NSDictionary *element = [self elementAtPoint:point 
                              allowShadowContent:YES];
    
    TKSource *source = [TKSource sourceWithHTMLView:self
                                            element:element];
    return source;
}

@end


@implementation WebHTMLView (TumblKitAdditions)

- (NSMenu *)tk_menuForEvent:(NSEvent *)event
{
    TKSource *source = [self tk_sourceForEvent:event];
    
    NSMenu *menu = [self tk_menuForEvent:event];
    [[TKMenuController sharedMenuController] insertItemsToMenu:menu
                                                     forSource:source];
    return menu;
}

@end
