//
//  TASingleTextFieldTVC.m
//  Throne
//
//  Created by Priya Sharma on 10/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASingleTextFieldTVC.h"

@implementation TASingleTextFieldTVC

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 10)];
//    _singleTextField.leftView = paddingView;
//    _singleTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
