//
//  LDDataManager.m
//  Demo
//
//  Created by 郑鸿钦 on 2017/5/26.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDCoreDataManager.h"

/// 数据库文件名
static NSString *const dbName = @"my.db";

@implementation LDCoreDataManager

static id instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self moc];
    }
    return self;
}

#pragma mark - Core Data stack
// 如果重写了只读属性的 getter 方法，编译器不再提供 _成员变量
@synthesize moc = _moc;

/**
 为了低版本的兼容
 */
- (NSManagedObjectContext *)moc {
    
    if (_moc != nil) {
        return _moc;
    }
    
    // 互斥锁，应该锁定的代码尽量少！
    @synchronized (self) {
        
        // 1. 实例化管理上下文
        _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        // 2. 管理对象模型（实体）
        NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // 3. 持久化存储调度器
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        
        // 4. 添加数据库
        /**
         1> 数据存储类型
         3> 保存 SQLite 数据库文件的 URL
         4> 设置数据库选项
         */
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *path = [cacheDir stringByAppendingPathComponent:dbName];
        // 将本地文件的完整路径转换成 文件 URL
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                  NSInferMappingModelAutomaticallyOption: @(YES)};
        
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:NULL];
        
        // 5. 给管理上下文指定存储调度器
        _moc.persistentStoreCoordinator = psc;
    }
    
    return _moc;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *context = self.moc;
    
    // 判断上下文中是否有数据发生变化
    // `事务` 可以保存多个数据，不一定每次数据变化都需要保存，例如：for 增加多条记录，就可以最后调用一次保存操作即可！
    if (![context hasChanges]) {
        return;
    }
    
    // 保存数据
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"保存数据出错 %@, %@", error, error.userInfo);
    }
}

@end
