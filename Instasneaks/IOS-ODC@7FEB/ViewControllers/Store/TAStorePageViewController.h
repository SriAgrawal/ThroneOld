//
//  TAStorePageViewController.h
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"
@class TAStorePageHeaderView;

@interface TAStorePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) IBOutlet UIButton *gridButton;
@property (strong, nonatomic) IBOutlet UIButton *allButton;
@property (strong, nonatomic) IBOutlet UIButton *soldButton;
@property (strong, nonatomic) IBOutlet UIButton *forSaleButton;

@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) IBOutlet UILabel *soldLabel;
@property (strong, nonatomic) IBOutlet UILabel *forSaleLabel;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) TAStorePageHeaderView * headerView;

@end
