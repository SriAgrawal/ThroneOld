//
//  TAExpandableTextCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 24/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAExpandableTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLbl;
@property (weak, nonatomic) IBOutlet YTPlayerView *videoPlayerView;
@end
