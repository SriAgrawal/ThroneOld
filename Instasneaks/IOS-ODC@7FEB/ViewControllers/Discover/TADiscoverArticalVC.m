//
//  TADiscoverArticalVC.m
//  Throne
//
//  Created by Aman Goswami on 13/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TADiscoverArticalVC.h"
#import "LCBannerView.h"
#import "Macro.h"
#import "TAExpandableTextCell.h"
#import "TAManualAuthorContainerVC.h"

static NSString * cellIdentifier = @"TAExpandableTextCell";
@interface TADiscoverArticalVC ()<LCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YTPlayerViewDelegate>{
    NSMutableArray *imagesArray;
      LCBannerView *bannerView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBannerImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *manualBackBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImageLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondNameLabel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;

@end

@implementation TADiscoverArticalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    imagesArray = [[NSMutableArray alloc] initWithObjects:@"store-1-big",@"store-1-big",@"store-1-big",@"store-1-big",@"store-1-big",@"store-1-big",@"store-1-big", nil];
    [self.navigationController setNavigationBarHidden:YES];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _addressLabel.attributedText = [NSString customAttributeString:_addressLabel.text withAlignment:NSTextAlignmentLeft withLineSpacing:4 withFont:[AppUtility sofiaProBoldFontWithSize:19]];
    _pageControl.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [APPDELEGATE setShouldAddTimer:YES];
    [self SetUpBannerScroll];
    [bannerView addTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [APPDELEGATE setShouldAddTimer:NO];
    [bannerView removeTimer];
}

#pragma mark - Button Action.
- (IBAction)imageMoveBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 500:{
            //////// move image left
            [bannerView previousImage];
        }
            break;
        case 501: {
            ////// move image right
            [bannerView nextImage];
        }
            break;
        default:
            break;
    }
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
}
#pragma mark - UITableViewDelegate and UITableViewDataSource.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TAExpandableTextCell *cell = (TAExpandableTextCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.descriptionTextLbl.text = @"Lorem ipsum dolor sit amet, quo dicit semper ne, no sed vidit munere volumus. Has ex mollis vulputate. Nemore aperiam forensibus vim ea, aeque nusquam invidunt te eam. Eos partiendo iracundia ad. Cu quidam antiopam ius, sit option scripserit ei. In usu verterem consequat. At illud iisque appellantur mel, mollis urbanitas an vis. Ex mel nemore bonorum denique. Ius eu nulla graeci. Ex integre noluisse conclusionemque per. Omnis rationibus dissentiet cu usu, eu eos illum debet libris. Mea mnesarchum scriptorem ei, in augue efficiendi est. Inermis imperdiet reprehendunt id quo, ut veri mucius vim. Per te brute ceteros, ius ei malorum abhorreant.";
        cell.descriptionTextLbl.attributedText = [NSString customAttributeString:cell.descriptionTextLbl.text withAlignment:NSTextAlignmentLeft withLineSpacing:6 withFont:[AppUtility sofiaProLightFontWithSize:14]];
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        [cell.videoPlayerView loadWithVideoId:@"Y963o_1q71M" playerVars:playerVars];
        return cell;
    }else{
        TATrendingProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingProductTableCell" forIndexPath:indexPath];
        cell.productCollectionView.delegate = self;
        cell.productCollectionView.dataSource = self;
        cell.productCollectionView.tag = 2000;
        [cell.productCollectionView reloadData];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 480;
    }else{
        return 252;
    }
}


#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAFeatureCollectionCell  *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFeatureCollectionCell" forIndexPath:indexPath];
    productCell.soldOutView.hidden = NO;
    productCell.productLikeBtn.selected =  YES;
    productCell.productImageView.image = [UIImage imageNamed:@"product-1-big"];
    [productCell.productPriceBtn setTitle:[NSString stringWithFormat:@"$%@0", @"100"] forState:UIControlStateNormal];
    return productCell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width)/2-2,252);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
    [productVC setProductId:@"2"];
    [productVC setProductName:@"JORDAN 4 RETRO GINGER WHEAT"];
    [objNav pushViewController:productVC animated:YES];

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

#pragma mark - setting Banner Scroll.
-(void)SetUpBannerScroll{
    // autoscroll
    if (imagesArray.count) {
        BOOL doesContain = [_scrollViewBannerImage.subviews containsObject:bannerView];
        if (!doesContain ) {
            [_scrollViewBannerImage addSubview:({
                bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 246.5f)
                                                      delegate:self
                                                     imageURLs:imagesArray
                                              placeholderImage:@"store-2-big"
                                                 timerInterval:3.0f
                                 currentPageIndicatorTintColor:[UIColor blackColor]
                                        pageIndicatorTintColor:[UIColor colorWithRed:181/225.0 green:181/225.0 blue:181/225.0 alpha:1.0]withTimer:YES];
                bannerView;
            })];
        }
        
    }else{
        [_scrollViewBannerImage addSubview:({
            bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210.0f)
                                                  delegate:self
                                                 imageURLs:imagesArray
                                          placeholderImage:@"store-2"
                                             timerInterval:3.0f
                             currentPageIndicatorTintColor:[UIColor clearColor]
                                    pageIndicatorTintColor:[UIColor clearColor]withTimer:YES];
            bannerView;
        })];
    }
}
- (IBAction)authorNameBtnAction:(id)sender {
    TAManualAuthorContainerVC *TAManualContainerVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAManualAuthorContainerVC"];
    [self.navigationController pushViewController:TAManualContainerVC animated:NO];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)walletBtnAction:(id)sender {
    
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareAction:(id)sender {
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

@end
