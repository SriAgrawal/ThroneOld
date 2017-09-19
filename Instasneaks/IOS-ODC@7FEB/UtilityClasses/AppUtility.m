//
//  AppUtility.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "AppUtility.h"
#import "Macro.h"

@implementation AppUtility

+ (void)delay:(double)delayInSeconds :(void(^)(void))callback {
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        if(callback){
            callback();
        }
    });
}
+(NSString *)dateStringFromDate:(NSDate *)selectedDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    return [dateFormatter stringFromDate:selectedDate];
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Font <<<<<<<<<<<<<<<<<<<<<<<<*/

+ (UIFont *)sofiaProBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SofiaPro-Bold" size:size];
}

+ (UIFont *)sofiaProLightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SofiaProLight" size:size];
}

+(NSAttributedString *)customAttributeString:(NSString *)stringText withAlignment:(NSTextAlignment)align{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:stringText];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = align;
    [pStyle setLineSpacing:6];
    [string addAttribute:NSFontAttributeName value:[self sofiaProLightFontWithSize:14] range:NSMakeRange(0, [stringText length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [stringText length])];
    
    if ([stringText containsString:@"INDEXTM"])
    {
        [string addAttribute:NSFontAttributeName value:[self sofiaProLightFontWithSize:8] range:NSMakeRange(14, 2)];
        [string addAttribute:NSBaselineOffsetAttributeName value:@5 range:NSMakeRange(14, 2)];
    }
    return string;
}

+(NSAttributedString *)customAttributeString:(NSString *)stringText withAlignment:(NSTextAlignment)align withFont:(UIFont *)font andLineSpace:(CGFloat)space{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:stringText];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = align;
    [pStyle setLineSpacing:space];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [stringText length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [stringText length])];
    
    return string;
}


+(UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    //NSString *doneOrNext;
    
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad:)];
    
    UIBarButtonItem *flexibleSpace =   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [numberToolbar setItems: [NSArray arrayWithObjects:flexibleSpace,doneBtn, nil] animated:NO];
    
    [numberToolbar sizeToFit];
    
    return numberToolbar;
}

-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    
}

+(NSString *)getDateFromString:(NSString *)string{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate * date = [dateFormat dateFromString:string];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"MMMM yyyy"];
    
    return  [dateFormater stringFromDate:date];
}

void setHintFor (id elemnt, NSIndexPath *index) {
    [elemnt setAccessibilityLabel:[NSString stringWithFormat:@"%ld,%ld",(long)index.row,(long)index.section]];
}

NSIndexPath * getIndexPathFor (id elemnt) {
    
    NSArray *accessibilityArray = [[elemnt accessibilityLabel] componentsSeparatedByString:@","];
    return (([accessibilityArray count] == 2 ) ? [NSIndexPath indexPathForRow:[[accessibilityArray firstObject] integerValue] inSection:[[accessibilityArray lastObject] integerValue]] : [NSIndexPath indexPathForRow:-1 inSection:-1]);
}
@end
