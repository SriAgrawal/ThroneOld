//
//  TAFilterServiceVC.m
//  Throne
//
//  Created by Anil Kumar on 27/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAFilterServiceVC.h"
#import "Macro.h"
#import "TAWhatDoYouSellPopUpVC.h"


@interface TAFilterServiceVC ()<TTRangeSliderDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *subcategoryArray;
@property (strong, nonatomic) NSMutableArray *sizeArray;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *filterServicesTableView;

@property (weak, nonatomic) IBOutlet UIButton *graphicDesignBtn;
@property (weak, nonatomic) IBOutlet UIButton *writingBtn;
@property (weak, nonatomic) IBOutlet UIView *locationSearchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *earliestDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *earliestTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *latestDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *latestTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryServiceLbl;


@end

@implementation TAFilterServiceVC

#pragma  mark - View Life Cycle Method.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];

}

#pragma  mark - Memory Management Method.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial Method

- (void)initialSetup{
    
    
    _dataSourceArray = [[NSMutableArray alloc] init];
    self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"APPAREL",@"SNEAKERS",@"ACCESORIES",@"CUSTOMS",@"ART",@"VINTAGE",nil];
    self.subcategoryArray = [[NSMutableArray alloc]initWithObjects:@"AIR JORDANS",@"NIKE",@"ADIDAS",@"REBOOK",@"ASICS",@"VANS",nil];
    
    self.sizeArray = [[NSMutableArray alloc]initWithObjects:@"4",@"4.5",@"5",@"5.5",@"9",@"9.5",@"10",@"10.5",@"11",@"11.5",@"12",@"12.5",@"13",@"14",@"15",@"16",@"ALL",nil];
    
    [_graphicDesignBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
    [_writingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
    
    _colorArray =[[NSMutableArray alloc] initWithArray: @[[UIColor blackColor],[UIColor grayColor],RGBCOLOR(229, 229, 229, 1.0),RGBCOLOR(248, 245, 245, 1.0),[UIColor whiteColor],RGBCOLOR(234, 223, 190, 1.0),RGBCOLOR(249, 210, 67, 1.0),RGBCOLOR(218, 173, 32, 1.0),RGBCOLOR(242, 105, 46, 1.0),[UIColor redColor],RGBCOLOR(126, 10, 34, 1.0),RGBCOLOR(248, 286, 108, 1.0),RGBCOLOR(217, 45, 138, 1.0),RGBCOLOR(140, 70, 157, 1.0),RGBCOLOR(156, 238, 254, 1.0),RGBCOLOR(52, 131, 196, 1.0),RGBCOLOR(20, 61, 92, 1.0),RGBCOLOR(204, 252, 67, 1.0),RGBCOLOR(125, 184, 67, 1.0),RGBCOLOR(53, 87, 8, 1.0),RGBCOLOR(93, 47, 16, 1.0),[UIImage imageNamed:@"Color-multicolor"],[UIImage imageNamed:@"color-pattern"],[UIImage imageNamed:@"Color-No_Color"]]];
    
    for (int heatInfo = 0; heatInfo < 4; heatInfo++) {
        TAFilterInfo *filterInfo = [[TAFilterInfo alloc] init];
        filterInfo.isSelectedHeatIndex = NO;
        [self.dataSourceArray addObject:filterInfo];
    }
}

#pragma mark - UITableView Delegate And Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return (self.isFromHome ? 3 : 5);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        TAFilterCategoryCell *cell = (TAFilterCategoryCell *)[self.filterServicesTableView dequeueReusableCellWithIdentifier:@"TAFilterCategoryCell"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        if (self.isFromHome) {
//            cell.titleLabel.text = @"CATEGORY";
//        }else{
//            cell.titleLabel.text = @"SUBCATEGORY";
//        }
//        return cell;
//    }
//    
//    if (indexPath.row == 1) {
//        TAFilterHeatIndexCell *cell = (TAFilterHeatIndexCell *)[self.filterServicesTableView dequeueReusableCellWithIdentifier:@"TAFilterHeatIndexCell"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        cell.heatIndexLbl.attributedText = [NSString setSuperScriptText:@"HEAT INDEXTM" withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
//        [cell.collectionView reloadData];
//        return cell;
//    }
    if (indexPath.row == 0) {
        TAPriceCell *cell = (TAPriceCell *)[self.filterServicesTableView dequeueReusableCellWithIdentifier:@"TAPriceCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.cnewButton addTarget:self action:@selector(commonConditionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.usedButton addTarget:self action:@selector(commonConditionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.rangeSlider.delegate = self;
        return cell;
    }
    
//    if (indexPath.row == 3) {
//        TASizeSelectionTVC *cell = (TASizeSelectionTVC *)[self.filterServicesTableView dequeueReusableCellWithIdentifier:@"TASizeSelectionTVC"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
//    if (indexPath.row == 4) {
//        TAColorPickerCell *cell = (TAColorPickerCell *)[self.filterServicesTableView dequeueReusableCellWithIdentifier:@"TAColorPickerCell"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
//    switch (indexPath.row) {
//        case 0:
//            return 210;
//            break;
//        case 1:
//            return 150;
//            break;
//        case 2:
//            return 197;
//            break;
//        case 3:
//            return 184;
//            break;
//        case 4:
//            return 300;
//            break;
//        default:
//            return  0;
//            break;
//    }
}

#pragma mark - CollectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    switch (view.tag) {
        case 100:
            return 6;
            break;
        case 200:
            return 4;
            break;
        case 300:
            return _sizeArray.count;
            break;
        case 400:
            return _colorArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 100) {
        
        TACategoryCollCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TACategoryCollCell" forIndexPath:indexPath];
        if (self.isFromHome) {
            [cell.categoryButton setTitle:[_categoryArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        }else{
            [cell.categoryButton setTitle:[_subcategoryArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        }
        
        [cell.leftConstraint setConstant:((indexPath.item%2 == 0) ? 1 : 0)];
        [cell.rightConstraint setConstant:1];
        [cell.topConstarint setConstant:((indexPath.item > 1) ? 0 : 1)];
        cell.categoryButton.tag = indexPath.item + 500;
        [cell.categoryButton addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    
    if (collectionView.tag == 200) {
        
        TAHeatCollCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAHeatCollCell" forIndexPath:indexPath];
        cell.heatButton.tag = indexPath.item + 600;
        [cell.heatButton addTarget:self action:@selector(heatButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.leftConstraint setConstant:((indexPath.item%2 == 0) ? 1 : 0)];
        [cell.rightConstraint setConstant:1];
        [cell.topConstarint setConstant:((indexPath.item > 1) ? 0 : 1)];
        TAFilterInfo *filterInfo = [self.dataSourceArray objectAtIndex:indexPath.item];
        if (filterInfo.isSelectedHeatIndex) {
            cell.heatButton.layer.backgroundColor=[UIColor blackColor].CGColor;
            switch (indexPath.item) {
                case 0:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-white-4"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-white-3"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-2-white"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [cell.heatButton setImage:[UIImage imageNamed:@"heat-index-white"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        else{
            cell.heatButton.layer.backgroundColor=[UIColor whiteColor].CGColor;
            switch (indexPath.item) {
                case 0:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-black-4"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-black-3"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [cell.heatButton setImage:[UIImage imageNamed:@"fire-2-black"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [cell.heatButton setImage:[UIImage imageNamed:@"heat-black"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    if (collectionView.tag == 300) {
        TASizeSelectionCell  *sizeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TASizeSelectionCell" forIndexPath:indexPath];
        [sizeCell.sizeSelectionButton setTitle:[_sizeArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        sizeCell.sizeSelectionButton.tag = indexPath.item + 20;
        [sizeCell.sizeSelectionButton addTarget:self action:@selector(selectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [sizeCell.leftConstraint setConstant:((indexPath.item%7 == 0) ? 1 : 0)];
        [sizeCell.topConstraint setConstant:((indexPath.item > 6) ? 0 : 1)];
        return sizeCell;
    }
    if (collectionView.tag == 400) {
        TAColorPickerCollCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAColorPickerCollCell" forIndexPath:indexPath];
        cell.colorPickerButton.tag = indexPath.item + 2000;
        
        if (indexPath.item > 20)
            [cell.colorPickerButton setBackgroundImage :[_colorArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        else
            [cell.colorPickerButton setBackgroundColor:[_colorArray objectAtIndex:indexPath.item]];
        [cell.colorPickerButton addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.leftConstraint setConstant:((indexPath.item%6 == 0) ? 1 : 0)];
        [cell.topConstarint setConstant:((indexPath.item > 5) ? 0 : 1)];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case 100:
            return CGSizeMake(collectionView.frame.size.width/2, 50);
            break;
        case 200:
            return CGSizeMake((collectionView.frame.size.width)/2, 50);
            break;
        case 300:
            return CGSizeMake(collectionView.frame.size.width/7, 46);
            break;
        case 400:
            return CGSizeMake(collectionView.frame.size.width/6, 54);
            break;
        default:
            return CGSizeMake(collectionView.frame.size.width/2, 50);
            break;
    }
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - UITableView Selector Method
- (void)categoryButtonTapped:(UIButton*)sender {
    if (self.isFromHome){
        for (int tag = 500; tag<=506; tag++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:tag];
            button.selected = NO;
            [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        sender.selected = YES;
        if (sender.selected==YES) {
            sender.layer.backgroundColor=[UIColor blackColor].CGColor;
            [sender setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        }
        [_filterServicesTableView reloadData];
    }else{
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            sender.layer.backgroundColor=[UIColor blackColor].CGColor;
            [sender setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
        }else{
            sender.layer.backgroundColor=[UIColor whiteColor].CGColor;
            [sender setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }
    }
}
- (void)heatButtonTapped:(UIButton*)sender {
    TAFilterInfo *filterInfo = [self.dataSourceArray objectAtIndex:sender.tag - 600];
    filterInfo.isSelectedHeatIndex = !filterInfo.isSelectedHeatIndex;
    [_filterServicesTableView reloadData];
}
- (void)selectionButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.backgroundColor=[UIColor blackColor].CGColor;
        [sender setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
    }else{
        sender.layer.backgroundColor=[UIColor whiteColor].CGColor;
        [sender setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    }
    [_filterServicesTableView reloadData];
}

- (void)colorButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 2000 || sender.tag ==2022) {
        [sender setImage:[UIImage imageNamed:@"checkmark-white"] forState:UIControlStateSelected];
    }
    [_filterServicesTableView reloadData];
}
- (IBAction)commonConditionButtonAction:(UIButton *)sender {
    for (int tag = 12; tag <= 13; tag++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelected:NO];
    }
    [sender setBackgroundColor:[UIColor blackColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setSelected:YES];
}

#pragma mark - UIButton Action
- (IBAction)applyButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForFilter && [_delegateForFilter respondsToSelector:@selector(manageTheNavigation:)])
        {
            [_delegateForFilter manageTheNavigation:self.dataSourceArray];
        }
    }];
}

- (IBAction)commonGenderButtonAction:(UIButton *)sender {
    for (int tag = 1000; tag < 1002; tag++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelected:NO];
    }
    [sender setBackgroundColor:[UIColor blackColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setSelected:YES];
}

- (IBAction)crossButtonAction:(UIButton *)sender {
    [self.dataSourceArray removeAllObjects];
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForFilter && [_delegateForFilter respondsToSelector:@selector(manageTheNavigation:)])
        {
            [_delegateForFilter manageTheNavigation:self.dataSourceArray];
        }
    }];
}
#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    NSLog(@"Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
}

- (IBAction)dateAndTimeBtnCommonBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 500:
            [self showDatePickerView:sender];
            break;
        case 501:
            [self showTimePickerView:sender];
            break;
        case 502:
            [self showDatePickerView:sender];
            break;
        case 503:
            [self showTimePickerView:sender];
            break;
        default:
            break;
    }
    
}
- (IBAction)saveGraphicsBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    TAWhatDoYouSellPopUpVC *customAlertVC = [[TAWhatDoYouSellPopUpVC alloc] initWithNibName:@"TAWhatDoYouSellPopUpVC" bundle:nil];
    customAlertVC.delegate = self;
    customAlertVC.dataType = @"2";
    customAlertVC.selectedString = _graphicDesignBtn.titleLabel.text;
    customAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:customAlertVC animated:NO completion:nil];
}
- (IBAction)writingBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    TAWhatDoYouSellPopUpVC *customAlertVC = [[TAWhatDoYouSellPopUpVC alloc] initWithNibName:@"TAWhatDoYouSellPopUpVC" bundle:nil];
    customAlertVC.delegate = self;
    customAlertVC.dataType = @"3";
    customAlertVC.selectedString = _writingBtn.titleLabel.text;
    customAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:customAlertVC animated:NO completion:nil];
}
#pragma mark - Helper methods.
// handle delegate
-(void)dismissView{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)dismissViewWithData:(NSMutableArray *)selectedObj dataType:(NSString *)type{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString * selectedArrayString = [selectedObj componentsJoinedByString:@","];
    if ([type isEqualToString:@"2"]) {
        [_graphicDesignBtn setTitle:[selectedArrayString length]?selectedArrayString:@"GRAPHIC DESIGN" forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"3"]){
        [_writingBtn setTitle:[selectedArrayString length]?selectedArrayString:@"WRITING" forState:UIControlStateNormal];
    }
}
//Method for show date picker
- (void)showDatePickerView:(UIButton *)sender
{
    [self.view endEditing:YES];
    [[DatePickerManager dateManager] showDatePicker:self withBool:YES completionBlock:^(NSDate *date){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        NSString *stringFromDate = [formatter stringFromDate:date];
//        userInfo.dateOfBirthString = stringFromDate;
        [sender setTitle:stringFromDate forState:UIControlStateNormal];
    }];
}

//Method for show date picker
- (void)showTimePickerView:(UIButton *)sender
{
    [self.view endEditing:YES];

    [[DatePickerManager dateManager] showTimePicker:self withBool:NO completionBlock:^(NSDate *date){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh a"];
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        NSString *stringFromDate = [formatter stringFromDate:date];
        //userInfo.dateOfBirthString = stringFromDate;
        [sender setTitle:stringFromDate forState:UIControlStateNormal];
    }];
}
@end
