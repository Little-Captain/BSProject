//
//  UIImageView+Tools.m
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "UIImageView+Tools.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Tools)

- (void)setHeader:(NSString *)url {
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}

@end
