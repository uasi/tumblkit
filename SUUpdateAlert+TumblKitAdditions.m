//
//  SUUpdateAlert+TumblKitAdditions.m
//  TumblKitNG
//
//  Created by uasi on 09/06/21.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "SUUpdateAlert+TumblKitAdditions.h"


@implementation SUUpdateAlert (TumblKitAdditions)

- (void)tk_displayReleaseNotes
{
    /* オリジナルの displayReleaseNotes が Safari の標準フォントの設定を変えてしまうので、
       この空メソッドと swizzle して無効にする
       ほんとは Sparkle.framework をカスタマイズしたほうがいいんだけど、取り急ぎ
       */
}

@end
