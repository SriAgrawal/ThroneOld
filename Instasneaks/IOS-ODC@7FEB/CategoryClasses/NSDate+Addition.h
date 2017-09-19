//
//  NSDate+Addition.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

- (NSString *)UTCDateFormat;
- (NSString *)getDateString;
- (NSString *)getDateStringWithFormat:(NSString *)format;
- (NSString *)getTimeString;
- (NSString *)getDateTimeWithFormat;

@end
