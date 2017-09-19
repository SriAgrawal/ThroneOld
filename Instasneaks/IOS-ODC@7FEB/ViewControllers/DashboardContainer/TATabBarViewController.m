//
//  TATabBarViewController.m
//  Throne
//
//  Created by Shridhar Agarwal on 13/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATabBarViewController.h"
#import "TAServicesViewController.h"
#import "TAManualContainerVC.h"
#import "Macro.h"

@interface TATabBarViewController ()<navigationDelegateForSkipLogin>

@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *discoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) TAHomeViewController *homeViewController;
@property (strong, nonatomic) TAProfileContainerVC *profileVC;
//@property (strong, nonatomic) TASearchVC *searchVC ;
@property (strong, nonatomic) TAServicesViewController *searchVC ;
@property (strong, nonatomic) TADiscoverVC *discoverVC;
@property (strong, nonatomic) TACategoryDetailsVC *categoryDetailVC;

@end

@implementation TATabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self initializeViewControllers];
    [self prepareContainerController:_homeViewController];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialSetUp {
    [self.homeImageView setImage:[UIImage imageNamed:@"products-icon"]];
    [(UILabel *)[self.view viewWithTag:200] setTextColor:[UIColor blackColor]];
    [(UILabel *)[self.view viewWithTag:200]  setFont:[AppUtility sofiaProBoldFontWithSize:9]];
    [self.navController setNavigationBarHidden:YES];
}

-(void)initializeViewControllers {
    
    self.homeViewController = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAHomeViewController"];
    [self.homeViewController setIsfromOnboard:self.isfromOnboard];
    _searchVC  = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAServicesViewController"];
    _discoverVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TADiscoverVC"];
    _profileVC = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAProfileContainerVC"];
}

-(void)setSelectedViewControllerWithIndex:(NSInteger)index{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:index];
    [self commonTabButtonAction:button];
}

#pragma mark - IBAction
- (IBAction)commonTabButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    for (int tag = 300; tag < 304; tag++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:tag - 100];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setFont:[AppUtility sofiaProLightFontWithSize:9]];
    }
    UILabel *tabLabel = (UILabel *)[self.view viewWithTag:sender.tag - 100];
    [tabLabel setTextColor:[UIColor blackColor]];
    [tabLabel setFont:[AppUtility sofiaProBoldFontWithSize:9]];

    [self.homeImageView setImage:[UIImage imageNamed:@"products-icon-off"]];
    [self.searchImageView setImage:[UIImage imageNamed:@"services-icon-off"]];
    [self.discoverImageView setImage:[UIImage imageNamed:@"discover-off"]];
    [self.profileImageView setImage:[UIImage imageNamed:@"profile-off"]];
    
    id controller = nil;
    switch (sender.tag % 300) {
        case 0: {
            // Home
            [self.homeImageView setImage:[UIImage imageNamed:@"products-icon"]];
            
            if (self.isCategoryList) {
                _categoryDetailVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TACategoryDetailsVC"];
                _categoryDetailVC.navLblString = self.navLblString;
                _categoryDetailVC.categoryId = self.categoryId;
                _categoryDetailVC.isFromServiceListing = self.isFromServiceListing;
            }
            controller = (self.isCategoryList == YES) ? self.categoryDetailVC : self.homeViewController;
            
        }
            break;
            
        case 1: {
            // Search
            [self.searchImageView setImage:[UIImage imageNamed:@"services-icon"]];
            if (self.isFromServiceListing) {
                _categoryDetailVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TACategoryDetailsVC"];
                _categoryDetailVC.navLblString = self.navLblString;
                _categoryDetailVC.categoryId = self.categoryId;
                _categoryDetailVC.isFromServiceListing = self.isFromServiceListing;
            }
            controller = (self.isFromServiceListing == YES) ? self.categoryDetailVC : self.searchVC;
        }
            break;
            
        case 2: {
            // Discover
            [self.discoverImageView setImage:[UIImage imageNamed:@"discover-on"]];
             controller = self.discoverVC;
            
        }
            break;
            
        case 3: {
            // Profile
            
            if ([[NSUSERDEFAULT objectForKey:pSkip] isEqualToString:@"YES"]) {
                [self.profileImageView setImage:[UIImage imageNamed:@"profile-on"]];
                [AlertController title:@"" message:@"Slow down fam. This is where the good stuff is, but you've got to log in first!." andButtonsWithTitle:@[@"OK",@"CANCEL"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    if (index == 0) {
                        TASkipLoginVC *skipLoginVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TASkipLoginVC"];
                        skipLoginVC.delegateForSkipLogin = self;
                        skipLoginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        [self presentViewController:skipLoginVC animated:YES completion:nil];
                    }
                }];
            }
            else{
                [self.profileImageView setImage:[UIImage imageNamed:@"profile-on"]];
                controller = self.profileVC;
            }
        }
            break;
            
        default:
            break;
    }
    if (controller) {
        [_navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    }
}

#pragma mark - * * * Class private methods * * *
-(void)prepareContainerController:(id)contrller {
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:contrller];
    [self.navController.navigationBar setHidden:YES];
    [self addChildViewController:self.navController];
    [self.navController.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.navController.view];
    [self.view setNeedsLayout];
    [self.navController didMoveToParentViewController:self];
}

-(void)updateRootViewController:(id)controller {
    
    if (controller) {
        
        [self.navController popToRootViewControllerAnimated:NO];
        [self.navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    }
}
-(void)manageTheNavigationForSkip:(UIViewController *)isFromViewController{
        //[APPDELEGATE navigateToHomeScreenOnController:self.navigationController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self setSelectedViewControllerWithIndex:303];
}
@end
