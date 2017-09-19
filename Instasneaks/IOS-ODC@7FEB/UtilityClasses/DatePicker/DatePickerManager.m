//
//  DatePicker.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "DatePickerManager.h"

@interface DatePickerManager ()

@property (nonatomic, strong) UIViewController *parentController;

@end

@implementation DatePickerManager

+ (DatePickerManager *)dateManager {
    
    static DatePickerManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[DatePickerManager alloc] init];
    });
    return _sharedManager;
}

- (void)showDatePicker:(UIViewController *)parentController withBool:(BOOL)value completionBlock:(void (^)(NSDate *date))block {
    
    [self showDatePicker:parentController withBool:value withTitle:nil completionBlock:block];
}

- (void)showDatePicker:(UIViewController *)parentController withBool:(BOOL)maxBool withTitle:(NSString *)title completionBlock:(void (^)(NSDate *date))block {
    
    self.parentController = parentController;
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        //NSLog(@"Successfully selected date: %@", controller.contentView.date);
        block(controller.contentView.date);
    }];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        //NSLog(@"Date selection was cancelled");
        //block(nil);
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = title;
    //dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
//    RMAction<RMActionController<UIDatePicker *> *> *in15MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:15*60];
//        NSLog(@"15 Min button tapped");
//    }];
//    in15MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in30MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:30*60];
//        NSLog(@"30 Min button tapped");
//    }];
//    in30MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in45MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:45*60];
//        NSLog(@"45 Min button tapped");
//    }];
//    in45MinAction.dismissesActionController = NO;
//    
//    RMAction<RMActionController<UIDatePicker *> *> *in60MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
//        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:60*60];
//        NSLog(@"60 Min button tapped");
//    }];
//    in60MinAction.dismissesActionController = NO;
//    
//    RMGroupedAction<RMActionController<UIDatePicker *> *> *groupedAction = [RMGroupedAction<RMActionController<UIDatePicker *> *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
//    
//    [dateSelectionController addAction:groupedAction];
    
    
    if (self.showCurrentDateOption) {
        RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
            controller.contentView.date = [NSDate date];
            NSLog(@"Now button tapped");
        }];
        nowAction.dismissesActionController = NO;
        
        [dateSelectionController addAction:nowAction];
    }
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = NO;
    dateSelectionController.disableBlurEffects = YES;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate; // UIDatePickerModeDateAndTime
    //dateSelectionController.datePicker.minuteInterval = 5;
    //dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:+100];
    NSDate *maxDate = [calendar dateByAddingComponents:comp toDate:currentDate options:0];
    
    if(maxBool){
        [dateSelectionController.datePicker setMinimumDate:[NSDate date]];
        [dateSelectionController.datePicker setMaximumDate:maxDate];

    }
    else{
        [dateSelectionController.datePicker setMinimumDate:minDate];
        [dateSelectionController.datePicker setMaximumDate:[NSDate date]];

    }
    
    dateSelectionController.datePicker.date = [NSDate date];

//
//    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
//    //(Of course only if we are running on iOS 8 or later)
////    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
////        //First we set the modal presentation style to the popover style
////        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
////        
////        //Then we tell the popover presentation controller, where the popover should appear
////        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
////        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
////    }
//    
//    //Now just present the date selection controller using the standard iOS presentation method
    [parentController presentViewController:dateSelectionController animated:YES completion:nil];
    
}

//for time DatePickerManager

- (void)showTimePicker:(UIViewController *)parentController withBool:(BOOL)value completionBlock:(void (^)(NSDate *date))block {
    
    [self showTimePicker:parentController withBool:value withTitle:nil completionBlock:block];
}

- (void)showTimePicker:(UIViewController *)parentController withBool:(BOOL)maxBool withTitle:(NSString *)title completionBlock:(void (^)(NSDate *date))block {
    
    self.parentController = parentController;
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        block(controller.contentView.date);
    }];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {

    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = title;

    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    if (self.showCurrentDateOption) {
        RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
            controller.contentView.date = [NSDate date];
            NSLog(@"Now button tapped");
        }];
        nowAction.dismissesActionController = NO;
        
        [dateSelectionController addAction:nowAction];
    }
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = YES;
    dateSelectionController.disableMotionEffects = NO;
    dateSelectionController.disableBlurEffects = YES;
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
//    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:+100];
//    NSDate *maxDate = [calendar dateByAddingComponents:comp toDate:currentDate options:0];
    
//    if(maxBool){
//        [dateSelectionController.datePicker setMinimumDate:[NSDate date]];
//        [dateSelectionController.datePicker setMaximumDate:maxDate];
//        
//    }
//    else{
//        [dateSelectionController.datePicker setMinimumDate:minDate];
//        [dateSelectionController.datePicker setMaximumDate:[NSDate date]];
//        
//    }
    
    dateSelectionController.datePicker.date = [NSDate date];
    [parentController presentViewController:dateSelectionController animated:YES completion:nil];
    
}

@end
