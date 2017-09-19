//
//  TAStoreDetailsVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 23/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAStoreDetailsVC.h"

@interface TAStoreDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
    BOOL isLoadMoreExecuting ;
    TAPagination *pagination;
}
@property (weak, nonatomic) IBOutlet UITableView *storeTableView;
@property (strong,nonatomic) NSArray *productArray;

@property (strong, nonatomic) NSMutableArray    * featureProductsArray;


@end

@implementation TAStoreDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.storeTableView setEmptyDataSetSource:self];
    [self.storeTableView setEmptyDataSetDelegate:self];
    [self setUpDefaults];
}

#pragma mark - Class Helper Methods

-(void)setUpDefaults{
    
    self.featureProductsArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gridView) name:@"grid" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listView) name:@"list" object:nil];
    
    switch (self.storeType) {
        case ALL:
        {
            [self makeApiCallToGetProductList];
        }
            break;
        case SOLD:
        {
            [self makeApiCallToGetProductSoldList];
        }
            break;
            

        default:
            break;
    }
}

- (void)gridView
{
    self.layoutSet = 0;
    [self.storeTableView reloadData];
}

- (void)listView
{
    self.layoutSet = 1;
    [self.storeTableView reloadData];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_layoutSet == 1)
        return self.featureProductsArray.count;
    else
        return self.featureProductsArray.count ? 1: 0;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_layoutSet == 1)
        return 516.0f;
    else
        return (self.featureProductsArray.count%2 + self.featureProductsArray.count/2)*257;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //LIST------>
    if (_layoutSet == 1) {
        
        TAFeatureProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAFeatureProductTableCell" forIndexPath:indexPath];
        TAProductInfo *productInfo = [self.featureProductsArray objectAtIndex:indexPath.row];
        cell.likeBtn.selected =  productInfo.isLiked;
        cell.productNameLbl.text = productInfo.productName;
        cell.soldOutView.hidden = !productInfo.isSold;
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
        [cell.storeAddressLbl setAttributedText:[[NSString stringWithFormat:@"FROM %@", @"MISTER SHOES"] getAttributedString:@"FROM" withColor:[UIColor blackColor] withFont:[AppUtility sofiaProLightFontWithSize:14]]];
        [cell.conditionBtn setImage:[UIImage imageNamed:([productInfo.productConditions isEqualToString:@"unused"])?@"condition-used":@"condition-new"] forState:UIControlStateNormal];
        cell.likeBtn.tag = indexPath.row;
        [cell.priceBtn setTitle:[NSString stringWithFormat:@"$%@0 - BUY",productInfo.productPrice] forState:UIControlStateNormal];
        cell.productImageBottomConstraints.constant = ([self.featureProductsArray count]-1 == indexPath.row ?0.0:10.5);
        [cell.likeBtn addTarget:self action:@selector(likeButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    //Grid------>
    else{
        TATrendingProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TATrendingProductTableCell" forIndexPath:indexPath];
        cell.productCollectionView.delegate = self;
        cell.productCollectionView.dataSource = self;
        cell.productCollectionView.tag = 2000;
        [cell.productCollectionView reloadData];
        return cell;
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"GET WORKING!\nYOU HAVE NOTHING TO SHOW HERE YET.";
    NSDictionary *attributes = @{NSFontAttributeName: [AppUtility sofiaProBoldFontWithSize:15], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentCenter;
    [pStyle setLineSpacing:6];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [text length])];
    return string;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -160.0f;
}

#pragma mark - Selector method

-(void)likeButtonAction:(UIButton *)button withEvent:(UIEvent*)event{
    
    NSIndexPath * indexPath = [self.storeTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.storeTableView]];
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.row];
    [self methodToLikeProductWithobject:obj];
}

-(void)likeGridButtonAction:(UIButton *)button {
    
    TAFeatureCollectionCell * cell = (TAFeatureCollectionCell *)[[button superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[cell superview];
    NSIndexPath * indexPath = [collectionView indexPathForCell:cell];
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.row];
    [self methodToLikeProductWithobject:obj];
}

-(void)methodToLikeProductWithobject:(TAProductInfo *)obj{
    
    obj.isLiked = !obj.isLiked;
    if ( obj.isLiked ) {
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
    else
        [self makeApiCallToGetProductUnLikeWithId:obj.productId];

    [self.storeTableView reloadData];
}

- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.featureProductsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAFeatureCollectionCell  *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFeatureCollectionCell" forIndexPath:indexPath];
    TAProductInfo *productInfo = [self.featureProductsArray objectAtIndex:indexPath.item];
    productCell.soldOutView.hidden = !productInfo.isSold;
    productCell.productLikeBtn.selected =  productInfo.isLiked;
    productCell.productNameLbl.text = productInfo.productName;
    [productCell.productPriceBtn setTitle:[NSString stringWithFormat:@"$%@",productInfo.productPrice] forState:UIControlStateNormal];
    [productCell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
    [productCell.productLikeBtn addTarget:self action:@selector(likeGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return productCell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width)/2-2,252);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.row];
    if (!obj.isSold) {
        TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
        [productVC setProductId:obj.productId];
        [productVC setProductName:obj.productName];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if ([pagination.current_page integerValue] < [pagination.pages integerValue] && isLoadMoreExecuting) {
            
            switch (self.storeType) {
                case ALL:
                {
                    [self makeApiCallToGetProductList];
                }
                    break;
                 case SOLD:
                {
                    [self makeApiCallToGetProductSoldList];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - Web Service Method To Get Product Detail
-(void)makeApiCallToGetProductList{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:self.storeId forKey:pVendor];

    isLoadMoreExecuting = NO;
    [[ServiceHelper helper] request:param apiName:kProducts withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.featureProductsArray removeAllObjects];
            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            [self.storeTableView reloadData];
        });
    }];
}
-(void)makeApiCallToGetProductForSaleList{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:pVendor];
    [param setValue:@"0" forKey:@"total_on_hand_gt"];

    [[ServiceHelper helper] request:param apiName:kProducts withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            isLoadMoreExecuting = YES;
            pagination = [TAPagination getPaginationInfoFromDict:result];
            
            if ([pagination.current_page integerValue] == 1) {
                [self.featureProductsArray removeAllObjects];
            }
            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
        });
    }];
}
-(void)makeApiCallToGetProductSoldList{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:pVendor];
    [param setValue:@"0" forKey:@"total_on_hand"];

    [[ServiceHelper helper] request:param apiName:kProducts withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.featureProductsArray removeAllObjects];
            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseProductListDataWithList:[result objectForKeyNotNull:kProducts expectedObj:[NSArray array]]]];
            [self.storeTableView reloadData];
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
#pragma mark- Handling the memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
