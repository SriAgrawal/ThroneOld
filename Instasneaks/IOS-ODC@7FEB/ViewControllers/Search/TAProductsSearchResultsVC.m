//
//  TAProductsSearchResultsVC.m
//  Throne
//
//  Created by Suresh patel on 04/04/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAProductsSearchResultsVC.h"

static NSInteger sectionButtonTag = 1000;

@interface TAProductsSearchResultsVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        * searchTableView;

@property (nonatomic, strong) NSMutableArray            * sectionsTitleArray;
@property (nonatomic, strong) NSMutableArray            * productArray;
@property (nonatomic, strong) NSMutableArray            * recentlyViewedProductArray;

@property (nonatomic, strong) TAPagination              * productPagination;
@property (nonatomic, strong) TAPagination              * resentProductPagination;

@end

@implementation TAProductsSearchResultsVC

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
    self.productArray = [[NSMutableArray alloc] init];
    self.recentlyViewedProductArray = [[NSMutableArray alloc] init];
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProductSearchResult:) name:RefreshProductSearchedResultData object:nil];
}

-(void)refreshProductSearchResult:(NSNotification *)object{
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
}

-(void)setSectionTitleWithText:(NSString *)text{
    
    NSString * categoryQuery = @"";
    if (self.isFromCategoryDetail) {
        categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
    }
    self.sectionsTitleArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"RECENTLY VIEWED %@ ITEMS", text], [NSString stringWithFormat:@"%@ ITEMS", text], nil];
    [self makeApiCallToGetSearchedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@%@", [[UserInfo sharedManager] searchText], categoryQuery]];
    [self makeApiCallToGetRecentlyViewedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@&recently_viewed%@", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery]];
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
            
            [self makeApiCallToGetSearchedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@%@?page=%ld", [[UserInfo sharedManager] searchText], categoryQuery, ([self.productPagination.current_page integerValue] + 1)]];
        }
            break;
            
        default:{
            
            [self makeApiCallToGetRecentlyViewedProductsListWithQuery:[NSString stringWithFormat:@"products?query=%@&recently_viewed%@?page=%ld", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery, ([self.resentProductPagination.current_page integerValue] + 1)]];
            
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
    TAProductInfo *productInfo = [(indexPath.section ? self.productArray : self.recentlyViewedProductArray) objectAtIndex:indexPath.row];
    if (productInfo.isLiked)
        [self makeApiCallToGetProductUnLikeWithId:productInfo.productId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductLikeWithId:productInfo.productId WithIndexPath:indexPath];
}

#pragma mark - UITableView Delegate and DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (section ? self.productArray.count : self.recentlyViewedProductArray.count);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TATopViewedProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATopViewedProductCell"];
    if (cell == nil) {
        cell = [[TATopViewedProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TATopViewedProductCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    TAProductInfo *productInfo = [(indexPath.section ? self.productArray : self.recentlyViewedProductArray) objectAtIndex:indexPath.row];
    
    [cell.buyButton addTarget:self action:@selector(buyButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeButton addTarget:self action:@selector(likeButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.titleLabel.attributedText = [NSString customAttributeString:productInfo.productName withAlignment:NSTextAlignmentLeft withLineSpacing:3 withFont:[AppUtility sofiaProBoldFontWithSize:12]];
    [cell.productImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%@", productInfo.productPrice]];
    cell.likeButton.selected = productInfo.isLiked;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return tableView.rowHeight;
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
            return self.resentProductPagination.isMoreDataAvailable ? view : nil;
        }
            break;
            
        default:
            return self.productPagination.isMoreDataAvailable ? view : nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return self.resentProductPagination.isMoreDataAvailable ? 46.0 : 0.0;
        }
            break;
            
        default:
            return self.productPagination.isMoreDataAvailable ? 46.0 : 0.0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSMutableAttributedString *)getAttributedStringForSection:(NSInteger)section{
    
    NSString * serachedText = [[UserInfo sharedManager] searchText];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.sectionsTitleArray objectAtIndex:section]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSRange){((section == 0) ? 16 : 0), [serachedText length]}];
    return attributeString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    TAProductInfo *productInfo = [(indexPath.section ? self.productArray : self.recentlyViewedProductArray) objectAtIndex:indexPath.row];
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
    [productVC setProductId:productInfo.productId];
    [productVC setProductName:productInfo.productName];
    [objNav pushViewController:productVC animated:YES];

}

#pragma mark- Web API Methods

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

-(void)makeApiCallToGetRecentlyViewedProductsListWithQuery:(NSString *)query{
    
    [[ServiceHelper helper] request:nil apiName:query withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.resentProductPagination = [TAPagination getPaginationInfoFromDict:result];
            self.resentProductPagination.isMoreDataAvailable = ([self.resentProductPagination.current_page integerValue] < [self.resentProductPagination.pages integerValue]);

            if ([self.resentProductPagination.current_page integerValue] == 1) {
                [self.recentlyViewedProductArray removeAllObjects];
            }

            [self.recentlyViewedProductArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            
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
            
            TAProductInfo *productInfo = [(indexPath.section ? self.productArray : self.recentlyViewedProductArray) objectAtIndex:indexPath.row];
            productInfo.isLiked = !productInfo.isLiked;
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTrendingSearchedResultData object:nil];
        });
    }];
}

-(void)makeApiCallToGetProductUnLikeWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products_likes/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAProductInfo *productInfo = [(indexPath.section ? self.productArray : self.recentlyViewedProductArray) objectAtIndex:indexPath.row];
            productInfo.isLiked = !productInfo.isLiked;
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTrendingSearchedResultData object:nil];
        });
    }];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshProductSearchedResultData object:nil];
}

@end
