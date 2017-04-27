//
//  LCRecTagTableViewCell.m
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCRecTagTableViewCell.h"
#import "LCRecTagItem.h"

#import <UIImageView+WebCache.h>

@interface LCRecTagTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *followL;

@end

@implementation LCRecTagTableViewCell

- (void)setItem:(LCRecTagItem *)item {
    
    _item = item;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.titleL.text = item.theme_name;
    self.followL.text = item.sub_number;
}

// cell的frame是在tableView中计算好, 再赋值的
// 在这里改变frame, 可以最终决定cell的实际显示
// 位置和大小.
// 这里的改变不影响tableView中计算的cell的frame
- (void)setFrame:(CGRect)frame {
    
    // table view的contentInset需要做相应的设置
    // UIEdgeInsetsMake(0, 0, 下移多少补回多少, 0);
    frame.origin.y += 1;
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
    
}

@end
