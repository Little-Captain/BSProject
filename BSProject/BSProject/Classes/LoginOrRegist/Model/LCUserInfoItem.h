//
//  LCUserInfoItem.h
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserInfoItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSDate *expiration;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconurl;
@property (nonatomic, strong) NSString *gender;

@end
