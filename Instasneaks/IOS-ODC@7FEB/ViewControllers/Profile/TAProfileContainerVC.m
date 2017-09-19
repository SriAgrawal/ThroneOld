//
//  TAProfileContainerVC.m
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"
#import "TASettingsVC.h"

@interface TAProfileContainerVC ()<navigationDelegateForSetting,FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate>

@property(strong, nonatomic) NSMutableArray             * controllersArray;
@property (strong, nonatomic) UIDocumentInteractionController *document;
@property (strong, nonatomic) TAProfileHeaderView       * headerView;
@property (nonatomic, strong) NSString                  * firstName;
@property (nonatomic, strong) NSString                  * lastName;

@end

@implementation TAProfileContainerVC

#pragma mark- Life cycle of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPagerController];
    [self makeApiCallToGetUserDetail];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager scrollToTopAnimated:NO];
    });
}

#pragma mark- Setup the Pager Controller

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
            favoriteItemVC3.isSoldItem = YES;
    TAFavoriteProductVC *favoriteItemVC4 = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFavoriteProductVC"];
    TAFollowingItemVC *followingItemVC = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAFollowingItemVC"];
    TAPurchagedItemVC *purchangedItemVC = [storyboardForName(profileStoryboardString) instantiateViewControllerWithIdentifier:@"TAPurchagedItemVC"];
    
    self.controllersArray = [NSMutableArray arrayWithObjects:favoriteItemVC,favoriteItemVC1,favoriteItemVC2,favoriteItemVC3,favoriteItemVC4, followingItemVC, purchangedItemVC, nil];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [TAProfileHeaderView instantiateFromNib];
    [self.headerView.sepratorLabel setHidden:YES];
    [self.headerView.settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.walletButton addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.expandButton addTarget:self action:@selector(showAndHideDescriptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.shareToThrone addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.facebookBtn addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.headerView.twitterBtn addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
         [self.headerView.instagramBtn addTarget:self action:@selector(shareOnInstagram) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.homeBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];

    _headerView.descriptioViewHeightConstraint.constant = 0.0f;
    [_headerView.descriptionView setHidden:YES];
    self.headerView.descriptionTextLabel.attributedText = [NSString customAttributeString:self.headerView.descriptionTextLabel.text withAlignment:NSTextAlignmentCenter withLineSpacing:6 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    [self.headerView.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.headerView.profileImageView.layer setBorderWidth:2.0];
    
    self.segmentedPager.parallaxHeader.view = self.headerView;
    
        self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 380;
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
    [self.segmentedPager reloadData];
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 7;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"MY PORTFOLIO", @"FOR SALE", @"WORK WITH ME", @" SOLD ", @"FAVORITES", @"FOLLOWING", @"PURCHASED"][index];
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}
#pragma mark - IBAction Method

-(void)facebookBtnAction:(UIButton *)sender{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentTitle = @"My THRONE APP";
    [content setContentDescription:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER"];
    content.contentURL = [NSURL URLWithString:@"https://throne1.app.link/profile"];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
}
- (IBAction)homeBtnAction {
    [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
}

- (void)settingButtonAction:(UIButton *)sender{
    if (![[NSUSERDEFAULT objectForKey:pSkip] isEqualToString:@"YES"]) {
        TASettingsVC *settingVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TASettingsVC"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingVC];
        nav.navigationBar.hidden = YES;
        settingVC.delegateForSetting = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)walletButtonAction:(UIButton *)sender
{
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)sellOnThroneButton:(UIButton *)sender{
    TABecomeVendarVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TABecomeVendarVC"];
    requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)showAndHideDescriptionButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.headerView.showAndHideDescriptionBtn.selected = sender.selected;
    if (sender.selected) {
        [self.headerView.descriptionView setHidden:NO];
        [self.headerView.sepratorLabel setHidden:NO];
        self.segmentedPager.parallaxHeader.height = 560;
        _headerView.descriptioViewHeightConstraint.constant = 175.0f;
    }else{
        [self.headerView.descriptionView setHidden:YES];
        [self.headerView.sepratorLabel setHidden:YES];
        self.segmentedPager.parallaxHeader.height = 380;
        _headerView.descriptioViewHeightConstraint.constant = 0.0f;
    }
    [self.segmentedPager scrollToTopAnimated:NO];
}
-(void)manageTheNavigation{
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    [objNav popToRootViewControllerAnimated:NO];
}

#pragma mark - CustomMethod

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"returned back to app from facebook post");
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [AlertController message:message onViewController:self];
}

-(void)shareOnTwitter{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne1.app.link/profile"]];
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
    }
    else
    {
        UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errMsg show];
    }
}

#pragma mark - Web Service Method To Get User Detail

-(void)makeApiCallToGetUserDetail{
    
    NSString * urlString = [NSString stringWithFormat:@"users/%@.json?token=%@", [NSUSERDEFAULT valueForKey:pUserId], [NSUSERDEFAULT valueForKey:pSpreeApiKey]];
    
    [[ServiceHelper helper] request:nil apiName:urlString withToken:NO method:GET onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headerView.memberLabel setText:[NSString stringWithFormat:@"MEMBER SINCE %@", [[AppUtility getDateFromString:[resultDict objectForKeyNotNull:pCreatedAt expectedObj:@""]] uppercaseString]]];
            
            if ([[resultDict objectForKeyNotNull:pFirstName expectedObj:@""] length] && [[resultDict objectForKeyNotNull:pLastName expectedObj:@""] length]) {
                
                self.firstName = [resultDict objectForKeyNotNull:pFirstName expectedObj:@""];
                self.lastName = [resultDict objectForKeyNotNull:pLastName expectedObj:@""];
                [self.headerView.nameLabel setText:[[NSString stringWithFormat:@"%@ %@", [resultDict objectForKeyNotNull:pFirstName expectedObj:@""], [resultDict objectForKeyNotNull:pLastName expectedObj:@""]] uppercaseString]];
                [self.headerView.imageLabel setText:[[NSString stringWithFormat:@"%@%@", [[resultDict objectForKeyNotNull:pFirstName expectedObj:@""] substringToIndex:1], [[resultDict objectForKeyNotNull:pLastName expectedObj:@""] substringToIndex:1]] uppercaseString]];
                
                UserInfo * userInfo = [UserInfo sharedManager];
                [userInfo setFirstNameString:self.firstName];
                [userInfo setLastNameString:self.lastName];
            }
            else{
                [self.headerView.nameLabel setText:@"THRONE MEMBER"];
                [self.headerView.imageLabel setText:@"TM"];
            }
        });
    }];
}

#pragma mark- Memory Management Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
