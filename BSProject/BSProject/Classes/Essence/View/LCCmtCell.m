//
//  LCCmtCell.m
//  BSProject
//
//  Created by Liu-Mac on 18/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCCmtCell.h"

#import "LCCmtItem.h"
#import "LCCmtUserItem.h"

#import <UIImageView+WebCache.h>

@interface LCCmtCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageV;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *like_countL;

@property (weak, nonatomic) IBOutlet UILabel *commentL;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end

@implementation LCCmtCell

- (void)setItem:(LCCmtItem *)item {
    
    _item = item;
    
    [self.profileImageV sd_setImageWithURL:[NSURL URLWithString:item.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.sexImageV.image = [item.user.sex isEqualToString:ManSex] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    
    self.nameL.text = item.user.username;
    
    self.like_countL.text = item.like_count;
    
    self.commentL.text = item.content;
    
    if (item.voicetime != 0) {
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''", item.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceBtn.hidden = YES;
    }
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = EssenceCellMargin;
    frame.size.width = ScreenW - 2 * EssenceCellMargin;
    
    [super setFrame:frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageOfResizableWithName:@"mainCellBackground"];
    self.backgroundView = imageV;
}

@end