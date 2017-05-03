//
//  LCVideoPlayerView.h
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCVideoPlayerVC : UIViewController

/** video player view frame */
@property (nonatomic, assign) CGRect videoPlayerViewFrame;
/** urlStr */
@property (nonatomic, strong) NSString *urlStr;

+ (void)showWithVideoFrame:(CGRect)videoFrame url:(NSString *)url image:(NSString *)image;

@end
