//
//  ViewController.m
//  EmoticonView
//
//  Created by 郑鸿钦 on 2017/7/13.
//  Copyright © 2017年 HONG. All rights reserved.
//

#import "ViewController.h"
#import "WBComposeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushToEmoticonVC:(id)sender {
    WBComposeViewController *composeVC = [[WBComposeViewController alloc] init];
    [self.navigationController pushViewController:composeVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
