//
//  LDEmoticonTipView.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/11.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDEmotion;

@interface LDEmoticonTipView : UIImageView

/// 之前选择的表情
@property (nonatomic, strong) LDEmotion *preEmoticon;

/// 提示视图的表情模型
@property (nonatomic, strong) LDEmotion *emoticon;


@end
