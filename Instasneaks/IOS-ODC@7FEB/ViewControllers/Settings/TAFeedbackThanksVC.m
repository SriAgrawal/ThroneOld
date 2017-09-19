//
//  TAFeedbackThanksVC.m
//  Throne
//
//  Created by Aman Goswami on 21/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAFeedbackThanksVC.h"

@interface TAFeedbackThanksVC ()

@end

@implementation TAFeedbackThanksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)crossBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)returnBtnAction:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
