//
//  WBComposeViewController.m
//  OCThreeWeibo
//
//  Created by 郑鸿钦 on 2017/5/4.
//  Copyright © 2017年 Leedian. All rights reserved.
//

#import "WBComposeViewController.h"
#import "WBComposeTextView.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "LDEmoticonInputView.h"
#import "UIView+CZAddition.h"

@interface WBComposeViewController ()<UITextViewDelegate>
/// 文本编辑视图
@property (weak, nonatomic) IBOutlet WBComposeTextView *composeTextView;
 /// 底部工具栏
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
/// 发布按钮
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
/// 标题标签 - 换行的热键 option + 回车
/// 逐行选中文本并且设置属性
/// 如果要想调整行间距，可以增加一个空行，设置空行的字体，lineHeight
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/// 工具栏底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomCons;
/// 表情输入视图
@property (nonatomic, strong) LDEmoticonInputView *emtoticonView;

@end

@implementation WBComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // 监听键盘通知 - UIWindow.h
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //self.composeTextView.text = @"😃";
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 激活键盘
    [self.composeTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 设置文本视图的代理
    self.composeTextView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.composeTextView.y = 64;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭键盘
    [self.composeTextView resignFirstResponder];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupToolBar];
}


- (IBAction)postStatus:(id)sender {
    // 1. 获取发送给服务器的表情微博文字
    NSString *text = self.composeTextView.emoticonText;
    NSLog(@"-----%@",text);
    
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 切换表情键盘
- (void)emoticonKeyboard {
    NSLog(@"切换表情键盘");
    // textView.inputView 就是文本框的输入视图
    // 如果使用系统默认的键盘，输入视图为 nil
    
    // 1> 测试键盘视图 - 视图的宽度可以随便，就是屏幕的宽度
    //        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
    //        keyboardView.backgroundColor = UIColor.blue()
    
    // 2> 设置键盘视图
    self.composeTextView.inputView = (self.composeTextView.inputView == nil) ?
    self.emtoticonView : nil;
    
    // 3> !!!刷新键盘视图
    [self.composeTextView reloadInputViews];
}

/// 设置工具栏
- (void)setupToolBar {
    NSArray *itemSettings =@[@{@"imageName":@"compose_toolbar_picture"},
  @{@"imageName":@"compose_mentionbutton_background"},
  @{@"imageName":@"compose_trendbutton_background"},
  @{@"imageName":@"compose_emoticonbutton_background",@"actionName":@"emoticonKeyboard"},
  @{@"imageName":@"compose_add_background"}];
    // 遍历数组
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *dict in itemSettings) {
        UIImage *image = [UIImage imageNamed:dict[@"imageName"]];
        NSString *imageHLName = [NSString stringWithFormat:@"%@_highlighted",dict[@"imageName"]];
        UIImage *imageHL = [UIImage imageNamed:imageHLName];
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:imageHL forState:UIControlStateHighlighted];
        [btn sizeToFit];
        // 判断 actionName
        if (dict[@"actionName"] != nil) {
            // 给按钮添加监听方法
            NSString *actionName = dict[@"actionName"];
            [btn addTarget:self action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
        }
        // 追加按钮
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:btn]];
        // 追加弹簧
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    }
    // 删除末尾弹簧
    [items removeLastObject];
    self.toolBar.items = items;
}

- (void)keyboardChange:(NSNotification *)n {
    NSLog(@"%@",n.userInfo);
    CGRect rect = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2、设置底部约束的高度
    CGFloat offset = self.view.bounds.size.height - rect.origin.y;
    // 3、更新底部约束
    self.toolBarBottomCons.constant = offset;
    // 4、动画更新约束
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)textViewDidChange:(UITextView *)textView {
    self.sendButton.enabled = [self.composeTextView hasText];
}


- (LDEmoticonInputView *)emtoticonView {
    if (_emtoticonView == nil) {
        __weak __typeof(&*self) weakSelf = self;
        _emtoticonView = [LDEmoticonInputView inputView:^(LDEmotion *emoticon) {
            [weakSelf.composeTextView insertEmoticon:emoticon];
        }];
    }
    return _emtoticonView;
}

@end
