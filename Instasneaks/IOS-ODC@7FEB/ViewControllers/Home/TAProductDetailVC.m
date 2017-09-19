//
//  TAProductDetailVC.m
//  Throne
//
//  Created by Suresh patel on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"
#import "FXPageControl.h"
#import "TAPurchaseDetailsVC.h"

static NSString *productDetailCellIdentifier = @"TAProductDetailCell";
static NSString *productDetailOptionsCellIdentifier = @"TAProductDetailOptionsCell";

@interface TAProductDetailVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,navigationDelegateForProductDetails>{

    CGFloat totalWidthOfTagView;
    BOOL isLoadMoreExecuting ;
    TAPagination *pagination;
}


@property (weak, nonatomic) IBOutlet UICollectionView   * imageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView   * moreItemCollectionView;
@property (weak, nonatomic) IBOutlet FXPageControl      * profilePageControl;
@property (weak, nonatomic) IBOutlet UITableView        * productDetailTableView;
@property (weak, nonatomic) IBOutlet UIButton           * likeButton;
@property (weak, nonatomic) IBOutlet UIButton           * followButton;
@property (weak, nonatomic) IBOutlet UILabel            * productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel            * followLabel;
@property (weak, nonatomic) IBOutlet UILabel            * navTitleLabel;

@property (strong, nonatomic) NSMutableArray    * productImageDataArray;
@property (strong, nonatomic) NSMutableArray    * moreItemImageDataArray;
@property (strong, nonatomic) NSMutableArray    * productContentArray;
@property (strong, nonatomic) TAProductInfo     * productInfo;
@property (strong, nonatomic) NSMutableArray    * featureProductsArray;
@property (strong, nonatomic) NSMutableArray    * variantsArray;
@property (weak, nonatomic) IBOutlet UIButton   *moreStoreBtn;
@property (weak, nonatomic) IBOutlet UIButton   * buyButton;

@end

@implementation TAProductDetailVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeApiCallToGetProductDetail:self.productId];
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    _variantsArray = [[NSMutableArray alloc] init];
    self.featureProductsArray = [[NSMutableArray alloc] init];
    self.productInfo = [[TAProductInfo alloc] init];
    self.productImageDataArray = [[NSMutableArray alloc]init];
    [self.profilePageControl setNumberOfPages:[self.productImageDataArray count]];
    [self.profilePageControl setCurrentPage:0];
    self.moreItemImageDataArray = [[NSMutableArray alloc]init];
    self.productDetailTableView.estimatedRowHeight = 60;
    self.productDetailTableView.rowHeight = UITableViewAutomaticDimension;
    [self makeApiCallToGetProductDetail:self.productId];
 }

- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

-(void)populateData{
    
    [self.buyButton setTitle:[NSString stringWithFormat:@"%@ - BUY NOW",self.productInfo.productPrice] forState:UIControlStateNormal];
    [self.productTitleLabel setText:self.productInfo.productName];
    [self.navTitleLabel setText:self.productInfo.productName];
    [self.likeButton setSelected:self.productInfo.isLiked];
    if (self.productInfo.storeInfo.isFollow)
        [self.followButton setBackgroundImage:[self imageFromColor:[UIColor blackColor]] forState:UIControlStateSelected];
    else
        [self.followButton setBackgroundImage:[self imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
    
    TACategoryInfo * apparelInfo = [[TACategoryInfo alloc] init];
    [apparelInfo setCategoryName:@""];
    [apparelInfo setCategoryDescription:self.productInfo.productDescription];

    TACategoryInfo * vintageInfo = [[TACategoryInfo alloc] init];
    [vintageInfo setCategoryName:@"CONDITION"];
    [vintageInfo setCategoryDescription:(self.productInfo.isNew ? @"NEW" : @"USED")];
    
    TACategoryInfo * sneakersInfo = [[TACategoryInfo alloc] init];
    [sneakersInfo setCategoryName:@"SOLD BY"];
    [sneakersInfo setCategoryDescription:self.productInfo.storeInfo.storeName];
    
    NSMutableAttributedString *storeNameStr = [[NSMutableAttributedString alloc] init];
    
    [storeNameStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"MORE FROM "
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
    [storeNameStr appendAttributedString:[[NSAttributedString alloc] initWithString:self.productInfo.storeInfo.storeName
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                                }]];
    [self.moreStoreBtn setAttributedTitle:storeNameStr forState:UIControlStateNormal];
    TACategoryInfo * customsInfo = [[TACategoryInfo alloc] init];
    [customsInfo setCategoryName:@"SHIPS FROM"];
    [customsInfo setCategoryDescription:self.productInfo.storeInfo.address_name];
    
    TACategoryInfo * returnInfo = [[TACategoryInfo alloc] init];
    [returnInfo setCategoryName:@"RETURN"];
    [returnInfo setCategoryDescription:self.productInfo.productReturns];
    
    self.productContentArray = [NSMutableArray arrayWithObjects:apparelInfo, vintageInfo, sneakersInfo, customsInfo, returnInfo, nil];
}
#pragma mark - UITableView Delgate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.productContentArray.count;
            break;
        case 1: case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            TAProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailCellIdentifier];
            if (cell == nil) {
                cell = [[TAProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productDetailCellIdentifier];
            }
            TACategoryInfo * catInfo = [self.productContentArray objectAtIndex:indexPath.item];
            [cell.titleLabel setText:catInfo.categoryName];
            [cell.conditionButton setHidden:YES];
            [cell.storeNameButton setHidden:YES];
            [cell.descriptionLabel setHidden:NO];

            cell.descriptonLabelTopContraints.constant = (indexPath.row ? 28 : 59);

            switch (indexPath.row) {
                case 1:
                    [cell.conditionButton setHidden:NO];
                    [cell.descriptionLabel setHidden:YES];
                    break;
                case 2:
                    [cell.storeNameButton setHidden:NO];
                    [cell.storeNameButton setTitle:catInfo.categoryDescription forState:UIControlStateNormal];
                    [cell.storeNameButton addTarget:self action:@selector(storeNameAction) forControlEvents:UIControlEventTouchUpInside];
                    [cell.descriptionLabel setHidden:YES];
                    
                default:
                    cell.descriptionLabel.attributedText = [self getAttributedStringForSpacing:catInfo.categoryDescription];
                    break;
            }
            
            return cell;
        }
            break;
            
        case 1:
        {
            TAProductDetailOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailOptionsCellIdentifier];
            if (cell == nil) {
            cell = [[TAProductDetailOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productDetailOptionsCellIdentifier];
            }
            totalWidthOfTagView = 0.0;
           
            for (NSString *str in self.productInfo.storeInfo.storeCategroyArray) {
                totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
            }
            totalWidthOfTagView = totalWidthOfTagView - 5;
            if (totalWidthOfTagView < windowWidth) {
                [cell.moreTagView setTranslatesAutoresizingMaskIntoConstraints:YES];
                [cell.moreTagView setFrame:CGRectMake((windowWidth-totalWidthOfTagView)/2+5,cell.moreTagView.frame.origin.y ,totalWidthOfTagView, 25)];
            }
            [cell.moreTagView replaceTags:self.productInfo.storeInfo.storeCategroyArray];
            [cell.moreTagView setTagFont:[AppUtility sofiaProLightFontWithSize:12]];
            [cell.likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeBtn setSelected:[self.likeButton isSelected]];
            
            [cell.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
             [cell.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
        }
            break;
            
        case 2:
        {
            TATrendingProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingProductTableCell" forIndexPath:indexPath];
            cell.productCollectionView.delegate = self;
            cell.productCollectionView.dataSource = self;
            cell.productCollectionView.tag = 2000;
            [cell.productCollectionView reloadData];
            return cell;
        }
            break;
        default:
        {
            TAProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailCellIdentifier];
            if (cell == nil) {
                cell = [[TAProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productDetailCellIdentifier];
            }
            
            TACategoryInfo * catInfo = [self.productContentArray objectAtIndex:indexPath.item];
            [cell.titleLabel setText:catInfo.categoryName];
            [cell.descriptionLabel setText:catInfo.categoryDescription];
            cell.descriptionLabel.attributedText = [self getAttributedStringForSpacing:catInfo.categoryDescription];
            [cell.conditionButton setHidden:YES];
            [cell.descriptionLabel setHidden:NO];
            switch (indexPath.row) {
                case 1:
                    [cell.conditionButton setHidden:NO];
                    [cell.descriptionLabel setHidden:YES];
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            return tableView.rowHeight;
        }
        case 1:
            return 270;
        case 2:
            return (self.featureProductsArray.count%2 + self.featureProductsArray.count/2)*257;
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 2)? 40.0f : 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 40)];
    [headerSectionView setBackgroundColor:[UIColor whiteColor]];
    UILabel *headerSectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, headerSectionView.frame.size.width-20, 35)];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    [footerView setBackgroundColor:[UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0]];
    //Custom section header view
    headerSectionLbl.text = @"FINISH THE LOOK";
    headerSectionLbl.font = [AppUtility sofiaProBoldFontWithSize:12];
    [headerSectionView addSubview:footerView];
    [headerSectionView addSubview:headerSectionLbl];
    return headerSectionView;
}
// Method to get the height of text to show the dynamic content

-(CGSize)heigtForCellwithString:(NSAttributedString *)stringValue withFont:(UIFont*)font{
    
    CGSize constraint = CGSizeMake([[UIScreen mainScreen] bounds].size.width-75, 9999);
    CGRect rect = [stringValue boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

// Method to add spacing between lines

-(NSMutableAttributedString*)getAttributedStringForSpacing:(NSString *)string{
    
    NSString *labelText = string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    return attributedString;
}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (view == self.imageCollectionView)
        return self.productImageDataArray.count == 0 ? 1 : _productImageDataArray.count;
    else if (view == self.moreItemCollectionView)
        return self.moreItemImageDataArray.count;
    else if (view.tag == 2000)
        return self.featureProductsArray.count;
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.imageCollectionView){
          TAImageCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAImageCollectionCell" forIndexPath:indexPath];
        if (_productImageDataArray.count > 0)
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.productImageDataArray objectAtIndex:indexPath.item]] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
        else
            [cell.imageView setImage:[UIImage imageNamed:@"product-1-big"]];
        return cell;
    }
    else if (collectionView == self.moreItemCollectionView){
        TAMoreItemCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAMoreItemCollectionCell" forIndexPath:indexPath];
        TAProductInfo * moreProductInfo = [self.self.moreItemImageDataArray objectAtIndex:indexPath.item];
       [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:moreProductInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
        return cell;
    }
    else{
        TAFeatureCollectionCell  *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFeatureCollectionCell" forIndexPath:indexPath];
        TAProductInfo * productInfo = [self.featureProductsArray objectAtIndex:indexPath.row];
        productCell.productNameLbl.text = productInfo.productName;
            [productCell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
        [productCell.productPriceBtn setTitle:[NSString stringWithFormat:@"$%@0",productInfo.productPrice] forState:UIControlStateNormal];
        [productCell.productSizeLbl setText:productInfo.productSize];
        [productCell.productLikeBtn setSelected:productInfo.isLiked];
        [productCell.productLikeBtn addTarget:self action:@selector(cellLikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return productCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.imageCollectionView){
        return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 502);
    }
    else if (collectionView == self.moreItemCollectionView){
        return CGSizeMake(62, 110);
    }
    else if (collectionView.tag == 2000){
        return CGSizeMake((collectionView.frame.size.width)/2-2,252);
    }
    else{
        return CGSizeMake(70, 110);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.imageCollectionView){
        CGFloat pageWidth = self.imageCollectionView.frame.size.width;
        self.profilePageControl.currentPage = self.imageCollectionView.contentOffset.x / pageWidth;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView != self.imageCollectionView){
        
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 10.0) {
            if ([pagination.current_page integerValue] < [pagination.pages integerValue] && isLoadMoreExecuting) {
                
                [self makeApiCallToGetProductList:self.productId];
            }
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 2000) {
        
        TAProductInfo *productInfo = [_featureProductsArray objectAtIndex:indexPath.item];
        [self makeApiCallToGetProductDetail:productInfo.productId];
        [self.featureProductsArray removeAllObjects];
        [self.productContentArray removeAllObjects];
        [self.productDetailTableView reloadData];
    }
}


#pragma mark- UIButton Action Method

-(IBAction)backButtonAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
};
- (IBAction)moreStoreAction:(id)sender {
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
    [objNav pushViewController:productVC animated:YES];
}

-(IBAction)walletButtonAction:(id)sender{
    
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)buyButtonAction:(UIButton *)sender {
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAPurchaseDetailsVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAPurchaseDetailsVC"];
    obj.delegateForProductDetails = self;
    obj.isBuyForService = self.isCommingFromService;
    obj.productInfoObj = self.productInfo;
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [objNav presentViewController:obj animated:YES completion:nil];
    
}
- (void)manageTheNavigation{
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAOrderDetailsVC *productVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAOrderDetailsVC"];
    [objNav pushViewController:productVC animated:YES];
}
#pragma mark - Selector method

- (IBAction)shareBtnAction:(UIButton*)sender {
    
    NSString *textToShare = @"I thought you'd be interested. Please click on the link before it expires in 48 hours:";
    NSURL *myWebsite = [NSURL URLWithString:@"https://throne1.app.link/profile"];
    
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (IBAction)moreBtnAction:(UIButton*)sender {
    
    TAMoreVC *moreVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAMoreVC"];
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.productId = self.productId;
    [self presentViewController:moreVC animated:YES completion:nil];
}
- (IBAction)likeButtonAction:(UIButton*)sender {
    self.likeButton.selected = !self.likeButton.selected;
    [self.productDetailTableView reloadData];
    if (sender.selected) {
        
        if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
            [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"like";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
        
        [self makeApiCallToGetProductLikeWithId:self.productId];
    }
    else{
        
        [self makeApiCallToGetProductUnLikeWithId:self.productId];
    }
}

- (void)cellLikeButtonAction:(UIButton*)button {
    TAFeatureCollectionCell * cell = (TAFeatureCollectionCell *)[[button superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[cell superview];
    NSIndexPath * indexPath = [collectionView indexPathForCell:cell];
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.item];
    obj.isLiked = !obj.isLiked;
    if (obj.isLiked) {
        
        if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
            [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"like";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
        
        [self makeApiCallToGetProductLikeWithId:obj.productId];
    }
    else{
        
        [self makeApiCallToGetProductUnLikeWithId:obj.productId];
    }
    
    [self.productDetailTableView reloadData];
}
- (void)storeNameAction
{
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
    productVC.storeId = self.productInfo.storeInfo.storeId;
    [objNav pushViewController:productVC animated:YES];
}

- (IBAction)followButtonAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.productInfo.storeInfo.isFollow = sender.selected;
    if (sender.selected) {
        
        if (![NSUSERDEFAULT boolForKey:pIsFirstFollow]) {
            [NSUSERDEFAULT setBool:YES forKey:pIsFirstFollow];
            
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"follow";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
        
        [self makeApiCallToGetProductFollowWithId:self.productInfo.storeInfo.storeId];
    }
    else{
        
        [self makeApiCallToGetProductUnLikeWithId:self.productInfo.storeInfo.storeId];
    }
}

-(UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Web Service Method To Get Product Detail

-(void)makeApiCallToGetProductDetail:(NSString *)productId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products/%@", productId] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _productInfo = [TAProductInfo parseProductDetails:result];
            if (self.isForBuy) {
                self.isForBuy = NO;
                [self buyButtonAction:nil];
            }
            [self populateData];
            [self makeApiCallToGetProductList:productId];
        });
    }];
}

-(void)makeApiCallToGetProductList:(NSString *)productId{
    
    isLoadMoreExecuting = NO;
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products/%@/related", productId] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            isLoadMoreExecuting = YES;
            pagination = [TAPagination getPaginationInfoFromDict:result];
            
            if ([pagination.current_page integerValue] == 1) {
                [self.featureProductsArray removeAllObjects];
            }

            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            [self makeApiCallToGetMoreProductList:self.productInfo.storeInfo.storeId];
        });
    
    }];
}

-(void)makeApiCallToGetMoreProductList:(NSString *)vendorId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products?vendor=%@&id_not=%@",vendorId,self.productId] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        
        [self.moreItemImageDataArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
        self.moreItemImageDataArray = [TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]];
            [self.productDetailTableView reloadData];
            [self.moreItemCollectionView reloadData];
            [self.imageCollectionView reloadData];
        });
    }];
    
}

-(void)makeApiCallToGetProductLikeWithId:(NSString *)productId{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];

    [[ServiceHelper helper] request:param apiName:kProduct_Likes withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

-(void)makeApiCallToGetProductUnLikeWithId:(NSString *)productId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products_likes/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

-(void)makeApiCallToGetProductFollowWithId:(NSString *)productId{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:productId forKey:pId];
    
    [[ServiceHelper helper] request:param apiName:kVender_Follows withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

-(void)makeApiCallToGetProductUnFollowWithId:(NSString *)productId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"vendors_follows/%@", productId] withToken:YES method:DELETE onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}


#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
