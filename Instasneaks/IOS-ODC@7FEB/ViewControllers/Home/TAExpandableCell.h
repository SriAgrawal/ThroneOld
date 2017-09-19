//
//  TAExpandableCell.h
//  Throne
//
//  Created by Anil Kumar on 02/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAExpandableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
