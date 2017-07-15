//
//  LDEmoticonToolbar.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonToolbar.h"
#import "LDEmoticonManager.h"
#import "UIView+CZAddition.h"

@implementation LDEmoticonToolbar

- (void)setSelecedIndex:(NSInteger)selecedIndex{
    _selecedIndex = selecedIndex;
    // 1. 取消所有的选中状态
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;
    }
    // 2. 设置 index 对应的选中状态
    UIButton *selectedBtn = self.subviews[selecedIndex];
    selectedBtn.selected = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局所有按钮
    NSUInteger count = self.subviews.count;
    CGFloat w = self.width / count;
    CGRect rect = CGRectMake(0, 0, w, self.height);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull btn, NSUInteger i, BOOL * _Nonnull stop) {
        btn.frame = CGRectOffset(rect, i * w, 0);
    }];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}


- (void)setupUI {
    // 0. 获取表情管理器单例
    LDEmoticonManager *manager = [LDEmoticonManager share];
    // 从表情包的分组名称 -> 设置按钮
    [manager.packages enumerateObjectsUsingBlock:^(LDEmoticonPackage * _Nonnull package, NSUInteger idx, BOOL * _Nonnull stop) {
        // 1> 实例化按钮
        UIButton *btn = [[UIButton alloc] init];
        
        // 2> 设置按钮状态
        [btn setTitle:package.groupName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        
        // 设置按钮的背景图片
        NSString *imageName = [NSString stringWithFormat:@"compose_emotion_table_%@_normal",package.bgImageName];
        NSString *imageNameHL = [NSString stringWithFormat:@"compose_emotion_table_%@_selected",package.bgImageName];
        UIImage *image = [UIImage imageNamed:imageName inBundle:manager.bundle compatibleWithTraitCollection:nil];
        UIImage *imageHL = [UIImage imageNamed:imageNameHL inBundle:manager.bundle compatibleWithTraitCollection:nil];
        
        // 拉伸图像
        CGSize size = image.size;
        UIEdgeInsets inset = UIEdgeInsetsMake(size.height * 0.5, size.width * 0.5, size.height * 0.5, size.width * 0.5);
        image = [image resizableImageWithCapInsets:inset];
        imageHL = [imageHL resizableImageWithCapInsets:inset];
        
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:imageHL forState:UIControlStateSelected];
        [btn sizeToFit];
        
        // 3> 添加按钮
        [self addSubview:btn];
        
        // 4> 设置按钮的 tag
        btn.tag = idx;
        
        // 5> 添加按钮的监听方法
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }];
    // 默认选中第0个按钮
    ((UIButton *)self.subviews[0]).selected = YES;
}

// MARK: - 监听方法
/// 点击分组项按钮
- (void)clickItem:(UIButton *)btn {
    NSLog(@"======%zd",btn.tag);
    // 通知代理执行协议方法
    if([self.delegate respondsToSelector:@selector(emoticonToolbarDidSelected:index:)]) {
        [self.delegate emoticonToolbarDidSelected:self index:(NSInteger)btn.tag];
    }
}

@end
