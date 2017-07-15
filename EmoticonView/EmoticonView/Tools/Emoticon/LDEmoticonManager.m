//
//  LDEmoticonManager.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/7.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonManager.h"
#import "LDCoreDataManager.h"
#import "EmoticonObject+CoreDataClass.h"
#import <YYModel/YYModel.h>

@interface LDEmoticonManager()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LDEmoticonManager

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [EmoticonObject fetchRequest];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"times" ascending:NO];
    fetchRequest.sortDescriptors = @[sort1];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[LDCoreDataManager sharedManager].moc sectionNameKeyPath:nil cacheName:nil];
    //_fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

+ (instancetype)share {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadPackages];
    }
    return self;
}

- (void)loadPackages {
    // 读取 emoticons.plist
    // 只要按照 Bundle 默认的目录结构设定，就可以直接读取 Resources 目录下的文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HMEmoticon.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *plistPath = [bundle pathForResource:@"emoticons.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *models = [NSArray yy_modelArrayWithClass:[LDEmoticonPackage class] json:array];
    if (models == nil) {
        return;
    }
    [self.packages addObjectsFromArray:models];
    
    [self.fetchedResultsController performFetch:NULL];
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        for (EmoticonObject *emoticonObject in self.fetchedResultsController.fetchedObjects) {
            // 查找表情模型对象
            LDEmotion *em = [self findEmotionWithString:emoticonObject.chs];
            em.times = emoticonObject.times;
            if (em != nil) {
                 [self.packages[0].emoticons addObject:em];
            } else {
                // 查找emoji模型对象
                LDEmotion *em = [self findEmotionWithEmojiCode:emoticonObject.code];
                em.times = emoticonObject.times;
                if (em != nil) {
                    [self.packages[0].emoticons addObject:em];
                }
            }
        }
    }
}

/// 将给定的字符串转换成属性文本
///
/// 关键点：要按照匹配结果倒序替换属性文本！
///
/// - parameter string: 完整的字符串
///
/// - returns: 属性文本
- (NSAttributedString *)emoticonString:(NSString *)string font:(UIFont *)font {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    // 1. 建立正则表达式，过滤所有的表情文字
    // [] () 都是正则表达式的关键字，如果要参与匹配，需要转义
    NSString *pattern = @"\\[.*?\\]";
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    if (regx == nil) {
        return attrString;
    }
    // 2. 匹配所有项
    NSArray *matches = [regx matchesInString:string options:0 range:NSMakeRange(0, attrString.length)];
    // 3. 遍历所有匹配结果
    for (NSTextCheckingResult *m in [matches reverseObjectEnumerator]) {
        NSRange range = [m rangeAtIndex:0];
        NSString *subStr = [attrString.string substringWithRange:range];
        // 1> 使用 subStr 查找对应的表情符号
        LDEmotion *em = [[LDEmoticonManager share] findEmotionWithString:subStr];
        if (em!=nil) {
            [attrString replaceCharactersInRange:range withAttributedString:[em imageTextWithFont:font]];
        }
    }
    // 4. *** 统一设置一遍字符串的属性，除了需要设置字体，还需要设置`颜色`！
    [attrString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor darkGrayColor]}
                        range:NSMakeRange(0, attrString.length)];
    return attrString;
 }

/// 根据 string `[爱你]` 在所有的表情符号中查找对应的表情模型对象
///
/// - 如果找到，返回表情模型
/// - 否则，返回 nil
- (LDEmotion *)findEmotionWithString:(NSString *)string {
    for (LDEmoticonPackage *p in self.packages) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"chs",string];
        NSArray *result = [p.emoticons filteredArrayUsingPredicate:predicate];
        if (result.count == 1) {
            return result.firstObject;
        }
    }
    return nil;
}

- (LDEmotion *)findEmotionWithEmojiCode:(NSString *)emojiCode {
    for (LDEmoticonPackage *p in self.packages) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"code",emojiCode];
        NSArray *result = [p.emoticons filteredArrayUsingPredicate:predicate];
        if (result.count == 1) {
            return result.firstObject;
        }
    }
    return nil;
}

/// 添加最近使用的表情
///
/// - parameter em: 选中的表情
- (void)recentEmoticon:(LDEmotion *)em{
    // 1. 增加表情的使用次数
    em.times += 1;
    // 2. 判断是否已经记录了该表情，如果没有记录，添加记录
    if (![self.packages[0].emoticons containsObject:em]) {
        [self.packages[0].emoticons addObject:em];
        EmoticonObject *emoticonObject = [NSEntityDescription insertNewObjectForEntityForName:@"EmoticonObject" inManagedObjectContext:[LDCoreDataManager sharedManager].moc];
        //emoticonObject = [em yy_modelCopy];
        emoticonObject.chs = em.chs;
        emoticonObject.code = em.code;
        emoticonObject.emoji = em.emoji;
        emoticonObject.directory = em.directory;
        //emoticonObject.image = em.image;
        emoticonObject.times = (int)em.times;
        emoticonObject.type = em.type;
    } else {
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"chs = %@",em.chs];
        self.fetchedResultsController.fetchRequest.predicate = predicate;
        [self.fetchedResultsController performFetch:NULL];
        if (self.fetchedResultsController.fetchedObjects.count > 0) {
            EmoticonObject *emoticonObject = self.fetchedResultsController.fetchedObjects.firstObject;
            emoticonObject.times ++;
        }
    }
    [[LDCoreDataManager sharedManager] saveContext];
    
    // 3. 根据使用次数排序，使用次数高的排序靠前
    // 对当前数组排序
    [self.packages[0].emoticons sortUsingComparator:^NSComparisonResult(LDEmotion *obj1, LDEmotion * obj2) {
        return obj1.times < obj2.times;
    }];
    
    // 4. 判断表情数组是否超出 20，如果超出，删除末尾的表情
    if (self.packages[0].emoticons.count > 20) {
        [self.packages[0].emoticons removeObjectsInRange:NSMakeRange(20, self.packages[0].emoticons.count)];
    }
}


- (NSMutableArray<LDEmoticonPackage *> *)packages {
    if (_packages == nil) {
        _packages = [NSMutableArray array];
    }
    return _packages;
}

- (NSBundle *)bundle {
    if (_bundle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HMEmoticon.bundle" ofType:nil];
        _bundle = [NSBundle bundleWithPath:path];
    }
    return _bundle;
}

@end
