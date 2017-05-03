//
//  UIImageView+Tools.m
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "UIImageView+Tools.h"
#import <UIImageView+YYWebImage.h>

@implementation UIImageView (Tools)

- (void)setHeader:(NSString *)url {
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:placeholder options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}

@end
