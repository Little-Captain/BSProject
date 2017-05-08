//
//  LCThirdLoginTool.h
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


@interface LCThirdLoginTool : NSObject

+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType vc:(UIViewController *)vc;

@end
