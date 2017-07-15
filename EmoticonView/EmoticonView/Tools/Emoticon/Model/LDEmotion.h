//
//  LDEmotion.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDEmotion : NSObject

/// 表情类型 false - 图片表情 / true - emoji
@property (nonatomic, assign) BOOL type;
/// 表情字符串，发送给新浪微博的服务器(节约流量)
@property (nonatomic, copy) NSString *chs;
/// 表情图片名称，用于本地图文混排
@property (nonatomic, copy) NSString *png;
/// emoji 的十六进制编码
@property (nonatomic, copy) NSString *code;
/// 表情使用次数
@property (nonatomic, assign) NSInteger times;
/// emoji 的字符串
@property (nonatomic, copy) NSString *emoji;
/// 表情模型所在的目录
@property (nonatomic, copy) NSString *directory;
/// `图片`表情对应的图像
@property (nonatomic, strong) UIImage *image;

/// 将当前的图像转换生成图片的属性文本
- (NSAttributedString *)imageTextWithFont:(UIFont *)font;

@end
