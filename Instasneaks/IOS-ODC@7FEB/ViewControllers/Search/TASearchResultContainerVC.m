//
//  TASearchResultContainerVC.m
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TASearchResultContainerVC.h"

@interface TASearchResultContainerVC ()<UITextFieldDelegate>

@property(strong, nonatomic) NSMutableArray     * controllersArray;
@property (strong, nonatomic) TASearchHeaderView     * headerView;

@end

@implementation TASearchResultContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPagerController];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager scrollToTopAnimated:NO];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpPagerController
{
    [self searchTextFeild:[[UserInfo sharedManager] searchText] withOption:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchResult:) name:@"RefreshSearchResultForSelectedCategory" object:nil];
}

- (void)searchTextFeild:(NSString*)text withOption:(BOOL)isReload
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    
    TAAllSearchResultsVC *allResultVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TAAllSearchResultsVC"];
    TATrendingSearchResultsVC *trendingResultVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TATrendingSearchResultsVC"];
    TAProductsSearchResultsVC *productsResultVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductsSearchResultsVC"];
    TAStoresSearchResultsVC *storesResultVC = [storyboardForName(searchStoryboardString) instantiateViewControllerWithIdentifier:@"TAStoresSearchResultsVC"];
    
    [allResultVC setCategoryId:self.categoryId];
    [trendingResultVC setCategoryId:self.categoryId];
    [productsResultVC setCategoryId:self.categoryId];
    [storesResultVC setCategoryId:self.categoryId];
    
    [allResultVC setIsFromCategoryDetail:self.isFromCategoryDetail];
    [trendingResultVC setIsFromCategoryDetail:self.isFromCategoryDetail];
    [productsResultVC setIsFromCategoryDetail:self.isFromCategoryDetail];
    [storesResultVC setIsFromCategoryDetail:self.isFromCategoryDetail];

    self.controllersArray = [NSMutableArray arrayWithObjects:allResultVC, trendingResultVC, productsResultVC, storesResultVC, nil];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [TASearchHeaderView instantiateFromNib];
    [self.headerView.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.categoryButton addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.shareButton addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.homeButton addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.serachTextField setDelegate:self];
    [self.headerView.serachTextField setText:text];
    
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 108;
    self.segmentedPager.parallaxHeader.minimumHeight = 24;
    self.segmentedPager.controlHeight = 44;
    self.segmentedPager.bounces = NO;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor blackColor];
    [self.segmentedPager reloadData];
}

-(void)categoryButtonAction:(id)sender{
    
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

-(void)refreshSearchResult:(NSNotification *)object{
    
    [self searchTextFeild:[[UserInfo sharedManager] searchText] withOption:YES];
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 4;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"   ALL   ", @"TRENDING", @"ITEMS", @"PROFILES"][index];
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}

#pragma mark - IBAction Method


- (void)walletButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)cancelButtonAction:(UIButton *)sender
{ 
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)homeButtonAction:(UIButton *)sender{
    
    [[APPDELEGATE tabBarController] setIsCategoryList:NO];
    [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![[[UserInfo sharedManager] searchText] isEqualToString:TRIM_SPACE(textField.text)]) {
        [[UserInfo sharedManager] setSearchText:TRIM_SPACE(textField.text)];
        [self searchTextFeild:[[UserInfo sharedManager] searchText] withOption:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshSearchResultForSelectedCategory" object:nil];
}

@end
