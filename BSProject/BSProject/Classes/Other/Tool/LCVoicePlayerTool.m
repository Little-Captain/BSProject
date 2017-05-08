//
//  LCVoicePlayerTool.m
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVoicePlayerTool.h"

static LCVoicePlayerTool *_instance;

@interface LCVoicePlayerTool ()

/** player */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation LCVoicePlayerTool

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    
    return _instance;
}

- (void)setUrlStr:(NSString *)urlStr {
    
    // 如果两次的播放资源一样, 直接返回
    if (_urlStr == urlStr) { return; }
    
    _urlStr = urlStr;
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:urlStr]];
    AVPlayerItem *playeritem = [AVPlayerItem playerItemWithAsset:asset];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_player replaceCurrentItemWithPlayerItem:playeritem];
        [_player play];
    });
}

- (CMTime)currentTime {
    
    return _player.currentTime;
}

@end
