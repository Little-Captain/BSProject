//
//  LCShareTool.h
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@class LCTopicItem;

@interface LCShareTool : NSObject

+ (void)showShareMenuViewInWindowWithVc:(UIViewController *)vc item:(LCTopicItem *)item;

@end
