//
//  TAAuthTableCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 20/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAAuthTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TextField *tableTextField;
@property (weak, nonatomic) IBOutlet UIButton   *cellButton;
@property (strong, nonatomic) IBOutlet REFormattedNumberField *phoneTextField;
@property (strong, nonatomic) IBOutlet TextField *dropDownTextField;
@property (strong, nonatomic) IBOutlet UIImageView *dropDownImage;
@end
