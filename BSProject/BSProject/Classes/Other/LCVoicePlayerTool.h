//
//  LCVoicePlayerTool.h
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LCVoicePlayerTool : NSObject

/** item */
@property (nonatomic, strong) NSString *urlStr;
/** currentTime */
@property (nonatomic, assign, readonly) CMTime currentTime;
/** player */
@property (nonatomic, strong, readonly) AVPlayer *player;

+ (instancetype)sharedInstance;

@end
