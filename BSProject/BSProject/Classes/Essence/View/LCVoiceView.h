//
//  LCVoiceView.h
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTopicItem, LCVoicePlayerView;

@interface LCVoiceView : UIView

+ (instancetype)voiceView;

/** topic item */
@property (nonatomic, strong) LCTopicItem *item;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/** voicePlayerView */
@property (nonatomic, weak) LCVoicePlayerView *voicePlayerView;

@end
