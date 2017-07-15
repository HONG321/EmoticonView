//
//  LDEmoticonTipView.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/11.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonTipView.h"
#import "LDEmoticonManager.h"
#import "UIView+CZAddition.h"
#import <pop/pop.h>

@interface LDEmoticonTipView ()
@property (nonatomic, strong) UIButton *tipButton;
@end

@implementation LDEmoticonTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSBundle *bundle = [LDEmoticonManager share].bundle;
        UIImage *image = [UIImage imageNamed:@"emoticon_keyboard_magnifier" inBundle:bundle compatibleWithTraitCollection:nil];
        // [[UIImageView alloc] initWithImage: image] => 会根据图像大小设置图像视图的大小！
        [self setImage:image];
        self.size = CGSizeMake(44, 80);
        
        // 设置锚点
        self.layer.anchorPoint = CGPointMake(0.5, 1.2);
        
        // 添加按钮
        self.tipButton.layer.anchorPoint = CGPointMake(0.5, 0);
        self.tipButton.frame = CGRectMake(0, 8, 36, 36);
        self.tipButton.centerX = self.width * 0.5;
        [self.tipButton setTitle:@"😄" forState:UIControlStateNormal];
        self.tipButton.titleLabel.font = [UIFont systemFontOfSize:32];
        [self addSubview:self.tipButton];
    }
    return self;
}

- (void)setEmoticon:(LDEmotion *)emoticon{
    _emoticon = emoticon;
    // 判断表情是否变化
    if (emoticon == self.preEmoticon) {
        return;
    }
    // 记录当前的表情
    self.preEmoticon = emoticon;
    
    // 设置表情数据
    [self.tipButton setTitle:emoticon.emoji forState:UIControlStateNormal];
    [self.tipButton setImage:emoticon.image forState:UIControlStateNormal];
    
    // 表情的动画 - 弹力动画的结束时间是根据速度自动计算的，不需要也不能指定 duration
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.fromValue = @30;
    anim.toValue = @8;
    anim.springBounciness = 20;
    anim.springSpeed = 20;
    [self.tipButton.layer pop_addAnimation:anim forKey:nil];
}

- (UIButton *)tipButton {
    if (_tipButton == nil) {
        _tipButton = [[UIButton alloc] init];
    }
    return _tipButton;
}

@end
