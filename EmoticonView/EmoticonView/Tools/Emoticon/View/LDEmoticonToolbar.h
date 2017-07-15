//
//  LDEmoticonToolbar.h
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/6/10.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDEmoticonToolbar;

@protocol LDEmoticonToolbarDelegate <NSObject>

/// 表情工具栏选中分组项索引
///
/// - parameter toolbar: 工具栏
/// - parameter index:   索引
- (void)emoticonToolbarDidSelected:(LDEmoticonToolbar *)toolbar index:(NSInteger)index;

@end

@interface LDEmoticonToolbar : UIView

@property (nonatomic, weak) id<LDEmoticonToolbarDelegate> delegate;

@property (nonatomic, assign) NSInteger selecedIndex;

@end
