//
//  TAViewedStoresCell.h
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAViewedStoresCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel        * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel        * descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton       * followImageButton;
@property (weak, nonatomic) IBOutlet UIButton       * followButton;
@property (weak, nonatomic) IBOutlet UIImageView    * storeImageView;
@property (weak, nonatomic) IBOutlet ASJTagsView    * tagView;

@property (weak, nonatomic) IBOutlet UIButton *followingBtn;

@end
