//
//  LDEmotion.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmotion.h"
#import "LDEmoticonAttachment.h"
#import "NSString+CZEmoji.h"
#import <YYModel/YYModel.h>

@implementation LDEmotion

- (void)setCode:(NSString *)code {
    _code = code;
    if (code == nil) {
        return;
    }

    self.emoji = [NSString stringWithFormat:@"%@",[NSString cz_emojiWithStringCode:code]];
}


- (UIImage *)image {
    // 判断表情类型，true是emoji
    if (self.type) {
        return nil;
    }
    if (self.directory == nil) {
        return nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HMEmoticon.bundle" ofType:nil];
    path = [[path stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Resources"];
    
    NSString *imagePath = [[path stringByAppendingPathComponent:self.directory] stringByAppendingPathComponent:self.png];
    
    if (imagePath == nil) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (NSAttributedString *)imageTextWithFont:(UIFont *)font {
    // 1. 判断图像是否存在
    if (self.image == nil) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    // 2. 创建文本附件
    LDEmoticonAttachment *attachment = [[LDEmoticonAttachment alloc] init];
    // 记录属性文本文字
    attachment.chs = self.chs;
    attachment.image = self.image;
    CGFloat height = font.lineHeight;
    attachment.bounds = CGRectMake(0, -4, height, height);
    
    // 3. 返回图片属性文本
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    
    // 设置字体属性
    [attrStrM addAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, 1)];
    
    // 4. 返回属性文本
    return attrStrM;
}

- (NSString *)description {
    return self.yy_modelDescription;
}

@end
