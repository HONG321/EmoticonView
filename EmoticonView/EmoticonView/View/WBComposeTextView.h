//
//  WBComposeTextView.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDEmotion;

@interface WBComposeTextView : UITextView

@property (nonatomic, strong) NSString *emoticonText;

- (void)insertEmoticon:(LDEmotion *)em;

@end
