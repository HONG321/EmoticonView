//
//  LDEmoticonInputView.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDEmotion.h"

typedef void(^SelectedEmoticonCallBack)(LDEmotion *emoticon);

@interface LDEmoticonInputView : UIView

+ (LDEmoticonInputView *)inputView:(SelectedEmoticonCallBack)selectedEmoticon;

@end
