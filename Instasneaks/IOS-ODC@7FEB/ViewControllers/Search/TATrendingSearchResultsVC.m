//
//  TATrendingSearchResultsVC.m
//  Throne
//
//  Created by Suresh patel on 04/04/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATrendingSearchResultsVC.h"

static NSInteger sectionButtonTag = 1000;

@interface TATrendingSearchResultsVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        * searchTableView;

@property (nonatomic, strong) NSMutableArray            * allTagsArray;
@property (nonatomic, strong) NSMutableArray            * cellHeights;
@property (nonatomic, strong) NSMutableArray            * sectionsTitleArray;

@property (nonatomic, strong) NSMutableArray            * productArray;
@property (nonatomic, strong) NSMutableArray            * storeArray;

@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;
@property (nonatomic, strong) TAPagination              * searchesPagination;
@property (nonatomic, strong) TAPagination              * productPagination;
@property (nonatomic, strong) TAPagination              * storesPagination;

@end

@implementation TATrendingSearchResultsVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpDefaults];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    
    self.searchTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchTableView.estimatedRowHeight = 44.0;
    self.cellHeights = [NSMutableArray array];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.storeArray = [[NSMutableArray alloc] init];
    self.productArray = [[NSMutableArray alloc] init];
    self.allTagsArray = [NSMutableArray array];
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTrendingSearchResult:) name:RefreshTrendingSearchedResultData object:nil];
}

-(void)refreshTrendingSearchResult:(NSNotification *)object{
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
}

-(void)setSectionTitleWithText:(NSString *)text{
    
    NSString * categoryQuery = @"";
    if (self.isFromCategoryDetail) {
        categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
    }
    self.sectionsTitleArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"TRENDING %@ SEARCHES", text], [NSString stringWithFormat:@"TRENDING %@ ITEMS", text], [NSString stringWithFormat:@"TRENDING PROFILES WITH %@", text], nil];
    [self makeApiCallToGetSearchedListWithQuery:[NSString stringWithFormat:@"search_queries?query=%@&trending%@", [[UserInfo sharedManager] searchText], categoryQuery]];
    [self makeApiCallToGetSearchedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@&trending%@", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery]];
    [self makeApiCallToGetSearchedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@&trending%@", [[UserInfo sharedManager] searchText], categoryQuery]];
}

#pragma mark- Cell UIButton Action Method

-(void)showMoreBtnAction:(UIButton*)sender{
    
    NSString * categoryQuery = @"";
    if (self.isFromCategoryDetail) {
        categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
    }

    switch (sender.tag%sectionButtonTag) {
        case 0:
        {
            [self makeApiCallToGetSearchedListWithQuery:[NSString stringWithFormat:@"search_queries?query=%@&trending%@?page=%ld", [[UserInfo sharedManager] searchText], categoryQuery, ([self.searchesPagination.current_page integerValue] + 1)]];
        }
            break;
            
        case 1:
        {
            [self makeApiCallToGetSearchedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@&trending%@?page=%ld", [[UserInfo sharedManager] searchText], categoryQuery, ([self.productPagination.current_page integerValue] + 1)]];
        }
            break;

        default:{
            
            [self makeApiCallToGetSearchedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@&trending%@?page=%ld", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery, ([self.storesPagination.current_page integerValue] + 1)]];
        }
            break;
    }
}

-(void)buyButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.searchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.searchTableView]];
    NSLog(@"______%@______", indexPath);
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
    TAProductInfo *productInfo;
    productInfo = [self.productArray objectAtIndex:indexPath.row];
    if (productInfo.isLiked)
        [self makeApiCallToGetProductUnLikeWithId:productInfo.productId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductLikeWithId:productInfo.productId WithIndexPath:indexPath];
}

-(void)followButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.searchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.searchTableView]];
    TAStoreInfo *storeInfo;
    
    storeInfo = [self.storeArray objectAtIndex:indexPath.row];
    if (storeInfo.isFollow)
        [self makeApiCallToGetProductUnFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
}

#pragma mark - UITableView Delegate and DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.allTagsArray.count;
        case 1:
            return self.productArray.count;
        default:
            return self.storeArray.count;
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
                if ((index%2 == 0) && ![[[UserInfo sharedManager] searchText] isEqualToString:cell.tagListView.tags[index]]){
                    [[UserInfo sharedManager] setSearchText:cell.tagListView.tags[index]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSearchResultForSelectedCategory" object:nil];
                }
            }];
            
            return cell;
        }
        case 1:
        {
            TATopViewedProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATopViewedProductCell"];
            if (cell == nil) {
                cell = [[TATopViewedProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TATopViewedProductCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            
            [cell.buyButton addTarget:self action:@selector(buyButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton addTarget:self action:@selector(likeButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.titleLabel.attributedText = [NSString customAttributeString:productInfo.productName withAlignment:NSTextAlignmentLeft withLineSpacing:3 withFont:[AppUtility sofiaProBoldFontWithSize:12]];
            [cell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
            [cell.priceLabel setText:[NSString stringWithFormat:@"$%@", productInfo.productPrice]];
            cell.likeButton.selected = productInfo.isLiked;
            
            return cell;
        }
        default:
        {
            
            TAViewedStoresCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAViewedStoresCell"];
            if (cell == nil) {
                cell = [[TAViewedStoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TAViewedStoresCell"];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
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
            return tableView.rowHeight;
        }
            break;
            
        default:
        {
            return 106.0;
        }
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 30)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, windowWidth-30, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    
    label.attributedText = [self getAttributedStringForSection:section];
    [label setFont:[AppUtility sofiaProBoldFontWithSize:11]];
    
    UILabel *sepratorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 0.5)];
    sepratorLabel.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:label];
    [view addSubview:sepratorLabel];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 46)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    UIButton *showMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showMoreBtn setFrame:CGRectMake(24, 0, windowWidth-30, 30)];
    showMoreBtn.backgroundColor = [UIColor clearColor];
    [showMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"SHOW MORE +"];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, [@"SHOW MORE +" length])];
    [showMoreBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    [showMoreBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [showMoreBtn.titleLabel setFont:[AppUtility sofiaProLightFontWithSize:12]];
    [showMoreBtn addTarget:self action:@selector(showMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [showMoreBtn setTag:sectionButtonTag+section];

    [view addSubview:showMoreBtn];
    
    switch (section) {
        case 0:
        {
            return ([self.searchesPagination.current_page integerValue] < [self.searchesPagination.pages integerValue]) ? view : nil;
        }
            break;
        case 1:
        {
            return ([self.productPagination.current_page integerValue] < [self.productPagination.pages integerValue]) ? view : nil;
        }
            break;

        default:
            return ([self.storesPagination.current_page integerValue] < [self.storesPagination.pages integerValue]) ? view : nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return ([self.searchesPagination.current_page integerValue] < [self.searchesPagination.pages integerValue]) ? 46.0 : 0.0;
        }
            break;
            
        case 1:
        {
            return ([self.productPagination.current_page integerValue] < [self.productPagination.pages integerValue]) ? 46.0 : 0.0;
        }
            break;

        default:
            return ([self.storesPagination.current_page integerValue] < [self.storesPagination.pages integerValue]) ? 46.0 : 0.0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSMutableAttributedString *)getAttributedStringForSection:(NSInteger)section{
    
    NSString * serachedText = [[UserInfo sharedManager] searchText];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.sectionsTitleArray objectAtIndex:section]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSRange){((section == 2) ? 23 : 9), [serachedText length]}];
    
    return attributeString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    switch (indexPath.section) {
        case 0:
        {
        }
            break;
        case 1:
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
            TAStoreInfo *storeObj = [self.storeArray objectAtIndex:indexPath.item];
            TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
            productVC.storeId = storeObj.storeId;
            [self.navigationController pushViewController:productVC animated:YES];
            
            break;
        }
    }
}

#pragma mark- Web API Methods

-(void)makeApiCallToGetSearchedListWithQuery:(NSString *)query{
    
    [[ServiceHelper helper] request:nil apiName:query withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.searchesPagination = [TAPagination getPaginationInfoFromDict:result];
            self.searchesPagination.isMoreDataAvailable = ([self.searchesPagination.current_page integerValue] < [self.searchesPagination.pages integerValue]);
            if ([self.searchesPagination.current_page integerValue] == 1) {
                [self.allTagsArray removeAllObjects];
            }
            
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
            for (NSArray *tags in self.allTagsArray) {
                [self.cellHeights addObject:@([self.layout calculateContentHeight:tags])];
            }
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetSearchedProductsListWithQuery:(NSString *)query{
    
    [[ServiceHelper helper] request:nil apiName:query withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.productPagination = [TAPagination getPaginationInfoFromDict:result];
            self.productPagination.isMoreDataAvailable = ([self.productPagination.current_page integerValue] < [self.productPagination.pages integerValue]);

            if ([self.productPagination.current_page integerValue] == 1) {
                [self.productArray removeAllObjects];
            }

            [self.productArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetSearchedStoresListWithQuery:(NSString *)query{
    
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors?product_name=%@", [[[UserInfo sharedManager] searchText] lowercaseString]] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.storesPagination = [TAPagination getPaginationInfoFromDict:result];
            self.storesPagination.isMoreDataAvailable = ([self.storesPagination.current_page integerValue] < [self.storesPagination.pages integerValue]);
            if ([self.storesPagination.current_page integerValue] == 1) {
                [self.storeArray removeAllObjects];
            }

            [self.storeArray addObjectsFromArray:[TAStoreInfo parseStoreListData:result]];
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
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshProductSearchedResultData object:nil];
        });
    }];
}

-(void)makeApiCallToGetProductUnLikeWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products_likes/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAProductInfo *productInfo = [self.productArray objectAtIndex:indexPath.row];
            productInfo.isLiked = !productInfo.isLiked;
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshProductSearchedResultData object:nil];
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
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshStoresSearchedResultData object:nil];
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexPath.row];
            obj.isFollow = !obj.isFollow;
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshStoresSearchedResultData object:nil];
        });
    }];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshTrendingSearchedResultData object:nil];
}

@end
