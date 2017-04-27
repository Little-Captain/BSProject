//
//  LCTopicTableViewController.h
//  BSProject
//
//  Created by Liu-Mac on 13/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTopicTableViewController : UITableViewController

/** type */
@property (nonatomic, assign) LCTopicType type;
/** category */
@property (nonatomic, strong) NSString *category;

@end
