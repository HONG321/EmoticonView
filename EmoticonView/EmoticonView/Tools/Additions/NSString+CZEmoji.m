//
//  NSString+CZEmoji.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/9.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "NSString+CZEmoji.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (CZEmoji)

+ (NSString *)cz_emojiWithIntCode:(unsigned int)intCode {
    unsigned int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    
    if (string == nil) {
        string = [NSString stringWithFormat:@"%C",(unichar)intCode];
    }
    return string;
}

+ (NSString *)cz_emojiWithStringCode: (NSString *)stringCode {
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringCode];
    unsigned int intCode = 0;
    [scanner scanHexInt:&intCode];
    return [self cz_emojiWithIntCode:intCode];
}

- (NSString *)cz_emoji{
    return [NSString cz_emojiWithStringCode:self];
}

@end

























