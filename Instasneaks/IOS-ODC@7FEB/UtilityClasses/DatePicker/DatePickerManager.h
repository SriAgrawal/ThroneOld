//
//  DatePicker.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface DatePickerManager : NSObject

+ (DatePickerManager *)dateManager;

@property (assign, nonatomic) BOOL showCurrentDateOption;

- (void)showDatePicker:(UIViewController *)parentController withBool:(BOOL)value completionBlock:(void (^)(NSDate *date))block;

- (void)showDatePicker:(UIViewController *)parentController withBool:(BOOL )maxBool withTitle:(NSString *)title completionBlock:(void (^)(NSDate *date))block;
- (void)showTimePicker:(UIViewController *)parentController withBool:(BOOL)value completionBlock:(void (^)(NSDate *date))block ;

- (void)showTimePicker:(UIViewController *)parentController withBool:(BOOL)maxBool withTitle:(NSString *)title completionBlock:(void (^)(NSDate *date))block;
@end
