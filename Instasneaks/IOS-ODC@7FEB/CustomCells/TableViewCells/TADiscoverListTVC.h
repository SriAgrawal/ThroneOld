//
//  TADiscoverListTVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 30/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@interface TADiscoverListTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *articleTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *articleDiscriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryBtnBottomConstraints;
@property (weak, nonatomic) IBOutlet ASJTagsView *otherArticleTagView;
@property (weak, nonatomic) IBOutlet UIButton *articleTitleBtn;
@property (weak, nonatomic) IBOutlet UIButton *articleImageBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet YTPlayerView *articleVideoView;
@end
