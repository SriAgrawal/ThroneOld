//
//  TAStorePageViewController.m
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAStorePageViewController.h"
#import "TAStorePageHeaderView.h"
#import "TAStoreDetailsVC.h"
#import "MBXPageViewController.h"

@interface TAStorePageViewController ()<MBXPageControllerDataSource,MBXPageControllerDataDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    MBXPageViewController *mbXPageController;
}

@property (weak, nonatomic) IBOutlet UITableView *editorTableView;

@property (assign,nonatomic) layoutType layoutSet;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation TAStorePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    // Do any additional setup after loading the view.
}

-(void)initialSetup{
    // Initiate MBXPageController
    mbXPageController = [MBXPageViewController new];
    mbXPageController.MBXDataSource = self;
    mbXPageController.MBXDataDelegate = self;
    
    [self.headerView.editorialBtn addTarget:self action:@selector(editorAction) forControlEvents:UIControlEventTouchUpInside];
    [mbXPageController reloadPages];
    
    [self.editorTableView setEmptyDataSetSource:self];
    [self.editorTableView setEmptyDataSetDelegate:self];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for (int discoverInfo = 0; discoverInfo <=5; discoverInfo++) {
        TADiscoverInfo *discoverInfo = [[TADiscoverInfo alloc] init];
        discoverInfo.discoverImage = @"store-1-big";
        discoverInfo.discoverTitle = @"JERRY LORENZO ON LA, FOOD, AND THE BEACH";
        discoverInfo.dicoverDiscription = @"Lorem ipsum dolor sit amet, quo dicit semper ne, no sed vidit munere volumus. Has ex mollis vulputate. Nemore aperiam forensibus vim ea, aeque nusquam invidunt te eam. Eos partiendo iracundia ad.";
        discoverInfo.discoverTime = @"NOVEMBER 14, 2016";
        discoverInfo.discoverTagArray = @[@"BRAND PROFILE, ",@"BRAND, ",@"THRONE"];
        [self.dataSourceArray addObject:discoverInfo];
    }
    self.gridButton.selected = YES;
    self.listButton.selected = NO;
    self.allLabel.hidden = NO;
    self.soldLabel.hidden = YES;
    self.forSaleLabel.hidden = YES;

}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons
{
    return @[self.allButton, self.forSaleButton, self.soldButton];
}

- (UIView *)MBXPageContainer
{
    return self.containerView;
}

- (NSArray *)MBXPageControllers
{
    TAStoreDetailsVC *favoriteItemVC0 = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAStoreDetailsVC"];
    TAWorkWithMeVC *favoriteItemVC1 = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TAWorkWithMeVC"];
    TAStoreDetailsVC *favoriteItemVC2 = [storyboardForName(storeStoryboardString) instantiateViewControllerWithIdentifier:@"TAStoreDetailsVC"];
    [favoriteItemVC0 setStoreType:ALL];
    //[favoriteItemVC1 setStoreType:FORSALE];
    [favoriteItemVC2 setStoreType:SOLD];

    return @[favoriteItemVC0,favoriteItemVC1, favoriteItemVC2];
}

#pragma mark - MBXPageViewController Delegate

- (void)MBXPageChangedToIndex:(NSInteger)index
{
    [self.containerView setHidden:NO];
    [self.editorTableView setHidden:YES];
    [self.gridButton setUserInteractionEnabled:YES];
    [self.listButton setUserInteractionEnabled:YES];
    [self.headerView.editorialBtn setBackgroundColor:[UIColor clearColor]];
    [self.headerView.editorialBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (index == 0) {
        
        self.allLabel.hidden = NO;
        self.soldLabel.hidden    = YES;
        self.forSaleLabel.hidden = YES;
        [self.allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.forSaleButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.soldButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }else if(index == 1){
        
        [self.gridButton setUserInteractionEnabled:NO];
        [self.listButton setUserInteractionEnabled:NO];
        self.gridButton.selected = NO;
        self.listButton.selected = YES;
        self.allLabel.hidden     = YES;
        self.soldLabel.hidden    = YES;
        self.forSaleLabel.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil];
        [self.forSaleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.soldButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.allButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }else{
        
        self.allLabel.hidden     = YES;
        self.soldLabel.hidden    = NO;
        self.forSaleLabel.hidden = YES;
        
        [self.soldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.allButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.forSaleButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

#pragma mark - Editorial Section

#pragma mark - UITableView Delegate and Datasource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 383;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TADiscoverInfo *discoverInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    TADiscoverListTVC *cell;
    cell = (TADiscoverListTVC *)[tableView dequeueReusableCellWithIdentifier:@"TADiscoverListTVC" forIndexPath:indexPath];
    cell.articleImageView.hidden = NO;
    cell.articleVideoView.hidden = YES;
    cell.shareBtnBottomConstraints.constant = 24.0f;
    cell.categoryBtnBottomConstraints.constant = 48.0f;
    cell.articleImageView.image = [UIImage imageNamed:discoverInfo.discoverImage];
    cell.articleTimeLbl.text = discoverInfo.discoverTime;
    cell.articleTitleLbl.attributedText = [NSString customAttributeString:discoverInfo.discoverTitle withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProBoldFontWithSize:19]];
    cell.articleDiscriptionLbl.attributedText = [NSString customAttributeString:discoverInfo.dicoverDiscription withAlignment:NSTextAlignmentLeft withLineSpacing:8 withFont:[AppUtility sofiaProLightFontWithSize:14]];
    [cell.otherArticleTagView replaceTags:discoverInfo.discoverTagArray];
    [cell.otherArticleTagView setTagFont:[AppUtility sofiaProLightFontWithSize:14]];
    [cell.readMoreBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.articleTitleBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.articleImageBtn addTarget:self action:@selector(readMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark- UIButton Method

-(void)readMoreBtnAction:(UIButton *)sender{
    
    TADiscoverArticalVC *TAManualContainerVC = [storyboardForName(discoverStoryboardString) instantiateViewControllerWithIdentifier:@"TADiscoverArticalVC"];
    [self.navigationController pushViewController:TAManualContainerVC animated:NO];
}

- (void)shareAction:(id)sender {
    
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


#pragma mark - UIButtonAction

- (IBAction)listButtonAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil];
    self.gridButton.selected = NO;
    self.listButton.selected = YES;
}

- (IBAction)gridButtonAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"grid" object:nil];
    self.gridButton.selected = YES;
    self.listButton.selected = NO;
}

-(void)editorAction{

    [self.gridButton setUserInteractionEnabled:NO];
    [self.listButton setUserInteractionEnabled:NO];
    [self.allButton setTitleColor:RGBCOLOR(181, 181, 181, 1.0) forState:UIControlStateNormal];
    [self.soldButton setTitleColor:RGBCOLOR(181, 181, 181, 1.0) forState:UIControlStateNormal];
    [self.forSaleButton setTitleColor:RGBCOLOR(181, 181, 181, 1.0) forState:UIControlStateNormal];
    [self.headerView.editorialBtn setBackgroundColor:[UIColor whiteColor]];
    [self.headerView.editorialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.gridButton.selected = NO;
    self.listButton.selected = YES;

    self.allLabel.hidden     = YES;
    self.soldLabel.hidden    = YES;
    self.forSaleLabel.hidden = YES;
    [self.containerView setHidden:YES];
    [self.editorTableView setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
