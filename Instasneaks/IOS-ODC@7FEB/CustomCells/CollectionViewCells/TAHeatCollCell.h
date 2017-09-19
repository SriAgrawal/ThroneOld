//
//  TAHeatCollCell.h
//  Throne
//
//  Created by Priya Sharma on 17/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAHeatCollCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *heatButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end
