//
//  WBComposeTextView.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "WBComposeTextView.h"
#import "LDEmoticonAttachment.h"
#import "LDEmotion.h"
#import "UIView+CZAddition.h"

@interface WBComposeTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

/// 撰写微博的文本视图
@implementation WBComposeTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    // 0. 注册通知
    // - 通知是一对多，如果其他控件监听当前文本视图的通知，不会影响
    // - 但是如果使用代理，其他控件就无法使用代理监听通知！
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil
     ];
    // 1. 设置占位标签
    self.placeHolderLabel.text = @"分享新鲜事...";
    self.placeHolderLabel.font = self.font;
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    self.placeHolderLabel.x = 5;
    self.placeHolderLabel.y = 8;
    [self.placeHolderLabel sizeToFit];
    [self addSubview:self.placeHolderLabel];
}

// 如果有文本，不显示占位标签，否则显示
- (void)textChange:(NSNotification *)n {
    self.placeHolderLabel.hidden = self.hasText;
}

// MARK: - 表情键盘专属方法
/// 返回 textView 对应的纯文本的字符串[将属性图片转换成文字]
- (NSString *)emoticonText{
    if (self.attributedText == nil) {
        return @"";
    }
    // 2. 需要获得属性文本中的图片[附件 Attachment]
    /**
     1> 遍历的范围
     2> 选项 []
     3> 闭包
     */
    NSMutableString *result = [NSMutableString string];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull dict, NSRange range, BOOL * _Nonnull stop) {
        //NSLog(@"%@",dict);
        LDEmoticonAttachment *attachment = dict[@"NSAttachment"];
        if (attachment != nil) {
            [result appendString:attachment.chs];
        } else {
            NSString *str = [self.attributedText.string substringWithRange:range];
            [result appendString:str];
        }
    }];
    return [result copy];
}

/// 向文本视图插入表情符号[图文混排]
///
/// - parameter em: 选中的表情符号，nil 表示删除
- (void)insertEmoticon:(LDEmotion *)em {
    // 1. em == nil 是删除按钮
    if (em == nil) {
        // 删除文本
        [self deleteBackward];
        return;
    }
    // 2. emoji 字符串
    NSString *emoji = em.emoji;
    if (emoji != nil) {
        [self replaceRange:self.selectedTextRange withText:emoji];
        return;
    }
    
    // 代码执行到此，都是图片表情
    // 0. 获取表情中的图像属性文本
    NSAttributedString *imageText = [em imageTextWithFont:self.font];
    // 1> 获取当前 textView 属性文本 => 可变的
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // 2> 将图像的属性文本插入到当前的光标位置
    [attrStrM replaceCharactersInRange:self.selectedRange withAttributedString:imageText];
    // 3> 重新设置属性文本
    // 记录光标位置
    NSRange range = self.selectedRange;
    // 设置文本
    self.attributedText = attrStrM;
    // 恢复光标位置，length 是选中字符的长度，插入文本之后，应该为 0
    self.selectedRange = NSMakeRange(range.location + 1, 0);
    // 4> 让代理执行文本变化方法 - 在需要的时候，通知代理执行协议方法！
    [self.delegate textViewDidChange:self];
    // 5> 执行当前对象的 文本变化方法
    [self textChange:nil];
}

- (UILabel *)placeHolderLabel {
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
    }
    return _placeHolderLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
