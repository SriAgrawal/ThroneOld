//
//  OptionPickerManager.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMPickerViewController.h"

@interface OptionPickerManager : NSObject

+ (OptionPickerManager *)pickerManagerManager;
- (void)showOptionPicker:(UIViewController *)parentController withData:(NSArray *)data completionBlock:(void (^)(NSArray *selectedIndexes, NSArray *selectedValues))block;

@end
