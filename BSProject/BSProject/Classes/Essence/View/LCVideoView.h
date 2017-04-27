//
//  LCVideoView.h
//  BSProject
//
//  Created by Liu-Mac on 16/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTopicItem;

@interface LCVideoView : UIView

+ (instancetype)videoView;

/** topic item */
@property (nonatomic, strong) LCTopicItem *item;

@end
