//
//  TASearchVC.m
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TASearchVC ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    
    BOOL isSearch,isCategorySelected;
    NSInteger selectCategoryTag ;
}
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UICollectionView   * categoryCollectionView;
@property (weak, nonatomic) IBOutlet UITableView        * searchTableView;
@property (weak, nonatomic) IBOutlet UITextField        * searchTextField;

@property (strong, nonatomic) NSMutableArray            * categoryDataArray;
@property (strong, nonatomic) NSMutableArray            * allTagsArray;
@property (nonatomic, strong) NSMutableArray            * cellHeights;
@property (nonatomic, strong) NSMutableArray            * sectionsTitleArray;
@property (nonatomic, strong) NSMutableArray            * productArray;
@property (strong, nonatomic) NSMutableArray            * storeArray;

@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * searchViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIView             * tableFooterView;
@property (weak, nonatomic) IBOutlet IndexPathButton    * shopAllBtn;


@end

@implementation TASearchVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableFooterView.hidden = YES;
    [self setUpDefaults];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.cancelBtn.hidden = YES;
    self.searchViewLeftConstraint.constant = 15;
    self.searchTextField.text = @"";
}
- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    
    isSearch = YES;
    self.searchTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchTableView.estimatedRowHeight = 44.0;
    self.searchTextField.delegate = self;
    self.cellHeights = [NSMutableArray array];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    [self dummyData];
    [self makeApiCallToGetTheCategoryList];
    [self makeApiCallToGetTopViewedStoresList];
    [self makeApiCallToGetTopViewedProductsList];
}

-(void)dummyData{
    
    self.sectionsTitleArray = [NSMutableArray arrayWithObjects:@"TOP SEARCHES", @"TOP VIEWED PROFILES", @"TOP VIEWED ITEMS", nil];
    self.allTagsArray = [[NSMutableArray alloc] init];
    self.productArray = [[NSMutableArray alloc] init];
    self.storeArray = [[NSMutableArray alloc] init];
    
}
#pragma mark- UIButton Action Method

-(IBAction)categoryBtnAction:(id)sender{
    
    isSearch = NO;
    [self.view endEditing:YES];
    UINavigationController *objNav= (UINavigationController *) [APPDELEGATE window].rootViewController;
    TACategoryListVC *categoryVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TACategoryListVC"];
    CATransition *transition = [CATransition animation];
    [categoryVC setIsFromLogin:YES];
    [categoryVC setIsFromProduct:YES];
    transition.duration = 0.25;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [objNav.view.layer addAnimation:transition forKey:kCATransition];
    [objNav pushViewController:categoryVC animated:NO];
}

-(IBAction)shareButtonAction:(id)sender{
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)homeButtonAction:(UIButton *)sender{
    [[APPDELEGATE tabBarController] setIsCategoryList:NO];
    [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
}
#pragma mark- Cell UIButton Action Method

-(void)buyButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    [[TWMessageBarManager sharedInstance] hideAll];
    UINavigationController *navBar = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAPurchaseDetailsVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAPurchaseDetailsVC"];
    //obj.delegateForProductDetails = self;
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [navBar presentViewController:obj animated:YES completion:nil];
}

-(void)likeButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.searchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.searchTableView]];
    TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
    
    if (productInfo.isLiked)
        [self makeApiCallToGetProductUnLikeWithId:productInfo.productId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductLikeWithId:productInfo.productId WithIndexPath:indexPath];
    
}

-(void)followButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.searchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.searchTableView]];
    TAStoreInfo *storeInfo = [self.storeArray objectAtIndex:indexPath.row];
    if (storeInfo.isFollow)
        [self makeApiCallToGetProductUnFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
}

#pragma mark - UITableView Delegate and DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isCategorySelected)
        return 1;
    else
        return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isCategorySelected)
        return self.allTagsArray.count;
    else
    {
        switch (section) {
            case 0:
                return self.allTagsArray.count;
            case 1:
                return self.storeArray.count;
                
            default:
                return self.productArray.count;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            TASearchTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TASearchTagsCell"];
            if (cell == nil) {
                cell = [[TASearchTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TASearchTagsCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.tags = self.allTagsArray[indexPath.row];
            [cell.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
                if (index%2 == 0){
                    [[UserInfo sharedManager] setSearchText:cell.tagListView.tags[index]];
                    TASearchResultContainerVC *searchResultContainerVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TASearchResultContainerVC"];
                    [self.navigationController pushViewController:searchResultContainerVC animated:NO];
                }
            }];
            return cell;
        }
        case 1:
        {
            TAViewedStoresCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAViewedStoresCell"];
            if (cell == nil) {
                cell = [[TAViewedStoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TAViewedStoresCell"];
            }
            
            TAStoreInfo *storeInfo = [self.storeArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = [storeInfo.storeName uppercaseString];
            [cell.storeImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:storeInfo.storeHeaderImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
            
            [cell.tagView replaceTags:storeInfo.storeCategroyArray];
            [cell.tagView setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
            
            [cell.followButton addTarget:self action:@selector(followButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.followingBtn addTarget:self action:@selector(followButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.followButton.selected = storeInfo.isFollow;
            cell.followImageButton.selected = storeInfo.isFollow;
            [cell.followImageButton setBackgroundColor:(storeInfo.isFollow ? [UIColor blackColor] : [UIColor whiteColor])];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        default:
        {
            TATopViewedProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATopViewedProductCell"];
            if (cell == nil) {
                cell = [[TATopViewedProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TATopViewedProductCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.buyButton addTarget:self action:@selector(buyButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton addTarget:self action:@selector(likeButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            cell.titleLabel.attributedText = [NSString customAttributeString:productInfo.productName withAlignment:NSTextAlignmentLeft withLineSpacing:3 withFont:[AppUtility sofiaProBoldFontWithSize:12]];
            [cell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
            [cell.priceLabel setText:[NSString stringWithFormat:@"$%@", productInfo.productPrice]];
            cell.likeButton.selected = productInfo.isLiked;
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
            return [self.cellHeights[indexPath.row] floatValue];
            break;
        case 1:
        {
            return 106.0;
        }
            break;
        default:
        {
            return tableView.rowHeight;
        }
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, windowWidth-30, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    UIButton *crossBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width-20, 0,30, 30)];
    [crossBtn addTarget:self action:@selector(crossButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [crossBtn setImage:[UIImage imageNamed:@"small-x"] forState:UIControlStateNormal];
    UILabel *sepratorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 0.5)];
    sepratorLabel.backgroundColor = [UIColor lightGrayColor];
    for (int category =0 ; category <self.categoryDataArray.count; category++) {
        TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:category];
        if (catInfo.isSelected) {
            label.text = [NSString stringWithFormat:@"SHOP %@ BY",catInfo.categoryName];
            [label setFont:[AppUtility sofiaProBoldFontWithSize:12]];
            [self.shopAllBtn setTitle:[NSString stringWithFormat:@"SHOP ALL %@",catInfo.categoryName] forState:UIControlStateNormal];
            [self.shopAllBtn addTarget:self action:@selector(shopAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (isCategorySelected) {
        self.tableFooterView.hidden = NO;
        crossBtn.hidden = NO;
        sepratorLabel.hidden = YES;
    }
    else
    {
        self.tableFooterView.hidden = YES;
        label.text = [self.sectionsTitleArray objectAtIndex:section];
        [label setFont:[AppUtility sofiaProBoldFontWithSize:12]];
        crossBtn.hidden = YES;
        sepratorLabel.hidden = NO;
    }
    
    [view addSubview:crossBtn];
    [view addSubview:label];
    [view addSubview:sepratorLabel];
    
    return view;
}
- (void)crossButtonAction:(UIButton*) sender
{
    for (int category =0 ; category <self.categoryDataArray.count; category++) {
        TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:category];
        catInfo.isSelected = NO;
    }
    isCategorySelected = NO;
    [self.categoryCollectionView reloadData];
    [self makeApiCallToGetTopSearchList:nil];
}

- (void)shopAllBtnAction:(UIButton*) sender{
    
    NSArray *stringArray = [sender.titleLabel.text componentsSeparatedByString:@" "];
    [[APPDELEGATE tabBarController] setNavLblString:[stringArray lastObject]];
    [[APPDELEGATE tabBarController] setIsCategoryList:YES];
    [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    self.cancelBtn.hidden = YES;
    self.searchViewLeftConstraint.constant = 15;
    switch (indexPath.section) {
        case 1:
        {
            TAStoreInfo *storeObj = [self.storeArray objectAtIndex:indexPath.item];
            TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
            productVC.storeId = storeObj.storeId;
            [self.navigationController pushViewController:productVC animated:YES];
            
        }
            break;
        case 2:
        {
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
            [productVC setProductId:productInfo.productId];
            [productVC setProductName:productInfo.productName];
            [objNav pushViewController:productVC animated:YES];
        }
            break;
        default:
        {
            
        }
    }
}

#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.categoryDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAHeaderCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAHeaderCollectionCell" forIndexPath:indexPath];
    TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:indexPath.item];
    [cell.categoryLbl setText:catInfo.categoryName];
    [cell.selectedCatNameBtn setHidden:!catInfo.isSelected];
    [cell.selectedCatNameBtn setTitle:catInfo.selectedCategoryName forState:UIControlStateNormal];
    [cell.categoryImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:catInfo.categoryImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
    [self.searchTableView reloadData];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    self.cancelBtn.hidden = YES;
    self.searchViewLeftConstraint.constant = 15;
    [self.categoryDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [(TACategoryInfo *)obj setIsSelected:NO];
    }];
    TACategoryInfo * catInfo = [self.categoryDataArray objectAtIndex:indexPath.item];
    [catInfo setIsSelected:YES];
    isCategorySelected = YES;
    [self.categoryCollectionView reloadData];
    
    [self makeApiCallToGetTopSearchList:catInfo.categoryId];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    
    if (!isSearch){
        isSearch = YES;
        return;
    }
    
    if (!textField.text.length)
        return;
    TASearchResultContainerVC *searchResultContainerVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TASearchResultContainerVC"];
    [[UserInfo sharedManager] setSearchText:TRIM_SPACE(self.searchTextField.text)];
    [[UserInfo sharedManager] setIsForProduct:self.isForProduct];
    [searchResultContainerVC setIsFromCategoryDetail:self.isFromCategoryDetail];
    [searchResultContainerVC setCategoryId:self.categoryId];
    
    [self.navigationController pushViewController:searchResultContainerVC animated:NO];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:3.0 animations:^{
        self.cancelBtn.hidden = NO;
        self.searchViewLeftConstraint.constant = 75.0f;
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    self.cancelBtn.hidden = YES;
    self.searchViewLeftConstraint.constant = 15;
}

-(void)refreshTopSearchList{
    
    for (NSArray *tags in self.allTagsArray) {
        [self.cellHeights addObject:@([self.layout calculateContentHeight:tags])];
    }
    [self.searchTableView reloadData];
}
#pragma mark- Web API Methods

-(void)makeApiCallToGetTheCategoryList{
    
    [[ServiceHelper helper] request:nil apiName:kCategories withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.categoryDataArray removeAllObjects];
            
            for (NSDictionary * dict in [result objectForKeyNotNull:kCategories expectedObj:[NSArray array]]) {
                
                if ([[dict objectForKeyNotNull:pName expectedObj:@""] isEqualToString:(self.isForProduct ? @"Products" : @"Services")])
                    self.categoryDataArray = [TACategoryInfo parseCategoryListDataWithList:[dict objectForKeyNotNull:pSubcategories expectedObj:[NSArray array]]];
            }
            
            [self.categoryCollectionView reloadData];
            [self makeApiCallToGetTopSearchList:self.categoryId];
        });
    }];
}

-(void)makeApiCallToGetTopSearchList:(NSString *)categoryId{
    
    NSString * categoryQuery = @"";
    if (categoryId.length) {
        categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
    }

    [[ServiceHelper helper] request:nil apiName:(self.isFromCategoryDetail ? [NSString stringWithFormat:@"search_queries?top%@", categoryQuery] : @"search_queries?top") withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.allTagsArray removeAllObjects];
            NSArray * array = [result objectForKeyNotNull:pSearchQueries expectedObj:[NSArray array]];
            for (NSDictionary *dict in array) {
                NSDictionary * categoryInfo = [dict objectForKey:kCategories];
                NSMutableArray * tagsArray = [NSMutableArray array];

                if ([categoryInfo isKindOfClass:[NSDictionary class]]) {
                    NSArray * categoryArray = [[categoryInfo objectForKeyNotNull:pPermalink expectedObj:@""] componentsSeparatedByString:@" / "];
                    for (NSString * categoryText in categoryArray) {
                        [tagsArray addObject:[categoryText uppercaseString]];
                        [tagsArray addObject:@" /  "];
                    }
                }
                [tagsArray addObject:[dict objectForKeyNotNull:pQuery expectedObj:@""]];
                [self.allTagsArray addObject:tagsArray];
            }
            [self performSelector:@selector(refreshTopSearchList) withObject:nil afterDelay:0.1];
        });
    }];
}

-(void)makeApiCallToGetTopViewedStoresList{
    
    [[ServiceHelper helper] request:nil apiName:(self.isFromCategoryDetail ? [NSString stringWithFormat:@"vendors?top_viewed&category=%@", self.categoryId] : @"vendors?top_viewed") withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.storeArray removeAllObjects];
            [self.storeArray addObjectsFromArray:[TAStoreInfo parseStoreListData:result]];
        });
    }];
}

-(void)makeApiCallToGetTopViewedProductsList{
    
    [[ServiceHelper helper] request:nil apiName:(self.isFromCategoryDetail ? [NSString stringWithFormat:@"products?top_viewed&category=%@", self.categoryId] : @"products?top_viewed") withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productArray removeAllObjects];
            [self.productArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductLikeWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kProduct_Likes withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
                [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
                UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
                TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
                obj.isFrom = @"like";
                obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
            }
            
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            productInfo.isLiked = !productInfo.isLiked;
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductUnLikeWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products_likes/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            productInfo.isLiked = !productInfo.isLiked;
            [self.searchTableView reloadData];
            
        });
    }];
}

-(void)makeApiCallToGetProductFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kVender_Follows withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![NSUSERDEFAULT boolForKey:pIsFirstFollow]) {
                [NSUSERDEFAULT setBool:YES forKey:pIsFirstFollow];
                
                UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
                TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
                obj.isFrom = @"follow";
                obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
            }
            
            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexPath.row];
            obj.isFollow = !obj.isFollow;
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexPath.row];
            obj.isFollow = !obj.isFollow;
            [self.searchTableView reloadData];
        });
    }];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
