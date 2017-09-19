//
//  TAFavoriteProductVC.m
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TAFavoriteProductVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    BOOL isListOrGrid;
}


@property (weak, nonatomic) IBOutlet UICollectionView       * favoriteItemCollectionView;

@property (strong, nonatomic) NSArray           * productDataArray;
@property (strong, nonatomic) NSMutableArray    * featureProductsArray;

@end

@implementation TAFavoriteProductVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self makeApiCallToGetProductLikeList];
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    isListOrGrid = NO;
    [self.favoriteItemCollectionView setEmptyDataSetSource:self];
    [self.favoriteItemCollectionView setEmptyDataSetDelegate:self];
    self.featureProductsArray = [[NSMutableArray alloc] init];
    [self makeApiCallToGetProductLikeList];
}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.featureProductsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAFavoriteItemCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFavoriteItemCollectionCell" forIndexPath:indexPath];
    TAProductInfo * productInfo = [self.featureProductsArray objectAtIndex: indexPath.item];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:productInfo.productName];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    cell.soldView.hidden = (self.isSoldItem) ? NO : YES;
    pStyle.alignment = NSTextAlignmentLeft;
    [pStyle setLineSpacing:1];
    [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProBoldFontWithSize:10] range:NSMakeRange(0, [productInfo.productName length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [productInfo.productName length])];
    [cell.titleLbl setAttributedText:string];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
    cell.priceLbl.text = [NSString stringWithFormat:@"$%@0",productInfo.productPrice];
    [cell.likeBtn setSelected:productInfo.isLiked];
    [cell.likeBtn addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isListOrGrid) {
        return CGSizeMake(windowWidth, windowWidth);
    }else{
        return CGSizeMake((collectionView.frame.size.width)/2-2, 252);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.item];
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAProductDetailVC *productVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
    [productVC setProductId:obj.productId];
    [productVC setProductName:obj.productName];
    [objNav pushViewController:productVC animated:YES];
}

#pragma mark- Empty List Content
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

#pragma mark - Selector Method

- (void)likeButtonTapped:(UIButton*)button {
    
    TAFavoriteItemCollectionCell * cell = (TAFavoriteItemCollectionCell *)[[button superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[cell superview];
    NSIndexPath * indexPath = [collectionView indexPathForCell:cell];
    TAProductInfo *obj = [self.featureProductsArray objectAtIndex:indexPath.item];
    obj.isLiked = !obj.isLiked;
    [self makeApiCallToGetProductUnLikeWithId:obj.productId];
    [self.featureProductsArray removeObject:obj];
    [self.favoriteItemCollectionView reloadData];
}

#pragma mark - Web Service Method

-(void)makeApiCallToGetProductLikeList{
    
    [[ServiceHelper helper] request:nil apiName:kProduct_Likes withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.featureProductsArray removeAllObjects];
            [self.featureProductsArray addObjectsFromArray:[TAProductInfo parseFavoriteProductListDataWithList:[result objectForKeyNotNull:pLikes expectedObj:[NSArray array]]]];
            [self.favoriteItemCollectionView reloadData];
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
}

@end
