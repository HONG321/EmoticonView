//
//  LDEmoticonCell.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonCell.h"
#import "LDEmoticonManager.h"
#import "LDEmoticonTipView.h"
#import "UIView+CZAddition.h"

@interface LDEmoticonCell ()

@property (nonatomic, strong) LDEmoticonTipView *tipView;
@end

@implementation LDEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setEmoticons:(NSArray<LDEmotion *> *)emoticons{
    _emoticons = emoticons;
    NSLog(@"表情包的数量%zd",emoticons.count);
    // 1. 隐藏所有的按钮
    for (UIButton *btn in self.contentView.subviews) {
        btn.hidden = YES;
    }
    // 显示删除按钮
    self.contentView.subviews.lastObject.hidden = NO;
    // 2. 遍历表情模型数组，设置按钮图像
    [self.emoticons enumerateObjectsUsingBlock:^(LDEmotion * _Nonnull em, NSUInteger i, BOOL * _Nonnull stop) {
        // 1> 取出按钮
        UIButton *btn = self.contentView.subviews[i];
        // 设置图像 - 如果图像为 nil 会清空图像，避免复用
        [btn setImage:em.image forState:UIControlStateNormal];
        // 设置 emoji 的字符串 - 如果 emoji 为 nil 会清空 title，避免复用
        [btn setTitle:em.emoji forState:UIControlStateNormal];
        btn.hidden = NO;
    }];
}

- (void)setupUI {
    NSInteger rowCount = 3;
    NSInteger colCount = 7;
    
    // 左右间距
    CGFloat leftMargine = 8;
    // 底部间距，为分页控件预留空间
    CGFloat bottomMargin = 16;
    CGFloat w = (self.width - 2 * leftMargine) / colCount;
    CGFloat h = (self.height - bottomMargin) / rowCount;
    
    for (int i = 0 ; i< 21; i++) {
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        UIButton *btn = [[UIButton alloc] init];
        // 设置按钮的大小
        CGFloat x = leftMargine + col * w;
        CGFloat y = row * h;
        btn.frame = CGRectMake(x, y, w, h);
        [self.contentView addSubview:btn];
        
        // 设置按钮的字体大小，lineHeight 基本上和图片的大小差不多！
        btn.titleLabel.font = [UIFont systemFontOfSize:32];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(selectedEmoticonButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 取出末尾的删除按钮
    UIButton *removeButton = self.contentView.subviews.lastObject;
    
    // 设置图像
    UIImage *image = [UIImage imageNamed:@"compose_emotion_delete_highlighted" inBundle:[LDEmoticonManager share].bundle compatibleWithTraitCollection:nil];
    [removeButton setImage:image forState:UIControlStateNormal];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    longPress.minimumPressDuration = 0.1;
    [self addGestureRecognizer:longPress];
}

// 当视图从界面上删除，同样会调用此方法，newWindow == nil
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        return;
    }
    // 将提示视图添加到窗口上
    // 提示：在 iOS 6.0之前，很多程序员都喜欢把控件往窗口添加
    // 在现在开发，如果有地方，就不要用窗口！
    [newWindow addSubview:self.tipView];
    self.tipView.hidden = YES;
}

- (void)longGesture:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"长按cell");
    // 1> 获取触摸位置
    CGPoint location = [gesture locationInView:self];
    // 2> 获取触摸位置对应的按钮
    UIButton *btn = [self buttonWithLocation:location];
    if (btn == nil) {
        self.tipView.hidden = YES;
        return;
    }
    
    // 3> 处理手势状态
    // 在处理手势细节的时候，不要试图一下把所有状态都处理完毕！
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.tipView.hidden = NO;
            // 坐标系的转换 -> 将按钮参照 cell 的坐标系，转换到 window 的坐标位置
            CGPoint center = [self convertPoint:btn.center toView:self.window];
            // 设置提示视图的位置
            self.tipView.center = center;
            // 设置提示视图的表情模型
            if (btn.tag < self.emoticons.count) {
                self.tipView.emoticon = self.emoticons[btn.tag];
            }
            break;
        case UIGestureRecognizerStateEnded:
            self.tipView.hidden = YES;
            // 执行选中按钮的函数
            [self selectedEmoticonButton:btn];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            self.tipView.hidden = YES;
        default:
            break;
    }
}

- (UIButton *)buttonWithLocation:(CGPoint)location {
    // 遍历 contentView 所有的子视图，如果可见，同时在 location 确认是按钮
    for (UIButton *btn in self.contentView.subviews) {
        // 删除按钮同样需要处理
        if (CGRectContainsPoint(btn.frame, location) && !btn.isHidden && btn != self.contentView.subviews.lastObject) {
            return btn;
        }
    }
    return nil;
}

- (void)selectedEmoticonButton:(UIButton *)btn {
    // 1. 取 tag 0~20 20 对应的是删除按钮
    NSInteger tag = btn.tag;
    // 2. 根据 tag 判断是否是删除按钮，如果不是删除按钮，取得表情
    LDEmotion *em;
    if (tag < self.emoticons.count) {
        em = self.emoticons[tag];
    }
    // 3. em 要么是选中的模型，如果为 nil 对应的是删除按钮
    if ([self.delegate respondsToSelector:@selector(emoticonCellDidSelected:emoticon:)]) {
        [self.delegate emoticonCellDidSelected:self emoticon:em];
    }
}

- (LDEmoticonTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[LDEmoticonTipView alloc] init];
    }
    return _tipView;
}

@end
