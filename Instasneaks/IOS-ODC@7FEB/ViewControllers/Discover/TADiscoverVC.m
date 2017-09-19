//
//  TADiscoverVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 04/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TADiscoverVC.h"
#import "Macro.h"
#import "TAManualCategoryCollectionCell.h"

@interface TADiscoverVC ()<YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton   * moreInfoButton;
@property (weak, nonatomic) IBOutlet UIView     * tableHeaderForAll;
@property (weak, nonatomic) IBOutlet UIView     * tableHeaderForCategory;

@property (weak, nonatomic) IBOutlet UILabel    * moreInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel    * moreInfoSeperatorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewConstraints;

@property (weak, nonatomic) IBOutlet UICollectionView *allCategoryCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *subCategoryCollectionView;


@property (strong, nonatomic) NSMutableArray    *dataSourceArray;
@property (assign, nonatomic) BOOL              isForAll;
@property (strong, nonatomic) NSString          * selectedCategory;
@property (strong, nonatomic) NSString          * selectedSubCategory;

@property (strong, nonatomic) NSArray          * categoryArray;
@property (strong, nonatomic) NSArray          * subCategoryArray;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSubcategoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCategoryLbl;


@end

@implementation TADiscoverVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}


#pragma mark - Helper Methods

- (void)initialSetUp {
    self.cancelBtn.hidden = YES;
    self.categoryArray = [NSArray arrayWithObjects:@"the basics", @"the build", @"the flourish", @"the Visuals", nil];
    self.subCategoryArray = [NSArray arrayWithObjects:@"Good Look", @"Deep Dive", @"Next Up", @"Homage", @"The Scoop", @"That’s Word", @"Be Here", nil];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for (int discoverInfo = 0; discoverInfo <=5; discoverInfo++) {
        TADiscoverInfo *discoverInfo = [[TADiscoverInfo alloc] init];
        discoverInfo.discoverImage = @"store-1-big";
        discoverInfo.discoverTitle = @"JERRY LORENZO ON LA, FOOD, AND THE BEACH";
        discoverInfo.dicoverDiscription = @"Lorem ipsum dolor sit amet, quo dicit semper ne, no sed vidit munere volumus. Has ex mollis vulputate. Nemore aperiam forensibus vim ea, aeque nusquam invidunt te eam. Eos partiendo iracundia ad.";
        discoverInfo.discoverTime = @"NOVEMBER 14, 2016";
        discoverInfo.discoverTagArray = @[@"BRAND PROFILE, ",@"BRAND, ",@"THRONE"];
        [self.dataSourceArray addObject:discoverInfo];
    }
    self.descriptionCategoryLbl.attributedText = [NSString customAttributeString:self.descriptionCategoryLbl.text withAlignment:NSTextAlignmentCenter withLineSpacing:4 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    self.moreInfoLabel.attributedText = [NSString customAttributeString:self.moreInfoLabel.text withAlignment:NSTextAlignmentCenter withLineSpacing:5 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    self.descriptionSubcategoryLbl.attributedText = [NSString customAttributeString:self.descriptionSubcategoryLbl.text withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    self.isForAll = YES;
    [self manageHeaderViewWithFlag:self.isForAll];
}

-(void)manageHeaderViewWithFlag:(BOOL)flag{
    
    self.moreInfoButton.selected = NO;
    if (flag) {
        [self.tableView setTableHeaderView:self.tableHeaderForAll];
    }
    else{
        [self.tableView setTableHeaderView:self.tableHeaderForCategory];
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate and Datasource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 2)? 220 : 494;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     TADiscoverInfo *discoverInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    if (indexPath.row == 2) {
        TATrendingStoriesTVC *storiesCell = (TATrendingStoriesTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATrendingStoriesTVC" forIndexPath:indexPath];
        //Set the number of page control and size of dots
        storiesCell.pageControll.tag = 5000;
        [storiesCell.pageControll setNumberOfPages:5];
        [storiesCell.pageControll setCurrentPage:0];
        return storiesCell;
    }
   else if (indexPath.row == 4) {
       TADiscoverListTVC *cell;
       cell = (TADiscoverListTVC *)[tableView dequeueReusableCellWithIdentifier:@"TADiscoverListTVC" forIndexPath:indexPath];
       cell.articleImageView.hidden = YES;
       cell.articleVideoView.hidden = NO;
       cell.shareBtnBottomConstraints.constant = 10.0f;
       cell.categoryBtnBottomConstraints.constant = 30.0f;
       NSDictionary *playerVars = @{
                                    @"playsinline" : @1,
                                    };
       [cell.articleVideoView loadWithVideoId:@"Y963o_1q71M" playerVars:playerVars];
       //recently added
       [cell.readMoreBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       return cell;
    }
    else{
        TADiscoverListTVC *cell;
        cell = (TADiscoverListTVC *)[tableView dequeueReusableCellWithIdentifier:@"TADiscoverListTVC" forIndexPath:indexPath];
        cell.articleImageView.hidden = NO;
        cell.articleVideoView.hidden = YES;
        cell.shareBtnBottomConstraints.constant = 24.0f;
        cell.categoryBtnBottomConstraints.constant = 48.0f;
        cell.articleImageView.image = [UIImage imageNamed:discoverInfo.discoverImage];
        cell.articleTimeLbl.text = discoverInfo.discoverTime;
        cell.articleTitleLbl.attributedText = [NSString customAttributeString:discoverInfo.discoverTitle withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProBoldFontWithSize:19]];
        cell.articleDiscriptionLbl.attributedText = [NSString customAttributeString:discoverInfo.dicoverDiscription withAlignment:NSTextAlignmentLeft withLineSpacing:8 withFont:[AppUtility sofiaProLightFontWithSize:14]];
        [cell.otherArticleTagView replaceTags:discoverInfo.discoverTagArray];
        [cell.otherArticleTagView setTagFont:[AppUtility sofiaProLightFontWithSize:14]];
        [cell.otherArticleTagView setTapBlock:^(NSString *tagText, NSInteger idx)
         {
             [self navigateTagTitle:tagText];
         }];
        [cell.readMoreBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.articleTitleBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
             [cell.articleImageBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.categoryBtn addTarget:self action:@selector(categoryBtnActionTag) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
}

- (void)categoryBtnActionTag{
    
    [self manageHeaderViewWithFlag:NO];
    self.selectedCategory = [self.categoryArray firstObject];
    self.selectedSubCategory = [self.subCategoryArray firstObject];
    [self.allCategoryCollectionView reloadData];
    [self.categoryCollectionView reloadData];
    [self.subCategoryCollectionView reloadData];
}
-(void)navigateTagTitle:(NSString *)title{
   TAManualTagsVC *TAManualContainerVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAManualTagsVC"];
    TAManualContainerVC.tagTitle = title;
    [self.navigationController pushViewController:TAManualContainerVC animated:NO];

}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ((view == self.categoryCollectionView) || (view == self.allCategoryCollectionView))
        return self.categoryArray.count;
    else if (view == self.subCategoryCollectionView)
        return self.subCategoryArray.count;
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((collectionView == self.categoryCollectionView) || (collectionView == self.allCategoryCollectionView)) {
        
        TAManualCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAManualCategoryCollectionCell" forIndexPath:indexPath];
        NSLog(@"Basics-------------%ld",indexPath.item);
        NSString * categoryStr = [self.categoryArray objectAtIndex:indexPath.item];
        [cell.categoryBtn setTitle:[categoryStr uppercaseString] forState:UIControlStateNormal];
        [cell.selectorLbl setHidden:![self.selectedCategory isEqualToString:categoryStr]];

        if ([self.selectedCategory isEqualToString:categoryStr]) {
            [cell.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else{
            [cell.categoryBtn setTitleColor:RGBCOLOR(181.0, 181.0, 181.0, 1.0f) forState:UIControlStateNormal];
        }
        [cell.sepratorLbl setHidden:((self.categoryArray.count-1) == indexPath.item)];
        
        return cell;
    }
    else if (collectionView == self.subCategoryCollectionView) {
        
        TAManualCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAManualCategoryCollectionCell" forIndexPath:indexPath];
        NSLog(@"subcategory-------------%ld",indexPath.item);
        NSString * categoryStr = [self.subCategoryArray objectAtIndex:indexPath.item];
        [cell.categoryBtn setTitle:[categoryStr uppercaseString] forState:UIControlStateNormal];
        [cell.selectorLbl setHidden:![self.selectedSubCategory isEqualToString:categoryStr]];
        
        if ([self.selectedSubCategory isEqualToString:categoryStr]) {
            [cell.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else{
            [cell.categoryBtn setTitleColor:RGBCOLOR(181.0, 181.0, 181.0, 1.0f) forState:UIControlStateNormal];
        }
        
        return cell;
    }

    else{
        TATrendingStoriesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TATrendingStoriesCollectionCell" forIndexPath:indexPath];
        cell.storiesTitle.text = [@[@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI"] objectAtIndex:indexPath.item];
        cell.storiesImage.image = [UIImage imageNamed: [@[@"store-3-big", @"store-3-big", @"store-4-big", @"store-4-big", @"store-4-big", @"store-4-big"] objectAtIndex:indexPath.item]];
        return cell;
    
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((collectionView == self.categoryCollectionView) || (collectionView == self.allCategoryCollectionView)) {
        return CGSizeMake((100), 60);
    }
    else if (collectionView == self.subCategoryCollectionView) {
        return CGSizeMake((80), 50);
    }
    return CGSizeMake((collectionView.frame.size.width), 110);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((collectionView == self.categoryCollectionView) || (collectionView == self.allCategoryCollectionView)) {
        if (self.isForAll) {
            self.isForAll = NO;
            if ([self.moreInfoButton isSelected]) {
                [self moreInfoButtonAction:nil];
            }
            [self manageHeaderViewWithFlag:NO];
        }
        self.selectedCategory = [self.categoryArray objectAtIndex:indexPath.item];
        self.selectedSubCategory = [self.subCategoryArray firstObject];
        [self.allCategoryCollectionView reloadData];
        [self.categoryCollectionView reloadData];
        [self.subCategoryCollectionView reloadData];
    }else if (collectionView == self.subCategoryCollectionView){
        
        self.selectedSubCategory = [self.subCategoryArray objectAtIndex:indexPath.item];
        self.subCategoryTitleLbl.text = [self.selectedSubCategory uppercaseString];
        self.descriptionSubcategoryLbl.attributedText = [NSString customAttributeString:self.descriptionSubcategoryLbl.text withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProLightFontWithSize:12]];
        [self.subCategoryCollectionView reloadData];
    }
}

#pragma mark - TextField Delegates Method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
    TASearchVC *searchResultContainerVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TASearchVC"];
    [self.navigationController pushViewController:searchResultContainerVC animated:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ScrollView Delegates Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    FXPageControl *pageControll = (FXPageControl*)[self.view viewWithTag:5000];
    pageControll.currentPage = floor((scrollView.contentOffset.x - pageWidth)/ pageWidth) + 1;
}

#pragma mark- UIButton Action Method

-(IBAction)moreInfoButtonAction:(id)sender{
    
    self.moreInfoButton.selected = !self.moreInfoButton.selected;
    [self.moreInfoLabel setHidden:![self.moreInfoButton isSelected]];
    [self.moreInfoSeperatorLabel setHidden:![self.moreInfoButton isSelected]];
    
    CGFloat height = 0.0;
    if ([self.moreInfoButton isSelected]) {
        
        height = 260;
    }
    else{
        
        height = 110;
    }
    
    CGRect rect = self.tableHeaderForAll.frame;
    rect.size.height = height;
    self.tableHeaderForAll.frame = rect;
    [self.tableView setTableHeaderView:self.tableHeaderForAll];
}

- (void)shareAction:(id)sender {
    
    NSString *textToShare = @"I thought you'd be interested. Please click on the link before it expires in 48 hours:";
    NSURL *myWebsite = [NSURL URLWithString:@"https://throne1.app.link/profile?manualId=1=page=manual"];
    
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

- (IBAction)backButtonAction:(id)sender {
    
    self.isForAll = YES;
    [self manageHeaderViewWithFlag:self.isForAll];
    self.selectedCategory = @"";
    self.selectedSubCategory = @"";
    [self.allCategoryCollectionView reloadData];
    [self.categoryCollectionView reloadData];
    [self.subCategoryCollectionView reloadData];
}

- (IBAction)categoryBtnAction:(id)sender {
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TACategoryListVC *categoryVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TACategoryListVC"];
    [categoryVC setIsFromLogin:YES];
    [categoryVC setIsFromProduct:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [objNav.view.layer addAnimation:transition forKey:kCATransition];
    [objNav pushViewController:categoryVC animated:NO];
}

- (IBAction)wallteBtnAction:(id)sender {
    
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- Helper Method
-(void)readMoreBtnAction:(UIButton *)sender{
    
    TADiscoverArticalVC *TAManualContainerVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TADiscoverArticalVC"];
    [self.navigationController pushViewController:TAManualContainerVC animated:NO];
}

@end
