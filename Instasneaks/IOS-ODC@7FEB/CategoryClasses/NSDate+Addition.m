//
//  NSDate+Addition.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

- (NSString *)UTCDateFormat {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"];
    
    return [dateFormat stringFromDate:self];
}

- (NSString *)getDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MM yyyy"];
    
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)getDateStringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)getTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[self enUSPosixlocal]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    return [dateFormatter stringFromDate:self];
    
}

- (NSLocale *)enUSPosixlocal {
    return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}
- (NSString *)getDateTimeWithFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
     NSString *newDate = [dateFormatter stringFromDate:self];
    return newDate;

}
@end
