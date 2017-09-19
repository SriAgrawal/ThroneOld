//
//  TAServicesViewController.m
//  Throne
//
//  Created by Anil Kumar on 24/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAServicesViewController.h"
#import "TAFilterServiceVC.h"
#import "Macro.h"
#import "TASettingsVC.h"
#import "TANotificationsVC.h"

@interface TAServicesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,BIZSliderViewDelegate,navigationDelegateForFilterService,navigationDelegateForProductDetails,navigationDelegateForSkipLogin>
{
    CGFloat totalWidthOfTagView;
    BOOL isLoadMoreExecuting ;
    TAPagination *pagination;
}

@property (weak, nonatomic) IBOutlet UICollectionView *headerCollectionView;
@property (weak, nonatomic) IBOutlet UITableView      * homeTableView;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *gridBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

@property (strong, nonatomic) AMPopTip *popTip;

@property (nonatomic) layoutType layoutSet;

@property (strong, nonatomic) NSArray           * productArray;
@property (strong, nonatomic) NSMutableArray    * categoryDataArray;
@property (strong, nonatomic) NSMutableArray    * trendingProductsArray;
@property (strong, nonatomic) NSMutableArray    * featureProductsArray;
@property (strong, nonatomic) NSMutableArray    * followingTapArray;
@property (strong, nonatomic) NSMutableArray    * dataSourceArray;
@property (strong, nonatomic) NSMutableArray    * storeArray;
@end

@implementation TAServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    totalWidthOfTagView = 0.0;
    [self initialSetup];
}

#pragma mark - Class Helper Method

-(void)initialSetup{
    
    self.followingTapArray = [NSMutableArray new];
    self.featureProductsArray = [[NSMutableArray alloc] init];
    self.trendingProductsArray = [[NSMutableArray alloc] init];
    self.storeArray = [[NSMutableArray alloc] init];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    //    [self makeApiCallToGetTheCategoryList];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self makeApiCallToGetTheCategoryList];
}
#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    TASearchVC *searchResultContainerVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TASearchVC"];
    [searchResultContainerVC setIsForProduct:NO];
    [self.navigationController pushViewController:searchResultContainerVC animated:NO];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_layoutSet == List) {
        if (section == 1)
            return self.storeArray.count ? self.storeArray.count : 0;
        else
            return ((section == 0) ? self.featureProductsArray.count : self.trendingProductsArray.count);
    }
    else{
        
        switch (section) {
            case 0:
                return self.featureProductsArray.count ? 1 : 0;
                
            case 1:
                return self.storeArray.count ? 1: 0;
                
            default:
                return self.trendingProductsArray.count ? 1 : 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_layoutSet == List){
        if (indexPath.section == 1)
            return 241.0f;
        else
            return 516.0f;
    }
    else{
        switch (indexPath.section) {
            case 0:
                return (self.featureProductsArray.count%2 + self.featureProductsArray.count/2)*257;
                
            case 1:
                return 241.0f;
                
            default:
                return (self.trendingProductsArray.count%2 + self.trendingProductsArray.count/2)*257;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
    [headerSectionView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *headerSectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, headerSectionView.frame.size.width-20, 45)];
    //Custom section header view
    headerSectionLbl.text = [@[@"THRONE’S SERVICE PICKS",@"HOT SERVICE PROFILES",@"HOT SERVICE PROFILES"] objectAtIndex:section];
    headerSectionLbl.font = [AppUtility sofiaProBoldFontWithSize:14];
    
    [headerSectionView addSubview:headerSectionLbl];
    return headerSectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //LIST------>
    if (_layoutSet == List) {
        if (indexPath.section == 1) {
            TATrendingStoreTableCell *storeCell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingStoreTableCell" forIndexPath:indexPath];
            TAStoreInfo *storeInfo = [self.storeArray objectAtIndex:indexPath.row];
            totalWidthOfTagView = 0.0;
            
            if (storeInfo.storeCategroyArray.count) {
                NSString *strLast = [storeInfo.storeCategroyArray lastObject];
                strLast = [strLast stringByReplacingOccurrencesOfString:@", " withString:@""];
                [storeInfo.storeCategroyArray replaceObjectAtIndex:[storeInfo.storeCategroyArray count]-1 withObject:strLast];
            }
            for (NSString *str in storeInfo.storeCategroyArray) {
                totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
            }
            totalWidthOfTagView = totalWidthOfTagView-5;
            if (totalWidthOfTagView < windowWidth) {
                [storeCell.categoryTagView setTranslatesAutoresizingMaskIntoConstraints:YES];
                [storeCell.categoryTagView setFrame:CGRectMake((windowWidth-totalWidthOfTagView)/2,storeCell.categoryTagView.frame.origin.y ,totalWidthOfTagView, 30)];
            }
            [storeCell.categoryTagView replaceTags:storeInfo.storeCategroyArray];
            [storeCell.categoryTagView setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
            [storeCell.storeRatingView setValue:storeInfo.storeRating];
            
            if (storeInfo.isFollow) {
                [storeCell.followBtn setBackgroundColor:[UIColor whiteColor]];
                [storeCell.followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [storeCell.followBtn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
                [storeCell.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
            }else{
                [storeCell.followBtn setBackgroundColor:[UIColor clearColor]];
                [storeCell.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [storeCell.followBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
                [storeCell.followBtn setImage:[UIImage imageNamed:@"follow-plus-white"] forState:UIControlStateNormal];
                [storeCell.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 8, 1, 0)];
            }
            storeCell.storeNameLbl.text = storeInfo.storeName;
            [storeCell.storeImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:storeInfo.storeHeaderImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
            [storeCell.followBtn addTarget:self action:@selector(followButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            storeCell.storeTitleLbl.text = @"HEAT INDEXTM";
            if ([storeCell.storeTitleLbl.text containsString:@"INDEXTM"]) {
                storeCell.storeTitleLbl.attributedText = [NSString setSuperScriptText:storeCell.storeTitleLbl.text withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
            }
            return storeCell;
        }
        else {
            TAFeatureProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAFeatureProductTableCell" forIndexPath:indexPath];
            
            TAProductInfo *productInfo = [((indexPath.section == 0) ? self.featureProductsArray : self.trendingProductsArray) objectAtIndex:indexPath.row];
            
            cell.productNameLbl.text = productInfo.productName;
            [cell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
            
            [cell.storeAddressLbl setAttributedText:[[NSString stringWithFormat:@"FROM %@", @"MISTER SHOES"] getAttributedString:@"FROM" withColor:[UIColor blackColor] withFont:[AppUtility sofiaProLightFontWithSize:14]]];
            [cell.likeBtn setSelected:productInfo.isLiked];
            
            [cell.priceBtn setTitle:[NSString stringWithFormat:@"$%@0 - BUY", productInfo.productPrice] forState:UIControlStateNormal];
            if ((indexPath.section == 0))
                cell.productImageBottomConstraints.constant = ([self.featureProductsArray count]-1 == indexPath.row ?0.0:10.5);
            else
                cell.productImageBottomConstraints.constant = ([self.trendingProductsArray count]-1 == indexPath.row ?0.0:10.5);
            [cell.likeBtn addTarget:self action:@selector(likeButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.priceBtn addTarget:self action:@selector(buyButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }
    }
    //Grid------>
    else{
        
        if (indexPath.section == 1) {
            TATrendingStoreGridTableCell *storeCell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingStoreGridTableCell" forIndexPath:indexPath];
            storeCell.gridStoreCollectionView.delegate = self;
            storeCell.gridStoreCollectionView.dataSource = self;
            storeCell.gridStoreCollectionView.tag = 3000;
            storeCell.silderView.tag = 5000;
            [self addSliderOnView:storeCell.silderView forPage:0];
            [storeCell.gridStoreCollectionView reloadData];
            [storeCell.storeFollowBtn addTarget:self action:@selector(followButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            return storeCell;
            
        }
        else if(indexPath.section == 0)
        {
            TATrendingProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingProductTableCell" forIndexPath:indexPath];
            cell.productCollectionView.delegate = self;
            cell.productCollectionView.dataSource = self;
            cell.productCollectionView.tag = 2000;
            setHintFor(cell.productCollectionView, indexPath);
            [cell.productCollectionView reloadData];
            return cell;
        }
        else{
            TATrendingProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingProductTableCell" forIndexPath:indexPath];
            cell.productCollectionView.delegate = self;
            cell.productCollectionView.dataSource = self;
            cell.productCollectionView.tag = 6000;
            setHintFor(cell.productCollectionView, indexPath);
            [cell.productCollectionView reloadData];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        UINavigationController *navBar = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAPageStoreContainerViewController *signUpVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
        [navBar pushViewController:signUpVC animated:YES];
    }
    else{
        TAProductInfo *obj = [((indexPath.section == 0) ? self.featureProductsArray : self.trendingProductsArray) objectAtIndex:indexPath.row];
        
        UINavigationController *navBar = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAProductDetailVC *productDetailVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
        productDetailVC.isCommingFromService = YES;
        [productDetailVC setProductId:obj.productId];
        [productDetailVC setProductName:obj.productName];
        [navBar pushViewController:productDetailVC animated:YES];
    }
}

#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view == self.headerCollectionView) {
        return self.categoryDataArray.count;
    }
    else if (view.tag == 2000)
        return self.featureProductsArray.count;
    else if (view.tag == 3000)
        return self.storeArray.count;
    else
        return self.trendingProductsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 2000) {
        TAFeatureCollectionCell  *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFeatureCollectionCell" forIndexPath:indexPath];
        TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.item];
        productCell.productNameLbl.text = obj.productName;
        [productCell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:obj.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
        [productCell.productPriceBtn setTitle:[NSString stringWithFormat:@"$%@0",obj.productPrice] forState:UIControlStateNormal];
        [productCell.productLikeBtn setSelected:obj.isLiked];
        [productCell.productLikeBtn addTarget:self action:@selector(likeGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return productCell;
    }
    else if (collectionView.tag == 6000)
    {
        TAFeatureCollectionCell  *trendingCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFeatureCollectionCell" forIndexPath:indexPath];
        TAProductInfo *obj = [self.trendingProductsArray objectAtIndex:indexPath.row];
        trendingCell.productNameLbl.text = obj.productName;
        [trendingCell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:obj.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
        [trendingCell.productPriceBtn setTitle:[NSString stringWithFormat:@"$%@0",obj.productPrice] forState:UIControlStateNormal];
        [trendingCell.productLikeBtn setSelected:obj.isLiked];
        [trendingCell.productLikeBtn addTarget:self action:@selector(likeGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return trendingCell;
    }
    else if (collectionView.tag == 3000)
    {
        TATrendingStoreCollectionCell  *storeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TATrendingStoreCollectionCell" forIndexPath:indexPath];
        
        TAStoreInfo *storeInfo = [self.storeArray objectAtIndex:indexPath.row];
        if (storeInfo.storeCategroyArray.count) {
            NSString *strLast = [storeInfo.storeCategroyArray lastObject];
            strLast = [strLast stringByReplacingOccurrencesOfString:@", " withString:@""];
            [storeInfo.storeCategroyArray replaceObjectAtIndex:[storeInfo.storeCategroyArray count]-1 withObject:strLast];
        }
        totalWidthOfTagView = 0.0;
        for (NSString *str in storeInfo.storeCategroyArray) {
            totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
        }
        totalWidthOfTagView = totalWidthOfTagView-5;
        if (totalWidthOfTagView < windowWidth) {
            [storeCell.categoryTagView setTranslatesAutoresizingMaskIntoConstraints:YES];
            [storeCell.categoryTagView setFrame:CGRectMake((windowWidth-totalWidthOfTagView)/2,storeCell.categoryTagView.frame.origin.y ,totalWidthOfTagView, 30)];
        }
        [storeCell.categoryTagView replaceTags:storeInfo.storeCategroyArray];
        [storeCell.categoryTagView setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
        [storeCell.storeRatingView setValue:storeInfo.storeRating];
        
        if (storeInfo.isFollow) {
            [storeCell.followBtn setBackgroundColor:[UIColor whiteColor]];
            [storeCell.followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [storeCell.followBtn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
            [storeCell.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
        }else{
            [storeCell.followBtn setBackgroundColor:[UIColor clearColor]];
            [storeCell.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [storeCell.followBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
            [storeCell.followBtn setImage:[UIImage imageNamed:@"follow-plus-white"] forState:UIControlStateNormal];
            [storeCell.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 8, 1, 0)];
        }
        storeCell.storeNameLbl.text = storeInfo.storeName;
        [storeCell.storeImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:storeInfo.storeHeaderImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
        [storeCell.followBtn addTarget:self action:@selector(cellFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        storeCell.storeTitleLbl.text = @"HEAT INDEXTM";
        if ([storeCell.storeTitleLbl.text containsString:@"INDEXTM"]) {
            storeCell.storeTitleLbl.attributedText = [NSString setSuperScriptText:storeCell.storeTitleLbl.text withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
        }
        return storeCell;
    }
    else
    {
        TAHeaderCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAHeaderCollectionCell" forIndexPath:indexPath];
        TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:indexPath.item];

        cell.categoryLbl.text = catInfo.categoryName;
        [cell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:catInfo.categoryImage] placeholderImage:[UIImage imageNamed:@"vintage-square"] options:SDWebImageRefreshCached];

        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 3000){
        return CGSizeMake(windowWidth, 236);
    }
    else if (collectionView.tag == 2000 || collectionView.tag == 6000){
        return CGSizeMake((collectionView.frame.size.width)/2-2,252);
    }
    else
        return CGSizeMake(85,95);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 3000){
        
        TAStoreInfo *storeObj = [self.storeArray objectAtIndex:indexPath.item];
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
        productVC.storeId = storeObj.storeId;
        [objNav pushViewController:productVC animated:YES];
    }
    else if (collectionView.tag == 2000){
        TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.row];
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
        [productVC setProductId:obj.productId];
        [productVC setProductName:obj.productName];
        productVC.isCommingFromService = YES;
        [objNav pushViewController:productVC animated:YES];
    }
    else if (collectionView.tag == 6000){
        TAProductInfo *obj = [self.trendingProductsArray objectAtIndex:indexPath.row];
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
        [productVC setProductId:obj.productId];
        [productVC setProductName:obj.productName];
        [objNav pushViewController:productVC animated:YES];
    }
    else{
        
        TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:indexPath.item];

        [[APPDELEGATE tabBarController] setNavLblString:catInfo.categoryName];
        [[APPDELEGATE tabBarController] setCategoryId:catInfo.categoryId];
        [[APPDELEGATE tabBarController] setIsCategoryList:YES];
        [[APPDELEGATE tabBarController] setIsFromServiceListing:YES];
        [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:301];
    }
}

#pragma mark - Selector method

-(void)cellFollowButtonAction:(UIButton *)sender{
    
    TATrendingStoreCollectionCell * cell = (TATrendingStoreCollectionCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [(UICollectionView *)[self.view viewWithTag:3000] indexPathForCell:cell];
    
    TAStoreInfo *obj = [self.storeArray objectAtIndex:indexPath.row];
    if ( obj.isFollow ) {
        
        [self makeApiCallToGetProductFollowWithId:obj.storeId WithIndexPath:indexPath];
    }
    else{
        [self makeApiCallToGetProductUnFollowWithId:obj.storeId WithIndexPath:indexPath];
    }
}


- (void)followButtonTapped:(UIButton *)button withEvent:(UIEvent*)event {
    NSIndexPath * indexPath = [self.homeTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.homeTableView]];
    TAStoreInfo *obj = [self.storeArray objectAtIndex:indexPath.row];
    if ( obj.isFollow ) {
        
        [self makeApiCallToGetProductFollowWithId:obj.storeId WithIndexPath:indexPath];
    }
    else{
        [self makeApiCallToGetProductUnFollowWithId:obj.storeId WithIndexPath:indexPath];
    }
}

-(void)likeButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.homeTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.homeTableView]];
    TAProductInfo *obj = [(indexPath.section == 0) ? self.featureProductsArray : self.trendingProductsArray objectAtIndex:indexPath.row];
    obj.isLiked = !obj.isLiked;
    if ( obj.isLiked ) {
        
        if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
            [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"like";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
        
        [self makeApiCallToGetProductLikeWithId:obj.productId];
    }
    else
        [self makeApiCallToGetProductUnLikeWithId:obj.productId];
    
    [self.homeTableView reloadData];
}

-(void)buyButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.homeTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.homeTableView]];
    TAProductInfo *obj = [((indexPath.section == 0) ? self.featureProductsArray : self.trendingProductsArray) objectAtIndex:indexPath.row];
    UINavigationController * navBar = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAProductDetailVC *productDetailVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
    productDetailVC.isCommingFromService = YES;
    [productDetailVC setProductId:obj.productId];
    [productDetailVC setProductName:obj.productName];
    [productDetailVC setIsForBuy:YES];
    [navBar pushViewController:productDetailVC animated:NO];
    
    //    if ([[NSUSERDEFAULT objectForKey:pSkip] isEqualToString:@"YES"]) {
    //
    //        [AlertController title:@"" message:@"You're not logged in.Please login First." andButtonsWithTitle:@[@"OK",@"CANCEL"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
    //            if (index == 0) {
    //                TASkipLoginVC *skipLoginVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TASkipLoginVC"];
    //                skipLoginVC.delegateForSkipLogin = self;
    //                skipLoginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //                [[APPDELEGATE tabBarController] presentViewController:skipLoginVC animated:YES completion:nil];
    //            }
    //        }];
    //    }
    //    else{
    // }
    
}
-(void)manageTheNavigation{
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAOrderDetailsVC *productVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAOrderDetailsVC"];
    [objNav pushViewController:productVC animated:YES];
}

-(void)manageTheNavigationForSkip:(UIViewController *)isFromViewController{
    [APPDELEGATE navigateToHomeScreenOnController:self.navigationController withAnimation:YES];
}
-(void)likeGridButtonAction:(UIButton *)button {
    
    TAFeatureCollectionCell * cell = (TAFeatureCollectionCell *)[[button superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[cell superview];
    NSIndexPath * indexPath = [collectionView indexPathForCell:cell];
    TAProductInfo *obj = [((collectionView.tag == 2000) ? self.featureProductsArray : self.trendingProductsArray) objectAtIndex:indexPath.item];
    obj.isLiked = !obj.isLiked;
    if ( obj.isLiked ) {
        if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
            [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"like";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
        
        [self makeApiCallToGetProductLikeWithId:obj.productId];
    }
    else
        [self makeApiCallToGetProductUnLikeWithId:obj.productId];
    
    [self.homeTableView reloadData];
}

- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UICollectionView *collectionView = (UICollectionView*)scrollView;
    
    if (collectionView.tag == 3000){
        CGFloat pageWidth = collectionView.frame.size.width;
        float page = collectionView.contentOffset.x / pageWidth;
        UIView *sliderView = [self.view viewWithTag:5000];
        [self addSliderOnView:sliderView forPage:page];
    }
    else{
        
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 10.0) {
            if ([pagination.current_page integerValue] < [pagination.pages integerValue] && isLoadMoreExecuting) {
                
                [self makeApiCallToGetTrendingProductList];
            }
        }
    }
}

-(void)addSliderOnView:(UIView *)superView forPage:(float)page{
    
    if (superView.subviews.count) {
        
        [UIView animateWithDuration:0.1 animations:^{
            UIView * view = [superView.subviews objectAtIndex:0];
            CGRect rect = view.frame;
            rect.origin.x = page*rect.size.width;
            [view setFrame:rect];
        }completion:^(BOOL finished){ }];
    }
    else{
        [superView addSubview:[self createSliderViewWithIndex:page]];
    }
}

-(UIView *)createSliderViewWithIndex:(float)index{
    
    CGFloat width = (windowWidth-27)/self.storeArray.count;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(index*width, 0, width, 6)];
    [view setBackgroundColor:[UIColor blackColor]];
    return view;
}

#pragma mark - UIButton Action Method
- (IBAction)categoryBtnAction:(id)sender {
    
    UINavigationController *objNav= (UINavigationController *) [APPDELEGATE window].rootViewController;
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

- (IBAction)homeBtnAction:(id)sender {
    
    [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
}

- (IBAction)layoutManageBtnAction:(UIButton *)sender {
    if (sender.tag == 200)
    {
        self.gridBtn.selected = YES;
        if (sender.selected == YES) {
            sender.selected = NO;
        }
        else{
            sender.selected = YES;
        }
        _layoutSet = List;
    }
    else
    {
        self.listBtn.selected = NO;
        if (sender.selected == NO) {
            sender.selected = YES;
        }
        else{
            sender.selected = NO;
        }
        _layoutSet = Grid;
    }
    [self.homeTableView reloadData];
}

- (IBAction)filterButtonAction:(UIButton *)sender {
    TAFilterServiceVC *filterVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAFilterServiceVC"];
    filterVC.isFromHome = YES;
    filterVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    filterVC.delegateForFilter = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)manageTheNavigation:(NSMutableArray*)arrayForFilterObj{
    if (arrayForFilterObj.count > 0)
        [self.filterBtn setImage:[UIImage imageNamed:@"filter-on"] forState:UIControlStateNormal];
    else
        [self.filterBtn setImage:[UIImage imageNamed:@"filter-off"] forState:UIControlStateNormal];
}

#pragma mark - Web Service Methods
-(void)makeApiCallToGetProductList{
    
    [[ServiceHelper helper] request:nil apiName:@"products?featured=1" withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.featureProductsArray removeAllObjects];
            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            [self makeApiCallToGetTrendingProductList];
        });
    }];
}


-(void)makeApiCallToGetTrendingProductList{
    
    isLoadMoreExecuting = NO;
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products?trending=%ld", ([pagination.current_page integerValue] + 1)] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            isLoadMoreExecuting = YES;
            pagination = [TAPagination getPaginationInfoFromDict:result];
            
            if ([pagination.current_page integerValue] == 1) {
                [self.trendingProductsArray removeAllObjects];
            }
            [self.trendingProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            [self makeApiCallToGetTrendingStoreList];
        });
    }];
}


-(void)makeApiCallToGetTrendingStoreList{
    
    [[ServiceHelper helper] request:nil apiName:@"vendors?trending=1" withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.storeArray removeAllObjects];
            self.storeArray = [TAStoreInfo parseStoreListData:result];
            [self.homeTableView reloadData];
        });
    }];
}
-(void)makeApiCallToGetTheCategoryList{
    
    [[ServiceHelper helper] request:nil apiName:kCategories withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.categoryDataArray removeAllObjects];
            
            for (NSDictionary * dict in [result objectForKeyNotNull:kCategories expectedObj:[NSArray array]]) {
                
                if ([[dict objectForKeyNotNull:pName expectedObj:@""] isEqualToString:@"Services"])
                    self.categoryDataArray = [TACategoryInfo parseCategoryListDataWithList:[dict objectForKeyNotNull:pSubcategories expectedObj:[NSArray array]]];
            }
            [self.headerCollectionView reloadData];
            [self makeApiCallToGetProductList];
        });
    }];
}

-(void)makeApiCallToGetProductLikeWithId:(NSString *)productId{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kProduct_Likes withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

-(void)makeApiCallToGetProductUnLikeWithId:(NSString *)productId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products_likes/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

-(void)makeApiCallToGetProductFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexpath{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kVender_Follows withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexpath.row];
            obj.isFollow = !obj.isFollow;
            if (![NSUSERDEFAULT boolForKey:pIsFirstFollow]) {
                [NSUSERDEFAULT setBool:YES forKey:pIsFirstFollow];
                
                UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
                TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
                obj.isFrom = @"follow";
                obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
            }
            if (_layoutSet == List)
                [self.homeTableView reloadData];
            else
                [(UICollectionView *)[self.view viewWithTag:3000] reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexpath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexpath.row];
            obj.isFollow = !obj.isFollow;
            if (_layoutSet == List)
                [self.homeTableView reloadData];
            else
                [(UICollectionView *)[self.view viewWithTag:3000] reloadData];
        });
    }];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
