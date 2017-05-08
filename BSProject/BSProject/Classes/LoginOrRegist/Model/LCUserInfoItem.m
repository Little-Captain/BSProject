//
//  LCUserInfoItem.m
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCUserInfoItem.h"
#import <YYModel.h>

@implementation LCUserInfoItem

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    return [self yy_modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [self yy_modelEncodeWithCoder:coder];
}

@end
