//
//  NSDate+Tools.h
//  BSProject
//
//  Created by Liu-Mac on 13/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tools)

+ (NSDate *)dateWithString:(NSString *)str dateFormat:(NSString *)dateFormat;

+ (NSDateComponents *)compareDateFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)isThisDay;
- (BOOL)isYesterDay;
- (BOOL)isThisYear;

@end
