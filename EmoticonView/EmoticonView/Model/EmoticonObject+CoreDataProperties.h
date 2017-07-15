//
//  EmoticonObject+CoreDataProperties.h
//  EmoticonView
//
//  Created by 郑鸿钦 on 2017/7/13.
//  Copyright © 2017年 HONG. All rights reserved.
//

#import "EmoticonObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EmoticonObject (CoreDataProperties)

+ (NSFetchRequest<EmoticonObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chs;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *directory;
@property (nullable, nonatomic, copy) NSString *emoji;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *png;
@property (nonatomic) int32_t times;
@property (nonatomic) BOOL type;

@end

NS_ASSUME_NONNULL_END
