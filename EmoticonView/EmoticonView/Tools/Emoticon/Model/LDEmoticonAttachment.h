//
//  LDEmoticonAttachment.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDEmoticonAttachment : NSTextAttachment

/// 表情纯文本，用于发送给服务器
@property (nonatomic, copy) NSString *chs;

@end
