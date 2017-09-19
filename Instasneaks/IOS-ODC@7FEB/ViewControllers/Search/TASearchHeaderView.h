//
//  TASearchHeaderView.h
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TASearchHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton           * cancelButton;
@property (weak, nonatomic) IBOutlet UIButton           * categoryButton;
@property (weak, nonatomic) IBOutlet UIButton           * shareButton;
@property (weak, nonatomic) IBOutlet UIButton           * homeButton;
@property (weak, nonatomic) IBOutlet UITextField        * serachTextField;

+ (instancetype)instantiateFromNib;

@end
