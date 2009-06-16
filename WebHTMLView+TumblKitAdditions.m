//
//  WebHTMLView+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/03.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "WebHTMLView+TumblKitAdditions.h"
#import "TKSource.h"
#import "TKMenuBuilder.h"
#import "TKPost.h"
#import "TKExtractor.h"
#import "TKBundleController.h"

#define TK_L(str) NSLocalizedStringFromTableInBundle(str, @"", TKBundle, @"")
//#define TK_L(str) (str)


@interface WebHTMLView (TubmlKitPrivateMethods)

- (NSMenuItem *)tk_menuItemForSource:(TKSource *)source
                          sourceType:(TKSourceType)type;
- (TKSource *)tk_sourceForEvent:(NSEvent *)event;
@end



@implementation WebHTMLView (TumblKitAdditions)

- (NSMenu *)tk_menuForEvent:(NSEvent *)event
{
    TKSource *source = [self tk_sourceForEvent:event];
    
    NSMenu *menu = [self tk_menuForEvent:event];
    TKMenuBuilder *builder = [[TKMenuBuilder alloc] initWithMenu:menu source:source];
    
    [[TKExtractor defaultExtractor] registerExtractorsToRegistory:builder
                                                  ifAcceptsSource:source];
    
    return menu;
     
}

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
