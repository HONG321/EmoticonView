//
//  LDEmoticonManager.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDEmotion.h"
#import "LDEmoticonPackage.h"

@interface LDEmoticonManager : NSObject

/// 表情包的懒加载数组 - 第一个数组是最近表情，加载之后，表情数组为空
@property (nonatomic, strong) NSMutableArray <LDEmoticonPackage *> *packages;

/// 表情素材的 bundle
@property (nonatomic, strong) NSBundle *bundle;

// 为了便于表情的复用，建立一个单例，只加载一次表情数据
/// 表情管理器的单例
+ (instancetype)share;

/// 将给定的字符串转换成属性文本
///
/// 关键点：要按照匹配结果倒序替换属性文本！
///
/// - parameter string: 完整的字符串
///
/// - returns: 属性文本
- (NSAttributedString *)emoticonString:(NSString *)string font:(UIFont *)font;

/// 根据 string `[爱你]` 在所有的表情符号中查找对应的表情模型对象
///
/// - 如果找到，返回表情模型
/// - 否则，返回 nil
- (LDEmotion *)findEmotionWithString:(NSString *)string;
/// 添加最近使用的表情
///
/// - parameter em: 选中的表情
- (void)recentEmoticon:(LDEmotion *)em;
@end
