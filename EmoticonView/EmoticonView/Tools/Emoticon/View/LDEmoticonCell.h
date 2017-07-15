//
//  LDEmoticonCell.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDEmoticonCell;
@class LDEmotion;

@protocol LDEmoticonCellDelegate <NSObject>

/// 表情 cell 选中表情模型
///
/// - parameter em: 表情模型／nil 表示删除
- (void)emoticonCellDidSelected:(LDEmoticonCell *)cell emoticon:(LDEmotion *)em;

@end

@interface LDEmoticonCell : UICollectionViewCell

@property (nonatomic, weak) id<LDEmoticonCellDelegate> delegate;

@property (nonatomic, strong) NSArray<LDEmotion *> *emoticons;
@end
