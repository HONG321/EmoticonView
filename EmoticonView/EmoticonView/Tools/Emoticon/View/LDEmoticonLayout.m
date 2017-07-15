//
//  LDEmoticonLayout.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonLayout.h"

@implementation LDEmoticonLayout

- (void)prepareLayout{
    [super prepareLayout];
    // 在此方法中，collectionView 的大小已经确定
    self.itemSize = self.collectionView.bounds.size;
    // 设定滚动方向
    // 水平方向滚动，cell 垂直方向布局
    // 垂直方向滚动，cell 水平方向布局
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
