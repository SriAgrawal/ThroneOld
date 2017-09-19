//
//  TAPageStoreContainerViewController.m
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPageStoreContainerViewController.h"
#import "TAEditorialVC.h"
#import "Macro.h"
static NSString *cellIdentifierCollectionView = @"TAStorePageCollectionViewCell";

@interface TAPageStoreContainerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat totalWidthOfTagView;
    TAStoreInfo *storeDetailsObj;
    NSInteger addHeight;
}
@property(strong, nonatomic) NSMutableArray             * controllersArray;
@property (strong, nonatomic) TAStorePageHeaderView     * headerView;
@property(strong, nonatomic) NSMutableArray             *dataSourceArray;
@property(strong, nonatomic) NSMutableArray             *suggestedArray;

@end

@implementation TAPageStoreContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    totalWidthOfTagView = 0.0f;
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.suggestedArray = [[NSMutableArray alloc] init];
    [self setUpPagerController];

    [self makeApiCallToGetStoreDetails:self.storeId];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - helper methods
-(void)setUpPagerController{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    
    TAStorePageViewController *storeVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAStorePageViewController"];
    
    self.controllersArray = [NSMutableArray arrayWithObjects:storeVC, nil];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [TAStorePageHeaderView instantiateFromNib];
    self.headerView.moreInfoView.hidden = YES;
    self.headerView.followingSuggestionView.hidden = YES;
    [self.headerView.suggestionsCollectionView registerNib:[UINib nibWithNibName:cellIdentifierCollectionView bundle:nil] forCellWithReuseIdentifier:cellIdentifierCollectionView];
    self.headerView.suggestionsCollectionView.dataSource = self;
    self.headerView.suggestionsCollectionView.delegate = self;
    [self.headerView.storeInfoBottomConstraint setConstant:-3];
    
    [self.headerView.backLeftArrowButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.moreInfoButton addTarget:self action:@selector(moreOrLessInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.closeButton addTarget:self action:@selector(closeOnFollowingViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.moreInfoCloseButton addTarget:self action:@selector(moreOrLessInfoCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.moreInfoPlusButton addTarget:self action:@selector(moreInfoPlusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.heatBlackButton addTarget:self action:@selector(heatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self.headerView.editorialBtn addTarget:self action:@selector(editorialBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [storeVC setHeaderView:self.headerView];
    self.segmentedPager.parallaxHeader.view = self.headerView;
    
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeBottom;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight = 0;
    self.segmentedPager.bounces = NO;
    
    CGFloat height = 352;
    
    if ([storeDetailsObj.storeDescription length]) {
        [self.headerView.detailLabel setText:storeDetailsObj.storeDescription];
        NSDictionary *attributes = @{NSFontAttributeName: self.headerView.detailLabel.font};
        
        CGRect rect = [storeDetailsObj.storeDescription boundingRectWithSize:CGSizeMake(windowWidth-140, CGFLOAT_MAX)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:attributes
                                                                     context:nil];
        addHeight = rect.size.height;
        height = height + addHeight;
        self.headerView.descriptionHeightConstraint.constant = addHeight;
        [self.view layoutIfNeeded];
    }
    self.segmentedPager.parallaxHeader.height = 352;
    [self setDataFromApi];
    // Segmented Control customization
    [self.segmentedPager reloadData];
    
}
-(void)setDataFromApi{
    [self getNameLetters];
    [self manageStoreDetailsViewData:storeDetailsObj];
    
    if (storeDetailsObj.isFollow) {
        [self.headerView.followButton setBackgroundColor:[UIColor whiteColor]];
        [self.headerView.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headerView.followButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [self.headerView.followButton setTitleEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
        self.headerView.followingSuggestionView.hidden = NO;
        self.headerView.moreInfoView.hidden = YES;
        self.segmentedPager.parallaxHeader.height = 609;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.segmentedPager scrollToTopAnimated:NO];
        });
        [self makeApiCallToGetSuggestFollowDetails];
        [self.segmentedPager reloadData];
    }
}

-(void)getNameLetters{
    NSMutableArray* ar = [NSMutableArray array];
    if ([storeDetailsObj.storeName length]) {
        [storeDetailsObj.storeName enumerateSubstringsInRange:NSMakeRange(0, [storeDetailsObj.storeName length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
            [ar addObject:[word substringToIndex:1]];
            if (ar.count == 2) {
                *stop = YES;
            }
        }];
        
        NSString * logoString = [ar componentsJoinedByString:@""];
        if ([logoString length])
            [_headerView.nameTextLabel setText:[logoString uppercaseString]];
    }
}
- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

-(void)manageStoreDetailsViewData:(TAStoreInfo *)storeObj{
    
    [_headerView.addressNameLabel setText:[storeObj.address_name uppercaseString]];
    self.headerView.followersAndDailyViewsLabel.text = storeObj.website;
    self.headerView.starRatingView.value = [storeObj.avg_rate intValue];
    
    NSString *viewString = ([storeObj.storeView_Count integerValue] >999) ? [NSString stringWithFormat:@"%ldK",[storeObj.storeView_Count integerValue]/1000] :[NSString stringWithFormat:@"%ld",[storeObj.storeView_Count integerValue]];
    
    NSString *followerString = ([storeObj.storeFollowers_Count integerValue] >999) ? [NSString stringWithFormat:@"%ldK",[storeObj.storeFollowers_Count integerValue]/1000] :[NSString stringWithFormat:@"%ld",[storeObj.storeFollowers_Count integerValue]];
    
    self.headerView.viewsAndFollowersLabel.text = [NSString stringWithFormat:@"%@ VIEWS / %@ FOLLOWERS",viewString,followerString];
    
    self.headerView.rarePairLabel.text = storeObj.storeName;
    
    totalWidthOfTagView = 0.0;
    
    if ([storeObj.storeDescription isEqualToString:@""]) {
        [self.headerView.moreInfoView setFrame:CGRectMake(0, self.headerView.moreInfoView.frame.origin.y, windowWidth,(self.headerView.moreInfoView.frame.size.height-190))];
    }
    for (NSString *str in storeObj.storeCategroyArray) {
        totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
    }
    totalWidthOfTagView = totalWidthOfTagView+5;
    if (totalWidthOfTagView < windowWidth) {
        [self.headerView.tagsView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.headerView.tagsView  setFrame:CGRectMake((windowWidth-totalWidthOfTagView)/2+3,self.headerView.tagsView .frame.origin.y ,totalWidthOfTagView, 30)];
    }
    
    [self.headerView.tagsView  replaceTags:storeObj.storeCategroyArray];
    [self.headerView.tagsView  setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
    
    switch ([storeObj.heat_index intValue]) {
        case 1:
            self.headerView.heatIndexWhiteImageView.image = [UIImage imageNamed:@"heat-index-white"];
            break;
        case 2:
            self.headerView.heatIndexWhiteImageView.image = [UIImage imageNamed:@"fire-2-white"];
            break;
        case 3:
            self.headerView.heatIndexWhiteImageView.image = [UIImage imageNamed:@"fire-white-3"];
            break;
        case 4:
            self.headerView.heatIndexWhiteImageView.image = [UIImage imageNamed:@"fire-white-4"];
            break;
        default:
            break;
    }
}

#pragma mark - selector method
-(void)backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)followButtonAction:(UIButton *)sender{
    if (storeDetailsObj.isFollow){
        storeDetailsObj.isFollow = NO;
        [self makeApiCallToGetProductUnFollowWithId:self.storeId];
    }else{
        storeDetailsObj.isFollow = YES;
        [self makeApiCallToGetProductFollowWithId:self.storeId];
    }
}

-(void)moreOrLessInfoButtonAction:(UIButton *)sender{
    self.headerView.followingSuggestionView.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager scrollToTopAnimated:NO];
    });
    sender.selected = !sender.selected;
    self.segmentedPager.parallaxHeader.height = ([sender isSelected] ? 770 + addHeight  : 352);

    [self.headerView.descriptionHeightConstraint setConstant:addHeight];
    [self.headerView setNeedsUpdateConstraints];
    self.headerView.moreInfoView.hidden = ![sender isSelected];
    [self.headerView.storeInfoBottomConstraint setConstant:0];
    [self.segmentedPager reloadData];
}

-(void)closeOnFollowingViewButtonAction:(UIButton *)sender{
    
    [self.headerView.moreInfoButton setSelected:NO];
    self.headerView.moreInfoView.hidden = YES;
    self.segmentedPager.parallaxHeader.height = 352;
    [self.headerView.storeInfoBottomConstraint setConstant:-3];
    self.headerView.followingSuggestionView.hidden = YES;
    [self.segmentedPager reloadData];
    
}

-(void)moreOrLessInfoCloseButtonAction:(UIButton *)sender{
    
    [self.headerView.moreInfoButton setSelected:NO];
    self.headerView.moreInfoView.hidden = YES;
    self.segmentedPager.parallaxHeader.height = 352;
    [self.headerView.storeInfoBottomConstraint setConstant:-3];
    self.headerView.followingSuggestionView.hidden = YES;
    [self.segmentedPager reloadData];

}

-(void)moreInfoPlusButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected)
        sender.backgroundColor = [UIColor blackColor];
    else
        sender.backgroundColor = [UIColor whiteColor];
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
    obj.isFrom = @"follow";
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
}

-(void)heatButtonAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
    obj.isFrom = @"heat";
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
    
}
//-(void)editorialBtnAction:(UIButton *)sender{
////    TAEditorialVC *editorVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAEditorialVC"];
////    [self.navigationController pushViewController:editorVC animated:YES];
////}

- (IBAction)shareButtonAction:(UIButton*)sender {
    
    NSString *textToShare = @"I thought you'd be interested. Please click on the link before it expires in 48 hours:";
    NSURL *myWebsite = [NSURL URLWithString:@"https://throne1.app.link/profile"];
    
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (IBAction)moreButtonAction:(UIButton*)sender {
    
    TAMoreVC *moreVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAMoreVC"];
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [objNav presentViewController:moreVC animated:YES completion:nil];
}

#pragma mark - UICollectionView Delegate and DataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.suggestedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TAStorePageCollectionViewCell *cell = (TAStorePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierCollectionView forIndexPath:indexPath];
    TAStoreInfo *storeInfoObj = [self.suggestedArray objectAtIndex:indexPath.item];
    cell.followingSuggestionTitleLabel.text = storeInfoObj.storeName;
    [cell.followingSuggestionImageView sd_setImageWithURL:[NSURL URLWithString:storeInfoObj.storeFollowerImage] placeholderImage:[UIImage new]] ;
    cell.followingSuggestionFollowButton.selected = storeInfoObj.isFollow;
    totalWidthOfTagView = 0.0;
    
    for (NSString *str in storeInfoObj.storeCategroyArray) {
        totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
    }
    [cell.tagView  replaceTags:storeInfoObj.storeCategroyArray];
    totalWidthOfTagView = totalWidthOfTagView -20;
    if (totalWidthOfTagView < 138) {
        [cell.tagView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.tagView  setFrame:CGRectMake((cell.frame.size.width-totalWidthOfTagView)/2+3,cell.tagView.frame.origin.y +5,totalWidthOfTagView , 22)];
    }else if (totalWidthOfTagView < windowWidth) {
        [cell.tagView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.tagView  setFrame:CGRectMake((cell.frame.size.width-totalWidthOfTagView)/2+15,cell.tagView.frame.origin.y +5,totalWidthOfTagView , 22)];
    }
    [cell.tagView  replaceTags:storeInfoObj.storeCategroyArray];
    [cell.tagView  setTagFont:[AppUtility sofiaProLightFontWithSize:10]];
    //  [cell.followingSuggestionSubTitleButton setAttributedTitle:nsatt forState:UIControlStateNormal];
    cell.followingSuggestionFollowLabel.text = cell.followingSuggestionFollowButton.selected?@"FOLLOWED":@"FOLLOW";
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TAStoreInfo *storeInfoObj = [self.suggestedArray objectAtIndex:indexPath.item];
    totalWidthOfTagView = 0.0;
    
    for (NSString *str in storeInfoObj.storeCategroyArray) {
        totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
    }
    totalWidthOfTagView = totalWidthOfTagView + 10;
    return  (totalWidthOfTagView > 138)?CGSizeMake(totalWidthOfTagView,200):CGSizeMake(138,200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 1;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @"";
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}

#pragma mark Web Service method
-(void)makeApiCallToGetStoreDetails:(NSString *)storeId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"%@/%@",kVendors,storeId] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        storeDetailsObj = [TAStoreInfo parseStoreDetailsData:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpPagerController];
            [self.headerView.suggestionsCollectionView reloadData];
        });
    }];
}

-(void)makeApiCallToGetSuggestFollowDetails{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"%@?suggested",kVendors] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _suggestedArray = [TAStoreInfo parseFollowerSuggestedData:result];
            [self.headerView.suggestionsCollectionView reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductFollowWithId:(NSString *)productId{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kVender_Follows withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView.followButton setBackgroundColor:[UIColor whiteColor]];
            [self.headerView.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.headerView.followButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
            [self.headerView.followButton setTitleEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
            self.headerView.followingSuggestionView.hidden = NO;
            self.headerView.moreInfoView.hidden = YES;
            self.segmentedPager.parallaxHeader.height = 607;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.segmentedPager scrollToTopAnimated:NO];
            });
            [self makeApiCallToGetSuggestFollowDetails];
            [self.segmentedPager reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headerView.followButton setBackgroundColor:[UIColor clearColor]];
            [self.headerView.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.headerView.followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
            [self.headerView.followButton setImage:[UIImage imageNamed:@"follow-plus-white"] forState:UIControlStateNormal];
            [self.headerView.followButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 8, 1, 0)];
            self.headerView.moreInfoView.hidden = YES;
            self.segmentedPager.parallaxHeader.height = 352;
            self.headerView.followingSuggestionView.hidden = YES;
            [self.segmentedPager reloadData];
        });
    }];
}

@end
