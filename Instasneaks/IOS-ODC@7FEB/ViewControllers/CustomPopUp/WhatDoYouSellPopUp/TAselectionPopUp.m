//
//  TAselectionPopUp.m
//  Throne
//
//  Created by Aman Goswami on 09/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAselectionPopUp.h"

@interface TAselectionPopUp ()

@end

@implementation TAselectionPopUp

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
