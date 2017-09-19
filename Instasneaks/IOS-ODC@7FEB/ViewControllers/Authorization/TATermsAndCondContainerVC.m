//
//  TATermsAndCondContainerVC.m
//  Throne
//
//  Created by Suresh patel on 04/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATermsAndCondContainerVC.h"

@interface TATermsAndCondContainerVC ()

@property(strong, nonatomic) NSMutableArray             * controllersArray;
@property (strong, nonatomic) TATermsAndConditionsView       * headerView;

@end

@implementation TATermsAndCondContainerVC

#pragma mark- Life Cycle of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setUpPagerController];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager scrollToTopAnimated:NO];
    });
}

-(void)setUpPagerController
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    
    TAPrivacyPolicyVC *policyVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TAPrivacyPolicyVC"];
    TATermsAndConditionsVC *termsVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TATermsAndConditionsVC"];

    self.controllersArray = [NSMutableArray arrayWithObjects:termsVC, policyVC, nil];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [TATermsAndConditionsView instantiateFromNib];
    [self.headerView.crossButton addTarget:self action:@selector(crossButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.segmentedPager.parallaxHeader.view = self.headerView;
    
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 64;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight = 44;
    self.segmentedPager.bounces = NO;
    // Segmented Control customization
    [self.segmentedPager.segmentedControl setVerticalDividerEnabled:YES];
    [self.segmentedPager.segmentedControl setVerticalDividerColor:[UIColor lightGrayColor]];
    
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor blackColor];
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2.0f;
    [self.segmentedPager.segmentedControl setSelectedSegmentIndex:self.isForPrivacy animated:NO];
    [self.segmentedPager reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager.pager showPageAtIndex:self.isForPrivacy animated:NO];
    });
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 2;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"TERMS", @"PRIVACY POLICY"][index];
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}

#pragma mark - IBAction Method


- (void)crossButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
