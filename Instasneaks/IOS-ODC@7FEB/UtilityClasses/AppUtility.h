//
//  AppUtility.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtility : NSObject

+ (void)delay:(double)delayInSeconds :(void(^)(void))callback;

+(NSString *)dateStringFromDate:(NSDate *)selectedDate;

+ (UIFont *)sofiaProBoldFontWithSize:(CGFloat)size;

+ (UIFont *)sofiaProLightFontWithSize:(CGFloat)size;

+(NSAttributedString *)customAttributeString:(NSString *)stringText withAlignment:(NSTextAlignment)align;

+(NSAttributedString *)customAttributeString:(NSString *)stringText withAlignment:(NSTextAlignment)align withFont:(UIFont *)font andLineSpace:(CGFloat)space;

+(UIImage *)imageFromColor:(UIColor *)color;

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);

+(NSString *)getDateFromString:(NSString *)string;
void setHintFor (id elemnt, NSIndexPath *index);
NSIndexPath * getIndexPathFor (id elemnt);

@end
