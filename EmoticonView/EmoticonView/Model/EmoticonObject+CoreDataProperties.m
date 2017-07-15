//
//  EmoticonObject+CoreDataProperties.m
//  EmoticonView
//
//  Created by 郑鸿钦 on 2017/7/13.
//  Copyright © 2017年 HONG. All rights reserved.
//

#import "EmoticonObject+CoreDataProperties.h"

@implementation EmoticonObject (CoreDataProperties)

+ (NSFetchRequest<EmoticonObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EmoticonObject"];
}

@dynamic chs;
@dynamic code;
@dynamic directory;
@dynamic emoji;
@dynamic image;
@dynamic png;
@dynamic times;
@dynamic type;

@end
