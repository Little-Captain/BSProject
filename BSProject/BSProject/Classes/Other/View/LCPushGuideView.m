//
//  LCPushGuideView.m
//  BSProject
//
//  Created by Liu-Mac on 09/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCPushGuideView.h"

@implementation LCPushGuideView

+ (instancetype)pushGuideView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"LCPushGuideView" owner:nil options:nil].lastObject;
    
}

+ (void)show {
    
    NSString *versionKey = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] valueForKey:versionKey];
    
    if (currentVersion != oldVersion) {
        LCPushGuideView *pushGuideView = [LCPushGuideView pushGuideView];
        pushGuideView.frame = KeyWindow.bounds;
        [KeyWindow addSubview:pushGuideView];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
- (IBAction)knownBtnClick {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.fY = self.fHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
