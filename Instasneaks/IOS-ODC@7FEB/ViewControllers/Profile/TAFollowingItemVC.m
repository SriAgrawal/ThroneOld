//
//  TAFollowingItemVC.m
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TAFollowingItemVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    CGFloat totalWidthOfTagView;
}

@property (weak, nonatomic) IBOutlet UICollectionView       * followingItemCollectionView;
@property (strong, nonatomic) NSMutableArray        * storeArray;

@end

@implementation TAFollowingItemVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.followingItemCollectionView setEmptyDataSetSource:self];
    [self.followingItemCollectionView setEmptyDataSetDelegate:self];
    [self setUpDefaults];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self makeApiCallToGetVendorFollowList];
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    [self makeApiCallToGetVendorFollowList];
}

- (CGFloat)manageWidthViewWithTagString:(NSString*)string{
    return  [[[NSAttributedString alloc] initWithString:string] size].width;
}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
        return self.storeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TATrendingStoreCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TATrendingStoreCollectionCell" forIndexPath:indexPath];
    
    
    TAStoreInfo *storeInfo = [self.storeArray objectAtIndex:indexPath.row];
    if (storeInfo.storeCategroyArray.count) {
        NSString *strLast = [storeInfo.storeCategroyArray lastObject];
        strLast = [strLast stringByReplacingOccurrencesOfString:@", " withString:@""];
        [storeInfo.storeCategroyArray replaceObjectAtIndex:[storeInfo.storeCategroyArray count]-1 withObject:strLast];
    }
    totalWidthOfTagView = 0.0;
    for (NSString *str in storeInfo.storeCategroyArray) {
        totalWidthOfTagView  = totalWidthOfTagView +[self manageWidthViewWithTagString:str] ;
    }
    totalWidthOfTagView = totalWidthOfTagView-5;
    if (totalWidthOfTagView < windowWidth) {
        [cell.categoryTagView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.categoryTagView setFrame:CGRectMake((windowWidth-totalWidthOfTagView)/2,cell.categoryTagView.frame.origin.y ,totalWidthOfTagView, 30)];
    }
    [cell.storeRatingView setValue:storeInfo.storeRating];
    [cell.categoryTagView replaceTags:storeInfo.storeCategroyArray];
    [cell.categoryTagView setTagFont:[AppUtility sofiaProBoldFontWithSize:12]];
    
    cell.storeNameLbl.text = storeInfo.storeName;
    [cell.storeImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:storeInfo.storeHeaderImage] placeholderImage:[UIImage imageNamed:@"store-1-big"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    cell.storeTitleLbl.text = @"HEAT INDEXTM";
   cell.followBtn.tag = indexPath.row + 2000;
    if (storeInfo.isFollow) {
        [cell.followBtn setBackgroundColor:[UIColor whiteColor]];
        [cell.followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.followBtn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [cell.followBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
    }
    [cell.followBtn addTarget:self action:@selector(followButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    if ([cell.storeTitleLbl.text containsString:@"INDEXTM"]) {
        cell.storeTitleLbl.attributedText = [NSString setSuperScriptText:cell.storeTitleLbl.text withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(windowWidth, 236);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TAStoreInfo *storeObj = [self.storeArray objectAtIndex:indexPath.item];
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAPageStoreContainerViewController *productVC = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAPageStoreContainerViewController"];
    productVC.storeId = storeObj.storeId;
    [objNav pushViewController:productVC animated:YES];
}

#pragma mark - Selector Method

- (IBAction)followButtonTapped:(UIButton *)sender {
    
    TAStoreInfo *obj = [_storeArray objectAtIndex:sender.tag-2000];
    obj.isFollow = !obj.isFollow;
    if (obj.isFollow) {
        if (![NSUSERDEFAULT boolForKey:pIsFirstLike]) {
                [NSUSERDEFAULT setBool:YES forKey:pIsFirstLike];
              UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
            obj.isFrom = @"follow";
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        }
    }
    [_followingItemCollectionView reloadData];
}

#pragma mark - Web Service Method

-(void)makeApiCallToGetVendorFollowList{
    
    [[ServiceHelper helper] request:nil apiName:kVender_Follows withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.storeArray removeAllObjects];
            self.storeArray = [TAStoreInfo parseFollowingStoreListData:[result objectForKeyNotNull:@"follows" expectedObj:[NSArray array]]];
            [self.followingItemCollectionView reloadData];
        });
    }];
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

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

