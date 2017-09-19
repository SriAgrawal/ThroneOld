//
//  TAProductDetailOptionsCell.h
//  Throne
//
//  Created by Suresh patel on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAProductDetailOptionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet ASJTagsView *moreTagView;

@end
