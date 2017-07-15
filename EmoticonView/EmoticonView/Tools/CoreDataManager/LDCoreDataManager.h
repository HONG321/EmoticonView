//
//  LDDataManager.h
//  Demo
//
//  Created by 郑鸿钦 on 2017/5/26.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LDCoreDataManager : NSObject
+ (instancetype)sharedManager;

/**
 持久化容器 - 可以提供管理上下文 iOS 10 推出
 包含了 Core Data stack 中所有的核心对象，都不是线程安全的
 
 - NSManagedObjectContext *viewContext; 管理上下文
 - NSManagedObjectModel *managedObjectModel;
 - NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */
//@property (readonly, strong) NSPersistentContainer *persistentContainer;

/**
 管理对象上下文
 */
@property (readonly, strong) NSManagedObjectContext *moc;

/**
 保存上下文
 */
- (void)saveContext;
@end
