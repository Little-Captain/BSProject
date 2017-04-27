//
//  LCEssencePicView.h
//  BSProject
//
//  Created by Liu-Mac on 14/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTopicItem;

@interface LCEssencePicView : UIView

/** topic item */
@property (nonatomic, strong) LCTopicItem *topicItem;

+ (instancetype)essencePicView;

@end
