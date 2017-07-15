//
//  NSString+CZEmoji.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/9.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZEmoji)

+ (NSString *)cz_emojiWithIntCode:(unsigned int)intCode;
+ (NSString *)cz_emojiWithStringCode: (NSString *)stringCode;
- (NSString *)cz_emoji;

@end
