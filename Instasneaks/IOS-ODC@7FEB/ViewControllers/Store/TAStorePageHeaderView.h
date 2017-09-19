//
//  TAStorePageHeaderView.h
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TAStorePageHeaderView : UIView


@property (strong, nonatomic) IBOutlet UIImageView * storePageHeaderImageView;
@property (strong, nonatomic) IBOutlet UIImageView * heatIndexWhiteImageView;

@property (strong, nonatomic) IBOutlet UIButton * backLeftArrowButton;
@property (strong, nonatomic) IBOutlet UIButton * followButton;
@property (strong, nonatomic) IBOutlet UIButton * moreInfoButton;

@property (strong, nonatomic) IBOutlet UILabel * moreInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel * heatIndexLabel;
@property (strong, nonatomic) IBOutlet UILabel * viewsAndFollowersLabel;
@property (weak, nonatomic) IBOutlet ASJTagsView *tagsView;
@property (strong, nonatomic) IBOutlet UILabel * rarePairLabel;

//Following Suggestion View Properties
@property (strong, nonatomic) IBOutlet UIView * followingSuggestionView;

@property (strong, nonatomic) IBOutlet UILabel * othersWithHeatIndexTMLabel;

@property (strong, nonatomic) IBOutlet UIButton * closeButton;

@property (strong, nonatomic) IBOutlet UIImageView * heatBlackImageView;
@property (strong, nonatomic) IBOutlet UIButton * heatBlackButton;

@property (strong, nonatomic) IBOutlet UICollectionView * suggestionsCollectionView;

//More Info View Properties
@property (strong, nonatomic) IBOutlet UIView * moreInfoView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView * starRatingView;

@property (strong, nonatomic) IBOutlet UILabel * detailLabel;
@property (strong, nonatomic) IBOutlet UILabel * heatLabel;
@property (strong, nonatomic) IBOutlet UILabel * followersAndDailyViewsLabel;
@property (strong, nonatomic) IBOutlet UILabel * sellsLabel;
@property (strong, nonatomic) IBOutlet UILabel * sellsTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton * moreInfoCloseButton;
@property (strong, nonatomic) IBOutlet UIButton * moreInfoPlusButton;
@property (strong, nonatomic) IBOutlet UIButton * shareButton;
@property (strong, nonatomic) IBOutlet UIButton * moreButton;

@property (strong, nonatomic) IBOutlet UIImageView * heatImageView;

@property (weak, nonatomic) IBOutlet UILabel   * membersNameLabel;
@property (weak, nonatomic) IBOutlet UILabel   * addressNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeInfoBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *editorialBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;


+ (instancetype)instantiateFromNib;
@end
