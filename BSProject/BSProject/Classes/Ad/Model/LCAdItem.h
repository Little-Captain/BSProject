//
//  LCAdItem.h
//  BSProject
//
//  Created by Liu-Mac on 5/4/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAdItem : NSObject

/** 广告图片 url */
@property(nonatomic,strong) NSString* w_picurl;
/** 原始链接 */
@property(nonatomic,strong) NSString* ori_curl;
/** 图片宽度 */
@property(nonatomic, assign) CGFloat w;
/** 图片高度 */
@property(nonatomic, assign) CGFloat h;

@end
