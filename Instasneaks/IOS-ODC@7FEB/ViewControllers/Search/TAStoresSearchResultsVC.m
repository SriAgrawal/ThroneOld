//
//  TAStoresSearchResultsVC.m
//  Throne
//
//  Created by Suresh patel on 04/04/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAStoresSearchResultsVC.h"

static NSInteger sectionButtonTag = 1000;

@interface TAStoresSearchResultsVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        * searchTableView;

@property (nonatomic, strong) NSMutableArray            * sectionsTitleArray;
@property (nonatomic, strong) NSMutableArray            * storeArray;
@property (nonatomic, strong) NSMutableArray            * recentlyViewedStoreArray;

@property (nonatomic, strong) TAPagination              * storePagination;
@property (nonatomic, strong) TAPagination              * resentStorePagination;

@end

@implementation TAStoresSearchResultsVC

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
    self.storeArray = [[NSMutableArray alloc] init];
    self.recentlyViewedStoreArray = [[NSMutableArray alloc] init];
    
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStoreSearchResult:) name:RefreshStoresSearchedResultData object:nil];
}

-(void)refreshStoreSearchResult:(NSNotification *)object{
    [self setSectionTitleWithText:[[UserInfo sharedManager] searchText]];
}


-(void)setSectionTitleWithText:(NSString *)text{
    
    NSString * categoryQuery = @"";
    if (self.isFromCategoryDetail) {
        categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
    }
    self.sectionsTitleArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"RECENTLY VIEWED PROFILES WITH %@", text], [NSString stringWithFormat:@"PROFILES WITH %@", text], nil];
    [self makeApiCallToGetSearchedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@%@", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery]];
    [self makeApiCallToGetRecentlyViewedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@&recently_viewed%@", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery]];
}

#pragma mark- Cell UIButton Action Method

-(void)showMoreBtnAction:(UIButton *)sender{
    
    switch (sender.tag%sectionButtonTag) {
        case 0:
        {
            NSString * categoryQuery = @"";
            if (self.isFromCategoryDetail) {
                categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
            }
            
            [self makeApiCallToGetSearchedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@%@?page=%ld", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery, ([self.storePagination.current_page integerValue]+1)]];

        }
            break;
            
        default:{
            
            NSString * categoryQuery = @"";
            if (self.isFromCategoryDetail) {
                categoryQuery = [NSString stringWithFormat:@"&category=%@", self.categoryId];
            }
            [self makeApiCallToGetRecentlyViewedStoresListWithQuery:[NSString stringWithFormat:@"vendors?product_name=%@&recently_viewed%@?page=%ld", [[[UserInfo sharedManager] searchText] lowercaseString], categoryQuery, ([self.storePagination.current_page integerValue]+1)]];

        }
            break;
    }
}

-(void)followButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.searchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.searchTableView]];
    TAStoreInfo *storeInfo = [(indexPath.section ? self.storeArray : self.recentlyViewedStoreArray) objectAtIndex:indexPath.row];
    
    if (storeInfo.isFollow)
        [self makeApiCallToGetProductUnFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
    else
        [self makeApiCallToGetProductFollowWithId:storeInfo.storeId WithIndexPath:indexPath];
}

#pragma mark - UITableView Delegate and DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (section ? self.storeArray.count : self.recentlyViewedStoreArray.count);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TAViewedStoresCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAViewedStoresCell"];
    if (cell == nil) {
        cell = [[TAViewedStoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TAViewedStoresCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    TAStoreInfo *storeInfo = [(indexPath.section ? self.storeArray : self.recentlyViewedStoreArray) objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [storeInfo.storeName uppercaseString];
    [cell.storeImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:storeInfo.storeHeaderImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    [cell.tagView replaceTags:storeInfo.storeCategroyArray];
    [cell.tagView setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
    
    cell.followButton.selected = storeInfo.isFollow;
    cell.followImageButton.selected = storeInfo.isFollow;
    [cell.followImageButton setBackgroundColor:(storeInfo.isFollow ? [UIColor blackColor] : [UIColor whiteColor])];
    [cell.followButton addTarget:self action:@selector(followButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.followingBtn addTarget:self action:@selector(followButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return 106.0;
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
            return self.resentStorePagination.isMoreDataAvailable ? view : nil;
        }
            break;
            
        default:
            return self.storePagination.isMoreDataAvailable ? view : nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return self.resentStorePagination.isMoreDataAvailable ? 46.0 : 0.0;
        }
            break;
            
        default:
            return self.storePagination.isMoreDataAvailable ? 46.0 : 0.0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSMutableAttributedString *)getAttributedStringForSection:(NSInteger)section{
    
    NSString * serachedText = [[UserInfo sharedManager] searchText];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.sectionsTitleArray objectAtIndex:section]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSRange){((section == 0) ? 30 : 14), [serachedText length]}];
    return attributeString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    TAStoreInfo *storeObj = [(indexPath.section ? self.storeArray : self.recentlyViewedStoreArray) objectAtIndex:indexPath.item];
    TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
    productVC.storeId = storeObj.storeId;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark- Web API Methods

-(void)makeApiCallToGetSearchedStoresListWithQuery:(NSString *)query{
    
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors?product_name=%@", [[[UserInfo sharedManager] searchText] lowercaseString]] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.storePagination = [TAPagination getPaginationInfoFromDict:result];
            self.storePagination.isMoreDataAvailable = ([self.storePagination.current_page integerValue] < [self.storePagination.pages integerValue]);
            if ([self.storePagination.current_page integerValue] == 1) {
                [self.storeArray removeAllObjects];
            }

            [self.storeArray addObjectsFromArray:[TAStoreInfo parseStoreListData:result]];
            [self.searchTableView reloadData];
        });
    }];
}

-(void)makeApiCallToGetRecentlyViewedStoresListWithQuery:(NSString *)query{
    
    [[ServiceHelper helper] request:nil apiName:query withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.resentStorePagination = [TAPagination getPaginationInfoFromDict:result];
            self.resentStorePagination.isMoreDataAvailable = ([self.resentStorePagination.current_page integerValue] < [self.resentStorePagination.pages integerValue]);
            if ([self.resentStorePagination.current_page integerValue] == 1) {
                [self.recentlyViewedStoreArray removeAllObjects];
            }
            [self.recentlyViewedStoreArray addObjectsFromArray:[TAStoreInfo parseStoreListData:result]];
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
            
            TAStoreInfo *obj = [(indexPath.section ? self.storeArray : self.recentlyViewedStoreArray) objectAtIndex:indexPath.row];
            obj.isFollow = !obj.isFollow;
            [self.searchTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAllSearchedResultData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTrendingSearchedResultData object:nil];
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId WithIndexPath:(NSIndexPath*)indexPath{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TAStoreInfo *obj = [(indexPath.section ? self.storeArray : self.recentlyViewedStoreArray) objectAtIndex:indexPath.row];
            obj.isFollow = !obj.isFollow;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshStoresSearchedResultData object:nil];
}

@end
