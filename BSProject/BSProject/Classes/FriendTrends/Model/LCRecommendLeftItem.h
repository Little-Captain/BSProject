//
//  LCRecommendLeftItem.h
//  BSProject
//
//  Created by Liu-Mac on 4/26/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRecommendLeftItem : NSObject

// name	string	标签名称
// count	int	此标签下的用户数
// id	string	标签id

/** 标签名称 */
@property (nonatomic, strong) NSString *name;

/** 此标签下的用户数 */
@property (nonatomic, assign) NSInteger count;

/** 标签id */
@property (nonatomic, assign) NSInteger ID;

// 这里定义一个用户组
// 在下载了当前用户组后就把他存入这个数组, 这样子我们后面就可以避免重复下载
// 一个类别的下的用户, 由这个类别的模型维护
/** 当类别下的用户 */
@property (nonatomic, strong) NSArray *users;

/** 用户总数 */
@property (nonatomic, assign) NSInteger total;

/** 当前的页码 */
@property (nonatomic, assign) NSInteger currentPage;

@end
