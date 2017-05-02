//
//  LCShareTool.h
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@class LCTopicItem;

@interface LCShareTool : NSObject

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType item:(LCTopicItem *)item vc:(UIViewController *)vc;

@end
