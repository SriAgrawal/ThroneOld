//
//  TATrendingStoreTableCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@interface TATrendingStoreTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLbl;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *storeRatingView;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet ASJTagsView *categoryTagView;

@end
