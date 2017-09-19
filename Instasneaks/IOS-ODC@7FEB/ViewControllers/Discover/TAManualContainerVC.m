//
//  TAProfileContainerVC.m
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAManualContainerVC.h"
#import "Macro.h"

@interface TAManualContainerVC ()<YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView        * tableView;
@property (strong, nonatomic) NSMutableArray            * dataSourceArray;
@end

@implementation TAManualContainerVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
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
        return cell;
    }
}
-(void)navigateTagTitle:(NSString *)title{
    TAManualTagsVC *TAManualContainerVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAManualTagsVC"];
    TAManualContainerVC.tagTitle = title;
    [self.navigationController pushViewController:TAManualContainerVC animated:NO];
    
}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TATrendingStoriesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TATrendingStoriesCollectionCell" forIndexPath:indexPath];
    cell.storiesTitle.text = [@[@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI",@"5 MINUTE STREET STYLE — ROPPONGI"] objectAtIndex:indexPath.item];
    cell.storiesImage.image = [UIImage imageNamed: [@[@"store-3-big", @"store-3-big", @"store-4-big", @"store-4-big", @"store-4-big", @"store-4-big"] objectAtIndex:indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width), 110);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ScrollView Delegates Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    FXPageControl *pageControll = (FXPageControl*)[self.view viewWithTag:5000];
    pageControll.currentPage = floor((scrollView.contentOffset.x - pageWidth)/ pageWidth) + 1;
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
- (IBAction)categoryBtnAction:(id)sender {
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TACategoryListVC *categoryVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TACategoryListVC"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    [categoryVC setIsFromLogin:YES];
    [categoryVC setIsFromProduct:YES];
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
