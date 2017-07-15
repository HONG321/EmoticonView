//
//  LDEmoticonInputView.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "LDEmoticonInputView.h"
#import "LDEmoticonCell.h"
#import "LDEmoticonToolbar.h"
#import "LDEmoticonManager.h"
#import "UIView+CZAddition.h"

static NSString *cellId = @"cellId";

@interface LDEmoticonInputView ()<LDEmoticonToolbarDelegate,UICollectionViewDataSource,LDEmoticonCellDelegate, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/// 工具栏
@property (weak, nonatomic) IBOutlet LDEmoticonToolbar *toolbar;
/// 分页控件
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/// 选中表情回调闭包属性
@property (nonatomic, copy) SelectedEmoticonCallBack selectedEmoticonCallBack;
@end

@implementation LDEmoticonInputView

+ (LDEmoticonInputView *)inputView:(SelectedEmoticonCallBack)selectedEmoticon {
    LDEmoticonInputView *v = [LDEmoticonInputView viewFromXib];
    // 记录block
    v.selectedEmoticonCallBack = selectedEmoticon;
    return v;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册可重用 cell
    [self.collectionView registerClass:[LDEmoticonCell class] forCellWithReuseIdentifier:cellId];
    // 设置工具栏代理
    self.toolbar.delegate = self;
    
    // 设置分页控件的图片
    NSBundle *bundle = [LDEmoticonManager share].bundle;
    UIImage *normalImage = [UIImage imageNamed:@"compose_keyboard_dot_normal" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *selectedImage = [UIImage imageNamed:@"compose_keyboard_dot_selected" inBundle:bundle compatibleWithTraitCollection:nil];
    
    // 使用填充图片设置颜色，生成的图片会有锯齿，在真机上比较明显，所以用kvc设置私有成员变量
    //self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:normalImage];
    //self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:selectedImage];
    
    [self.pageControl setValue:normalImage forKey:@"_pageImage"];
    [self.pageControl setValue:selectedImage forKey:@"_currentPageImage"];
}

#pragma mark CZEmoticonToolbarDelegate
- (void)emoticonToolbarDidSelected:(LDEmoticonToolbar *)toolbar index:(NSInteger)index{
    // 让 collectionView 发生滚动 -> 每一个分组的第0页
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    // 设置分组按钮的选中状态
    self.toolbar.selecedIndex = index;
}

#pragma mark LDEmoticonCellDelegate
- (void)emoticonCellDidSelected:(LDEmoticonCell *)cell emoticon:(LDEmotion *)em {
    NSLog(@"%@",em);
    self.selectedEmoticonCallBack(em);
    if (em == nil) {
        return;
    }
    // 如果当前 collectionView 就是最近的分组，不添加最近使用的表情
    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    if (indexPath.section == 0) {
        return;
    }
    
    // 添加最近使用的表情
    [[LDEmoticonManager share] recentEmoticon:em];
    
    // 刷新数据 - 第 0 组
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.collectionView reloadSections:indexSet];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1. 获取中心点
    CGPoint center = scrollView.center;
    center.x += scrollView.contentOffset.x;
    
    // 2. 获取当前显示的 cell 的 indexPath
    NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
    
    // 3. 判断中心点在哪一个 indexPath 上，在哪一个页面上
    NSIndexPath *targetIndexPath;
    for (NSIndexPath *indexPath in indexPaths) {
        // 1> 根据 indexPath 获得 cell
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        // 2> 判断中心点位置
        if (CGRectContainsPoint(cell.frame, center) == YES) {
            targetIndexPath = indexPath;
            break;
        }
    }
    if (targetIndexPath == nil) {
        return;
    }
    
    // 4. 判断是否找到 目标的 indexPath
    // indexPath.section => 对应的就是分组
    self.toolbar.selecedIndex =  targetIndexPath.section;
    // 5. 设置分页控件
    // 总页数，不同的分组，页数不一样
    self.pageControl.numberOfPages = [self.collectionView numberOfItemsInSection:targetIndexPath.section];
    self.pageControl.currentPage = targetIndexPath.item;
}

#pragma mark UICollectionViewDataSource
// 分组数量 - 返回表情包的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger sectionCount = [LDEmoticonManager share].packages.count;
    return sectionCount;
}

// 返回每个分组中的表情`页`的数量
// 每个分组的表情包中 表情页面的数量 emoticons 数组 / 20
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [LDEmoticonManager share].packages[section].numberOfPages;
    NSLog(@"----%zd",count);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 取 cell
    LDEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // 2. 设置 cell - 传递对应页面的表情数组
    cell.emoticons = [[LDEmoticonManager share].packages[indexPath.section] emoticonInPage:indexPath.item];
    // 设置代理，不适合用block
    cell.delegate = self;
    
    // 3. 返回 cell
    return cell;
}


@end
