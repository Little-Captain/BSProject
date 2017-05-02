//
//  NSString+LCExtension.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "NSString+LCExtension.h"

@implementation NSString (LCExtension)

+ (instancetype)musicTimeFormater:(NSInteger)time {
    
    if (time <= 0) { return @"00:00"; }
    
    // 分钟
    NSInteger min = time / 60;
    // 秒
    NSInteger second = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", min, second];
}

@end
