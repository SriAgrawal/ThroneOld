//
//  TAOnBoardVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 16/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TAOnBoardVC.h"
#import "FXPageControl.h"

@interface TAOnBoardVC ()<navigationDelegateForLogin,navigationDelegateForSignUp>
@property (weak, nonatomic) IBOutlet UICollectionView *onBoardCollectionView;
@property (weak, nonatomic) IBOutlet FXPageControl *onBoardPageControl;
@property (weak, nonatomic) IBOutlet IndexPathButton *skipButton;
@property (strong, nonatomic)  NSArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UILabel *onBoardUpperTitleLbl;

@end

@implementation TAOnBoardVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.onBoardUpperTitleLbl.hidden = YES;
    [self setUpIntialView];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    [ZDKRMA showAlwaysInView:self.view];

    [ZDKRMA configure:^(ZDKAccount *account, ZDKRMAConfigObject *config) {
        config.dialogActions = @[@(ZDKRMARateApp),@(ZDKRMASendFeedback),@(ZDKRMADontAskAgain)];
    }];
    
    [ZDKRMA showInView:self.view];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpIntialView{
    // Set Visited status
    [NSUSERDEFAULT setObject:@YES forKey:kIsTutorialVisited];
    
    //Set contnet for the tutorial platform
    self.dataSourceArray = @[
                             @{pTitle : @"BUY THE RAREST GEAR OR APPLY TO\nBUILD YOUR STORE AND SELL YOUR\nOWN HEAT. WE'VE BUILT THE ULTIMATE\nPLATFORM JUST FOR YOU.", pTutorialImage: @"throne-logo-onboard"},
                             
                             @{pTitle : @"WE'VE SPECIALLY CURATED\nA COMMUNITY OF THE BEST\nBRANDS, CREATORS, AND SELLERS\nIN THE STREETWEAR WORLD.", pTutorialImage: @"only-the-best-icon"},
                             
                             @{pTitle : @"OUR HEAT INDEXTM ALGORITHM\nSURFACES THE HOTTEST CREATORS,\nBRANDS, PROFILES, SERVICES, AND\nPRODUCTS ON THE PLATFORM AT ANY\nGIVEN MOMENT.", pTutorialImage: @"heat-index-icon"},
                             
                             @{pTitle : @"PURCHASE THE PRODUCTS & SERVICES YOU\nWANT WITH THE TAP OF A BUTTON.", pTutorialImage: @"buy-icon"},
                            @{pTitle : @"AS A CREATOR OR SELLER\nYOU CAN APPLY TO SELL\nAND USE OUR TOOLS AND\n DATA TO BUILD YOUR BRAND.", pTutorialImage: @"build-icon"},
                             ];
    
    //Set the number of page control and size of dots
    [self.onBoardPageControl setNumberOfPages:_dataSourceArray.count];
    [self.onBoardPageControl setCurrentPage:0];
    
    if ([NSUSERDEFAULT valueForKey:pSpreeApiKey]) {
        [APPDELEGATE navigateToHomeScreenOnController:self.navigationController withAnimation:NO];
    }
}

#pragma mark- Handling the UIButton Action Method

- (IBAction)joinBtnAction:(id)sender {
    
    TASignUpVC *signUpVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TASignUpVC"];
    signUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [signUpVC setIsFromOnboard:YES];
    signUpVC.delegateForSignUp = self;
    [self presentViewController:signUpVC animated:YES completion:nil];
    
}
- (IBAction)loginBtnAction:(id)sender {

    TALoginVC *loginVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TALoginVC"];
    loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [loginVC setIsFromOnboard:YES];
    loginVC.delegateForLogin = self;
    [self presentViewController:loginVC animated:YES completion:nil];
    
}
- (IBAction)skipBtnAction:(id)sender {
    
    [NSUSERDEFAULT setObject:@"YES" forKey:pSkip];
    [NSUSERDEFAULT synchronize];
    [APPDELEGATE navigateToHomeScreenOnController:self.navigationController withAnimation:YES];
}

#pragma mark UICollectionViewDataSource/Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TAOnBoardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAOnBoardCollectionCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.contentLblUpperConstraint.constant = 22;
        cell.onBoardLogoImageView.hidden = NO;
        cell.onBoardImageView.hidden = YES;
        cell.onBoardMiddleLbl.hidden = YES;
        cell.onBoardTitleLbl.hidden = NO;
        cell.onBoardContentLbl.attributedText = [AppUtility customAttributeString:[dic objectForKey:pTitle] withAlignment:NSTextAlignmentCenter] ;
        cell.onBoardLogoImageView.image = [UIImage imageNamed:[dic objectForKey:pTutorialImage]];
        return cell;
    }
    else{
        cell.contentLblUpperConstraint.constant = (indexPath.row == 3)? 20:42;
        cell.contentLblHeightConstraint.constant = 75;
        cell.onBoardLogoImageView.hidden = YES;
        cell.onBoardMiddleLbl.hidden = NO;
        cell.onBoardTitleLbl.hidden = YES;
        cell.onBoardImageView.hidden = NO;
        cell.onBoardMiddleLbl.text = [@[@"ONLY THE BEST",@"HEAT INDEXTM",@"BUY",@"BUILD"] objectAtIndex:indexPath.row-1];
        
        if ([cell.onBoardMiddleLbl.text containsString:@"INDEXTM"]) {
            cell.contentLblHeightConstraint.constant = 100;
            cell.onBoardMiddleLbl.attributedText = [NSString setSuperScriptText:cell.onBoardMiddleLbl.text withFont:[AppUtility sofiaProBoldFontWithSize:14] withBaseLineOffset:@"6"];
        }
        cell.onBoardContentLbl.attributedText = [AppUtility customAttributeString:[dic objectForKey:pTitle] withAlignment:NSTextAlignmentCenter] ;
        cell.onBoardImageView.image = [UIImage imageNamed:[dic objectForKey:pTutorialImage]];
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.onBoardCollectionView.frame.size;
}

#pragma mark - ScrollView Delegates Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    //Switch the indicator when more than 50% of the previous/next page is visible
    //You can vary the percentage
    self.onBoardPageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth)/ pageWidth) + 1;
   self.onBoardUpperTitleLbl.hidden = (self.onBoardPageControl.currentPage == 0) ? YES : NO;

}

#pragma mark - Custom Delegates Method

- (void)manageTheNavigation:(UIViewController*)isFromViewController{
    
    [APPDELEGATE navigateToHomeScreenOnController:self.navigationController withAnimation:YES];
}

@end
