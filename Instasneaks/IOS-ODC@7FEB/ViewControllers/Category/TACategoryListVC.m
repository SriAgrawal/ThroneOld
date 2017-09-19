//
//  TACategoryListVC.m
//  Throne
//
//  Created by Suresh patel on 27/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TACategoryListVC ()

@property (weak, nonatomic) IBOutlet UICollectionView   * categoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel            * titlelabel;
@property (weak, nonatomic) IBOutlet UIButton           * requestButton;
@property (weak, nonatomic) IBOutlet UIButton           * shopButton;



@property (strong, nonatomic) NSMutableArray    * categoryDataArray;
@property (strong, nonatomic) NSMutableArray    * productDataArray;
@property (strong, nonatomic) NSMutableArray    *serviceDataArray;

@end

@implementation TACategoryListVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    // Do any additional setup after loading the view.
}
#pragma mark - Class Helper Method
-(void)initialSetup{
    
    [self.titlelabel setText:(self.isFromProduct ? @"BUY THE HOTTEST PRODUCTS" : @"BUY AMAZING SERVICES")];
    [self.requestButton setTitle:(self.isFromProduct ? @"+ REQUEST A PRODUCT" : @"+ REQUEST A SERVICE") forState:UIControlStateNormal];
    [self makeApiCallToGetTheCategoryList];
}
#pragma mark- UIButton Action Method
-(IBAction)backButtonAction:(id)sender{
    
    if (self.isFromLogin && self.isFromProduct) {
        self.isFromProduct = NO;
        [self.categoryCollectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titlelabel setText:(self.isFromProduct ? @"BUY THE HOTTEST PRODUCTS" : @"BUY AMAZING SERVICES")];
            [self.requestButton setTitle:(self.isFromProduct ? @"+ REQUEST A PRODUCT" : @"+ REQUEST A SERVICE") forState:UIControlStateNormal];
        });
        return;
    }
    [self popToHomeViewController];
    
    [[APPDELEGATE tabBarController] setIsCategoryList:NO];
    
    if (self.isFromProduct || self.isFromLogin) {
        
        [[APPDELEGATE tabBarController] setIsFromServiceListing:NO];
        [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
    }
    else {
        [[APPDELEGATE tabBarController] setIsFromServiceListing:YES];
        [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:301];
    }
}
-(IBAction)shopAllCatButtonAction:(id)sender{
    
    UINavigationController *nav;
    if (self.isFromProduct) {
        
        TABecomeVendarVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TABecomeVendarVC"];
        requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    }
    else {
        
        TABecomeVendarVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TABecomeVendarVC"];
        requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    }
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)popToHomeViewController{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)requestCatButtonAction:(id)sender{
    
    UINavigationController *nav;
    if (self.isFromProduct) {
        
        TARequestCategoryVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TARequestCategoryVC"];
        requestVC.isFromService = NO;
        requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    }
    else {
        
        TARequestCategoryVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TARequestCategoryVC"];
        requestVC.isFromService = YES;
        requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    }
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return (self.isFromProduct ? self.productDataArray.count : self.serviceDataArray.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TACategoryCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TACategoryCollectionCell" forIndexPath:indexPath];
    TACategoryInfo * catInfo = [(self.isFromProduct ? self.productDataArray : self.serviceDataArray) objectAtIndex:indexPath.item];
    [cell.titleLabel setText:catInfo.categoryName];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:catInfo.categoryDescription];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentLeft;
    [pStyle setLineSpacing:3];
    [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:10] range:NSMakeRange(0, [catInfo.categoryDescription length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [catInfo.categoryDescription length])];
    [cell.descriptionLabel setAttributedText:string];
    [cell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:catInfo.categoryImage] placeholderImage:[UIImage imageNamed:@"vintage-square"] options:SDWebImageRefreshCached];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((windowWidth-1)/2, (windowHeight-133)/3);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self popToHomeViewController];
    
    [[APPDELEGATE tabBarController] setIsCategoryList:YES];
    if (self.isFromProduct) {
        TACategoryInfo * catInfo = [self.productDataArray objectAtIndex:indexPath.item];
        [[APPDELEGATE tabBarController] setNavLblString:catInfo.categoryName];
        [[APPDELEGATE tabBarController] setCategoryId:catInfo.categoryId];
        [[APPDELEGATE tabBarController] setIsFromServiceListing:NO];
        [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:300];
    }
    else {
        TACategoryInfo * catInfo = [self.serviceDataArray objectAtIndex:indexPath.item];
        [[APPDELEGATE tabBarController] setNavLblString:catInfo.categoryName];
        [[APPDELEGATE tabBarController] setCategoryId:catInfo.categoryId];
        [[APPDELEGATE tabBarController] setIsFromServiceListing:YES];
        [[APPDELEGATE tabBarController] setSelectedViewControllerWithIndex:301];
    }
}
#pragma mark - Web Service Method To Get Category List
-(void)makeApiCallToGetTheCategoryList{
    
    [[ServiceHelper helper] request:nil apiName:kCategories withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.productDataArray removeAllObjects];
            [self.serviceDataArray removeAllObjects];
            
            for (NSDictionary * dict in [result objectForKeyNotNull:kCategories expectedObj:[NSArray array]]) {
                
                if ([[dict objectForKeyNotNull:pName expectedObj:@""] isEqualToString:@"Products"])
                    self.productDataArray = [TACategoryInfo parseCategoryListDataWithList:[dict objectForKeyNotNull:pSubcategories expectedObj:[NSArray array]]];
                else{
                    self.serviceDataArray = [TACategoryInfo parseCategoryListDataWithList:[dict objectForKeyNotNull:pSubcategories expectedObj:[NSArray array]]];
                }
            }
            [self.categoryCollectionView reloadData];
        });
    }];
}
#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
