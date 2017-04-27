//
//  LCRightTableViewCell.m
//  BSProject
//
//  Created by Liu-Mac on 06/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCRightTableViewCell.h"

#import "LCRecommendRightItem.h"

#import <UIImageView+WebCache.h>

@interface LCRightTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *fansL;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

@implementation LCRightTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.followBtn setBackgroundImage:[UIImage imageOfResizableWithName:@"friendsTrend_login"] forState:UIControlStateNormal];
    
}

- (IBAction)followBtnClick:(UIButton *)sender {
    
    
    // TODO
    // 如果没有登录, 点击关注, 我们需要弹出登录界面
    [self.window.rootViewController presentViewController:[NSClassFromString(@"LCLoginOrRegistVC") new] animated:YES completion:nil];
    
}


- (void)setItem:(LCRecommendRightItem *)item {
    
    _item = item;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.header] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageV.image = [UIImage imageWithCornerRadius:25.0 image:[UIImage imageWithSize:CGSizeMake(50, 50) image:image]];
    }];
    
    self.nameL.text = item.screen_name;
    self.fansL.text = [NSString stringWithFormat:@"%zd人关注", item.fans_count];
    self.followBtn.enabled = !(item.is_follow);
    
}

@end
