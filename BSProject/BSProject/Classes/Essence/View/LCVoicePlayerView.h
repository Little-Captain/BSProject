//
//  LCVoicePlayerView.h
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LCVoicePlayerView : UIView

/** topic item */
@property (nonatomic, assign) NSInteger totalTime;
/** player */
@property (nonatomic, strong) AVPlayer *player;

@end
