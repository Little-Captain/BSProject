//
//  LCPublishView.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCPublishWordVC.h"
#import "LCPlaceholderTextView.h"
#import "LCAddTagToolbar.h"

@interface LCPublishWordVC () <UITextViewDelegate>

/** 文本输入控件 */
@property (nonatomic, weak) LCPlaceholderTextView *textView;
/** 工具条 */
@property (nonatomic, weak) LCAddTagToolbar *toolbar;

@end

@implementation LCPublishWordVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNav];
    [self setupTextView];
    [self setupToolbar];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    // 键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,  keyboardF.origin.y - ScreenH);
    }];
}

- (void)setupToolbar {
    
    LCAddTagToolbar *toolbar = [LCAddTagToolbar viewFromXib];
    toolbar.fWidth = self.view.fWidth;
    toolbar.fY = self.view.fHeight - toolbar.fHeight;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupTextView {
    
    LCPlaceholderTextView *textView = [[LCPlaceholderTextView alloc] init];
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupNav {
    
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post {
    
    LogFun();
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

@end
