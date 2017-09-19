//
//  TAProfileContainerVC.m
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"
#import "TAManualAuthorContainerVC.h"
#import "TAManualAuthorView.h"
#import "TAStoreDetailsVC.h"

@interface TAManualAuthorContainerVC ()<UITextFieldDelegate,FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate>{
    BOOL isPlusSelected;
}

@property(strong, nonatomic) NSMutableArray            * controllersArray;
@property(strong, nonatomic) UIDocumentInteractionController           * document;
@property (strong, nonatomic) TAManualAuthorView       * headerView;

@end

@implementation TAManualAuthorContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPagerController];
    //[self makeApiCallToGetUserDetail];
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
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    
    TAPortFolioVC *favoriteItemVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAPortFolioVC"];
    TAFavoriteProductVC *favoriteItemVC1 = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFavoriteProductVC"];;
    TAWorkWithMeVC *favoriteItemVC2 = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAWorkWithMeVC"];
    TAFavoriteProductVC *favoriteItemVC3 = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFavoriteProductVC"];
    TAFavoriteProductVC *favoriteItemVC4 = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFavoriteProductVC"];
    TAFollowingItemVC *followingItemVC = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFollowingItemVC"];
    TAPurchagedItemVC *purchangedItemVC = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAPurchagedItemVC"];
    
    self.controllersArray = [NSMutableArray arrayWithObjects:favoriteItemVC,favoriteItemVC1,favoriteItemVC2,favoriteItemVC3,favoriteItemVC4, followingItemVC, purchangedItemVC, nil];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    self.headerView = [TAManualAuthorView instantiateFromNib];
    
    [self.headerView.walletButton addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.shareToThrone addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.backBtnAction addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.categoryButton addTarget:self action:@selector(categoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.fbBtn addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.twitterBtn addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
       [self.headerView.instagramBtn addTarget:self action:@selector(shareOnInstagram) forControlEvents:UIControlEventTouchUpInside];
    
    // new added
    [self.headerView.showAndHideDescriptionBtn addTarget:self action:@selector(showAndHideDescriptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.headerView.descriptionTextLabel.attributedText = [NSString customAttributeString:self.headerView.descriptionTextLabel.text withAlignment:NSTextAlignmentCenter withLineSpacing:6 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    
    [self.headerView.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.headerView.profileImageView.layer setBorderWidth:2.0];
    _headerView.serachTextField.delegate = self;
    _headerView.descriptioViewHeightConstraint.constant = 0.0f;
    [_headerView.descriptionView setHidden:YES];
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeBottom;
    self.segmentedPager.parallaxHeader.height = 500;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight = 46;
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
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 3.0;
}

#pragma mark Custom Method
-(void)facebookBtnAction:(UIButton *)sender{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];

    content.contentTitle = @"My Share Title";
    content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
    [content setContentDescription:@"My THRONE APP"];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"returned back to app from facebook post");
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [AlertController message:message onViewController:self];
}

-(void)shareOnTwitter
{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?type=news"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}


-(void)shareOnInstagram {
    
    [self shareImageOnInstagram:[UIImageView imagewithScreenShotOfView:self.view]];
}

- (void)shareImageOnInstagram:(UIImage *)instaImage{
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *imagePath = [NSString stringWithFormat:@"%@/image.igo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        [fileManager removeItemAtPath:imagePath error:nil];
        [UIImagePNGRepresentation(instaImage) writeToFile:imagePath atomically:YES];
        self.document.delegate = self;
        self.document.UTI = @"com.instagram.exclusivegram";
        
        self.document=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
        NSString *caption = @"#Your Text"; //settext as Default Caption
        self.document.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
        [self.document presentOpenInMenuFromRect:self.view.frame inView: self.view animated:YES];
        //[self showErrorAlertWithTitle:@"Instagram share successfully!"];
    }
    else
    {
        UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errMsg show];
    }
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return self.controllersArray.count;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"MY PORTFOLIO",@"FOR SALE",@"WORK WITH ME",@" SOLD ",@"FAVORITES", @"FOLLOWING", @"PURCHASED"][index];
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}

#pragma mark - IBAction Method


- (void)categoryButton:(UIButton *)sender{
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
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
- (void)walletButtonAction:(UIButton *)sender
{
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showAndHideDescriptionButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.headerView.plusBtn.selected = sender.selected;
    if (sender.selected) {
        [self.headerView.descriptionView setHidden:NO];
        self.segmentedPager.parallaxHeader.height = 683;
        _headerView.descriptioViewHeightConstraint.constant = 177.0f;
    }else{
        [self.headerView.descriptionView setHidden:YES];
        self.segmentedPager.parallaxHeader.height = 500;
        _headerView.descriptioViewHeightConstraint.constant = 0.0f;
    }
    [self.segmentedPager scrollToTopAnimated:NO];
}
- (void)sellOnThroneButton:(UIButton *)sender
{
    TABecomeVendarVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TABecomeVendarVC"];
    requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Web Service Method To Get User Detail



#pragma mark - UITextField Delegate Methods

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
@end
