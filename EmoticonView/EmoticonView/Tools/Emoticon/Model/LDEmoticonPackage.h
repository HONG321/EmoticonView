//
//  LDEmoticonPackage.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDEmotion.h"

@interface LDEmoticonPackage : NSObject

/// 表情包的分组名
@property (nonatomic, copy) NSString *groupName;
/// 背景图片名称
@property (nonatomic, copy) NSString *bgImageName;
/// 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
@property (nonatomic, copy) NSString *directory;
/// 懒加载的表情模型的空数组
/// 使用懒加载可以避免后续的解包
@property (nonatomic, strong) NSMutableArray<LDEmotion *> *emoticons;
/// 表情页面数量
@property (nonatomic, assign) NSInteger numberOfPages;

- (NSArray *)emoticonInPage:(NSInteger)page;

@end
