//
//  TASizeInformationVC.m
//  Throne
//
//  Created by Suresh patel on 07/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASizeInformationVC.h"
#import "Macro.h"

@interface TASizeInformationVC ()<UICollectionViewDelegate, UICollectionViewDataSource>{

    BOOL isSelectedGender;
}

@property (weak, nonatomic) IBOutlet UIView             * genderView;
@property (weak, nonatomic) IBOutlet UILabel            * titlelabel;
@property (weak, nonatomic) IBOutlet UILabel            * staticlabel;
@property (weak, nonatomic) IBOutlet UIButton           * maleButton;
@property (weak, nonatomic) IBOutlet UIButton           * femaleButton;
@property (weak, nonatomic) IBOutlet UICollectionView   * sizeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * viewHeightConstraint;

@property (strong, nonatomic) NSMutableArray        * menSizeDataArray;
@property (strong, nonatomic) NSMutableArray        * womenSizeDataArray;

@end

@implementation TASizeInformationVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self tapGestureMethod];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    CGFloat height = 0.0;
    CGFloat menheight = (self.menSizeDataArray.count/7 + ((self.menSizeDataArray.count%7 == 0) ? 0 : 1)) * ((windowWidth-30)/7);
    CGFloat womenheight = (self.womenSizeDataArray.count/7 + ((self.womenSizeDataArray.count%7 == 0) ? 0 : 1)) * ((windowWidth-30)/7);
    
    height = menheight + womenheight + 307.5;
    
    if (self.sizeType == gender)
        height = 212.5;
    
    [self.genderView setHidden:!(self.sizeType == gender)];
    [self.sizeCollectionView setHidden:(self.sizeType == gender)];
    [self.staticlabel setHidden:(self.sizeType == gender)];

    [self.viewHeightConstraint setConstant:MIN(height, windowHeight)];
    [self.sizeCollectionView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
    self.menSizeDataArray = [[NSMutableArray alloc] init];
    self.womenSizeDataArray = [[NSMutableArray alloc] init];

    NSArray *menSize;
    NSArray *womenSize;

    switch (self.sizeType) {
            
        case gender:
        {
            [self.titlelabel setText:@"GENDER"];
        }
            break;

        case shoeSize:
        {
            [self.titlelabel setText:@"SHOE SIZE"];
            menSize = [[NSArray alloc] initWithObjects:@"6", @"6.5",@"7", @"7.5", @"8", @"8.5", @"9", @"9.5", @"10", @"10.5", @"11", @"11.5", @"12",@"13", @"14", @"15", @"16", nil];
            womenSize = [[NSArray alloc] initWithObjects:@"4", @"4.5",@"5", @"5.5", @"6", @"6.5", @"7", @"7.5", @"8", @"8.5", @"9", @"9.5", @"10",@"10.5", @"11", @"11.5", @"12", nil];
        }
            break;
            
        case topSize:
        {
            [self.titlelabel setText:@"TOP SIZE"];
            menSize = [[NSArray alloc] initWithObjects:@"XS", @"S",@"M", @"L", @"XL", @"XXL", @"XXXL", nil];
            womenSize = [[NSArray alloc] initWithObjects:@"XXS", @"XS", @"S", @"M", @"L", @"XL", @"XXL", nil];
        }
            break;
            
        default:{
            [self.titlelabel setText:@"BOTTOM SIZE"];
            menSize = [[NSArray alloc] initWithObjects:@"XS", @"S", @"M", @"L", @"XL", @"XXL", @"XXXL", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"36", @"38", @"40", @"42", @"44", @"46", @"48", nil];
            womenSize = [[NSArray alloc] initWithObjects:@"XXS", @"XS", @"S", @"M", @"L", @"XL", @"XXL", @"0", @"2", @"4", @"6", @"8", @"10", @"12", @"14", @"16", @"18", nil];
        }
            break;
    }
    
    for (NSString * size in menSize) {
        TASizeInfo * sizeInfo = [[TASizeInfo alloc] init];
        [sizeInfo setSizeText:size];
        [self.menSizeDataArray addObject:sizeInfo];
    }
    for (NSString * size in womenSize) {
        TASizeInfo * sizeInfo = [[TASizeInfo alloc] init];
        [sizeInfo setSizeText:size];
        [self.womenSizeDataArray addObject:sizeInfo];
    }
    
    [self.staticlabel setAttributedText:[AppUtility customAttributeString:@"CHOOSE ALL THE SIZES YOU WOULD LIKE TO HAVE SAVED FOR YOU." withAlignment:NSTextAlignmentLeft withFont:[AppUtility sofiaProLightFontWithSize:14] andLineSpace:6]];
}

#pragma mark - IBActions Method


- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)minusButtonAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveButtonAction:(id)sender{
    if (isSelectedGender){
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAselectionPopUp *obj = [[TAselectionPopUp alloc]initWithNibName:@"TAselectionPopUp" bundle:nil];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
    }
}

-(IBAction)genderButtonAction:(UIButton *)sender{
    
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:NO];
    [sender setSelected:YES];
    isSelectedGender = sender.selected;
    [self.maleButton setBackgroundColor:[UIColor whiteColor]];
    [self.femaleButton setBackgroundColor:[UIColor whiteColor]];
    [sender setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - CollectionView Delgate and DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return (section ? self.menSizeDataArray.count : self.womenSizeDataArray.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TASizeSelectionCell  *sizeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TASizeSelectionCell" forIndexPath:indexPath];
    TASizeInfo * sizeInfo = [(indexPath.section ? self.menSizeDataArray : self.womenSizeDataArray) objectAtIndex:indexPath.item];
    [sizeCell.sizeSelectionButton setTitle:sizeInfo.sizeText forState:UIControlStateNormal];
    [sizeCell.sizeSelectionButton addTarget:self action:@selector(selectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sizeCell.leftConstraint setConstant:((indexPath.item%7 == 0) ? 1 : 0)];
    [sizeCell.topConstraint setConstant:((indexPath.item > 6) ? 0 : 1)];
    [sizeCell.sizeSelectionButton setSelected:sizeInfo.isSelected];
    [sizeCell.sizeSelectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sizeCell.sizeSelectionButton setBackgroundColor:[UIColor whiteColor]];
    if (sizeInfo.isSelected) {
        [sizeCell.sizeSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sizeCell.sizeSelectionButton setBackgroundColor:[UIColor blackColor]];
    }
    return sizeCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((windowWidth-30)/7, (windowWidth-30)/7);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        TASizeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"TASizeSectionHeaderView" forIndexPath: indexPath];
        [headerView.cellTitleLabel setText:(indexPath.section ? @"MEN" : @"WOMEN")];
        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 45);
}

#pragma mark - Cell Button Action

- (void)selectionButtonTapped:(UIButton*)sender {
    
    TASizeSelectionCell * cell = (TASizeSelectionCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.sizeCollectionView indexPathForCell:cell];

    TASizeInfo * sizeInfo = [(indexPath.section ? self.menSizeDataArray : self.womenSizeDataArray) objectAtIndex:indexPath.item];
    sizeInfo.isSelected = !sizeInfo.isSelected;
    [self.sizeCollectionView reloadData];
}

#pragma mark - Did Receive Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
