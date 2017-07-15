//
//  LDEmoticonPackage.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonPackage.h"
#import <YYModel/YYModel.h>

@implementation LDEmoticonPackage

- (void)setDirectory:(NSString *)directory {
    _directory = directory;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HMEmoticon.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *infoPath = [bundle pathForResource:@"info.plist" ofType:nil inDirectory:directory];
    NSArray *array = [NSArray arrayWithContentsOfFile:infoPath];
    NSArray *models = [NSArray yy_modelArrayWithClass:[LDEmotion class] json:array];
    if (models == nil || models.count == 0) {
        return;
    }
    // 遍历 models 数组，设置每一个表情符号的目录
    for (LDEmotion *m in models) {
        m.directory = directory;
    }
    // 设置表情模型数组
    [self.emoticons addObjectsFromArray:models];
}

/// 表情页面数量
- (NSInteger)numberOfPages {
    if (self.emoticons.count == 0) return 1;
    return (self.emoticons.count - 1) / 20 + 1;
}

/// 从懒加载的表情包中，按照 page 截取最多 20 个表情模型的数组
/// 例如有 26 个表情
/// page == 0，返回 0~19 个模型
/// page == 1，返回 20~25 个模型
- (NSArray<LDEmotion *> *)emoticonInPage:(NSInteger)page {
    // 每页的数量
    NSInteger count = 20;
    NSInteger location = page * 20;
    NSInteger length = count;
    // 判断数组是否越界
    if (location + length > self.emoticons.count) {
        length = self.emoticons.count - location;
    }
    NSRange range = NSMakeRange(location, length);
    // 截取数组的子数组
    return [self.emoticons subarrayWithRange:range];
}

- (NSMutableArray<LDEmotion *> *)emoticons {
    if (_emoticons == nil) {
        _emoticons = [NSMutableArray array];
    }
    return _emoticons;
}

- (NSString *)description {
    return self.yy_modelDescription;
}

@end
