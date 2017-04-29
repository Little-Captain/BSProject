//
//  LCAddTagVC.h
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAddTagVC : UIViewController

@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);
@property (nonatomic, strong) NSArray *tags;

@end
