//
//  LCLoginOrRegistVC.m
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCLoginOrRegistVC.h"
#import "LCUserTool.h"

#import <SVProgressHUD.h>

@interface LCLoginOrRegistVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;

@end

@implementation LCLoginOrRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (IBAction)closeLogin {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registe:(UIButton *)btn {
    
    // 通过view辞退键盘, 而不是使用resignFirstResponder方法
    // 这个方法对view无效
    [self.view endEditing:YES];
    
    if (btn.selected) {
        btn.selected = NO;
        self.leadingConstraint.constant = 0;
    } else {
        btn.selected = YES;
        self.leadingConstraint.constant = -self.view.fWidth;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sinaLogin {
    
    
    [LCUserTool loginUseSinaWithVc:nil completion:^(BOOL isSuccess) {
        [self dismissViewControllerAnimated:NO completion:nil];
        isSuccess ? ({
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }) : ({
            [SVProgressHUD showSuccessWithStatus:@"登录失败"];
        });
    }];
}

@end
