//
//  TAPortFolioVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 02/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPortFolioVC.h"

@interface TAPortFolioVC ()
{
    NSMutableArray *dataSourceArray;
}
@property(strong,nonatomic) IBOutlet UILabel *noDataPresentLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TAPortFolioVC
#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
       _noDataPresentLbl.attributedText = [NSString customAttributeString:_noDataPresentLbl.text withAlignment:NSTextAlignmentCenter withLineSpacing:4 withFont:[AppUtility sofiaProBoldFontWithSize:19]];
    dataSourceArray = [[NSMutableArray alloc] init];
    if (self.isfromWork){
        self.tableView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = NO;
    }
    for (int discoverInfo = 0; discoverInfo <=5; discoverInfo++) {
        TADiscoverInfo *discoverInfo = [[TADiscoverInfo alloc] init];
        discoverInfo.discoverImage = @"store-1-big";
        discoverInfo.discoverTitle = @"JERRY LORENZO ON LA, FOOD, AND THE BEACH";
        discoverInfo.dicoverDiscription = @"Lorem ipsum dolor sit amet, quo dicit semper ne, no sed vidit munere volumus. Has ex mollis vulputate. Nemore aperiam forensibus vim ea, aeque nusquam invidunt te eam. Eos partiendo iracundia ad.";
        discoverInfo.discoverTime = @"NOVEMBER 14, 2016";
        discoverInfo.discoverTagArray = @[@"BRAND PROFILE, ",@"BRAND, ",@"THRONE"];
        [dataSourceArray addObject:discoverInfo];
    }
}
#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate and Datasource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.isfromWork ? 0 : dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 383;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TADiscoverInfo *discoverInfo = [dataSourceArray objectAtIndex:indexPath.row];
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
    NSURL *myWebsite = [NSURL URLWithString:@"https://throne1.app.link/profile?manualId=1=page=manual"];

    
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

@end
