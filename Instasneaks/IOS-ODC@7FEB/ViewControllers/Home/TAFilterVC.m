//
//  TAFilterVC.m
//  Throne
//
//  Created by Priya Sharma on 16/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAFilterVC.h"
#import "Macro.h"
#import "TAWhatDoYouSellPopUpVC.h"


@interface TAFilterVC ()<TTRangeSliderDelegate>
{
    TAFilterInfo * filterModelObj;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *subcategoryArray;
@property (strong, nonatomic) NSMutableArray *sizeArray;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *subCategoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UISwitch *toggleBtn;

@end

@implementation TAFilterVC

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Initial Method

- (void)initialSetup{
    _dataSourceArray = [[NSMutableArray alloc] init];
    self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"APPAREL",@"SNEAKERS",@"ACCESORIES",@"CUSTOMS",@"ART",@"VINTAGE",nil];
    self.subcategoryArray = [[NSMutableArray alloc]initWithObjects:@"AIR JORDANS",@"NIKE",@"ADIDAS",@"REBOOK",@"ASICS",@"VANS",nil];
    self.sizeArray = [[NSMutableArray alloc]initWithObjects:@"4",@"4.5",@"5",@"5.5",@"9",@"9.5",@"10",@"10.5",@"11",@"11.5",@"12",@"12.5",@"13",@"14",@"15",@"16",@"ALL",nil];
    
    [_categoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
    [_subCategoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
    
    _colorArray =[[NSMutableArray alloc] initWithArray: @[[UIColor blackColor],[UIColor grayColor],RGBCOLOR(229, 229, 229, 1.0),RGBCOLOR(248, 245, 245, 1.0),[UIColor whiteColor],RGBCOLOR(234, 223, 190, 1.0),RGBCOLOR(249, 210, 67, 1.0),RGBCOLOR(218, 173, 32, 1.0),RGBCOLOR(242, 105, 46, 1.0),[UIColor redColor],RGBCOLOR(126, 10, 34, 1.0),RGBCOLOR(248, 286, 108, 1.0),RGBCOLOR(217, 45, 138, 1.0),RGBCOLOR(140, 70, 157, 1.0),RGBCOLOR(156, 238, 254, 1.0),RGBCOLOR(52, 131, 196, 1.0),RGBCOLOR(20, 61, 92, 1.0),RGBCOLOR(204, 252, 67, 1.0),RGBCOLOR(125, 184, 67, 1.0),RGBCOLOR(53, 87, 8, 1.0),RGBCOLOR(93, 47, 16, 1.0),[UIImage imageNamed:@"Color-multicolor"],[UIImage imageNamed:@"color-pattern"],[UIImage imageNamed:@"Color-No_Color"]]];
    
    
    NSLog(@"category array-------------%@",_categoryPassedArray);
    NSLog(@"filter dict-------------%@",_filterDict);

    for (int heatInfo = 0; heatInfo < 4; heatInfo++) {
        TAFilterInfo *filterInfo = [[TAFilterInfo alloc] init];
        filterInfo.isSelectedHeatIndex = NO;
        [self.dataSourceArray addObject:filterInfo];
    }
    filterModelObj = [TAFilterInfo new];
    filterModelObj.categoryArray = [NSMutableArray new];

    
    // when comming from category filter screen
    if (!self.isFromHome) {
        self.categoryLbl.text = @"SUBCATEGORY";
//        [self makeApiCallToGetTheFilterDataForCategory];
    }else{
//        [self makeApiCallToGetTheFilterData];
    }
    
    NSLog(@"filterModelObj-------------%@",filterModelObj);

    dispatch_async(dispatch_get_main_queue(), ^{
        [filterModelObj.categoryArray  removeAllObjects];
        for (TACategoryInfo * catDict in _categoryPassedArray) {
            TAFilterInfo *infoCategory = [[TAFilterInfo alloc] init];
            infoCategory.Id = catDict.categoryId;
            infoCategory.name = [catDict.categoryName uppercaseString];
            [filterModelObj.categoryArray addObject:infoCategory];
        }
    });


}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate And Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isFromHome ? 3 : 5);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TAFilterCategoryCell *cell = (TAFilterCategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"TAFilterCategoryCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.isFromHome) {
            cell.titleLabel.text = @"CATEGORY";
        }else{
            cell.titleLabel.text = @"SUBCATEGORY";
        }
        return cell;
    }
    
    if (indexPath.row == 1) {
        TAFilterHeatIndexCell *cell = (TAFilterHeatIndexCell *)[tableView dequeueReusableCellWithIdentifier:@"TAFilterHeatIndexCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.heatIndexLbl.attributedText = [NSString setSuperScriptText:@"HEAT INDEXTM" withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
        
        [cell.collectionView reloadData];
        return cell;
    }
    if (indexPath.row == 2) {
        TAPriceCell *cell = (TAPriceCell *)[tableView dequeueReusableCellWithIdentifier:@"TAPriceCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.cnewButton addTarget:self action:@selector(commonConditionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.usedButton addTarget:self action:@selector(commonConditionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       
        cell.rangeSlider.minValue = [[[[_filterDict objectForKeyNotNull:@"filters" expectedObj:@""] objectForKeyNotNull:@"price" expectedObj:@""] objectForKeyNotNull:@"min" expectedObj:@""]floatValue];
        cell.rangeSlider.maxValue = [[[[_filterDict objectForKeyNotNull:@"filters" expectedObj:@""] objectForKeyNotNull:@"price" expectedObj:@""] objectForKeyNotNull:@"max" expectedObj:@""]floatValue];
        cell.rangeSlider.delegate = self;
        return cell;
    }
    
    if (indexPath.row == 3) {
        TASizeSelectionTVC *cell = (TASizeSelectionTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASizeSelectionTVC"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if (indexPath.row == 4) {
        TAColorPickerCell *cell = (TAColorPickerCell *)[tableView dequeueReusableCellWithIdentifier:@"TAColorPickerCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            //            return 210;
            return 0;
            break;
        case 1:
            return 150;
            break;
        case 2:
            return 197;
            break;
        case 3:
            return (filterModelObj.sizeArray.count >7)?(filterModelObj.sizeArray.count %7 == 0)?29 + 46 * (filterModelObj.sizeArray.count/7):29 + 46 * (filterModelObj.sizeArray.count /7 +1):75;
            break;
        case 4:
            return 300;
            break;
        default:
            return  0;
            break;
    }
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
            return filterModelObj.sizeArray.count;
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
        self.isFromHome ?[cell.categoryButton setTitle:[_categoryArray objectAtIndex:indexPath.item] forState:UIControlStateNormal]:[cell.categoryButton setTitle:[_subcategoryArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        
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
        
       /* NSMutableArray * arrayOfHeatAvailable = [[_filterDict objectForKeyNotNull:@"filters" expectedObj:@""] objectForKeyNotNull:@"heat_index" expectedObj:@""];
        [cell.heatButton setUserInteractionEnabled:NO];

        switch (indexPath.item) {
            case 0:{
                
                [arrayOfHeatAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"4"])
                        [cell.heatButton setUserInteractionEnabled:YES];
                }];
            }
                break;
            case 1:{
                
                [arrayOfHeatAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"3"])
                        [cell.heatButton setUserInteractionEnabled:YES];
                }];
            }
                break;
            case 2:
            {
                [arrayOfHeatAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"2"])
                        [cell.heatButton setUserInteractionEnabled:YES];
                }];
            }
                break;
            case 3:{
                [arrayOfHeatAvailable enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"1"])
                        [cell.heatButton setUserInteractionEnabled:YES];
                }];
            }
                break;
            default:
                break;
        }
        */
        return cell;
    }
    if (collectionView.tag == 300) {
        TASizeSelectionCell  *sizeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TASizeSelectionCell" forIndexPath:indexPath];
        //        [sizeCell.sizeSelectionButton setTitle:[[filterModelObj.sizeArray objectAtIndex:indexPath.item] valueForKey:pName] forState:UIControlStateNormal];
        [sizeCell.sizeSelectionButton setTitle:[_sizeArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
        
        TAFilterInfo * sizeObj = [filterModelObj.sizeArray objectAtIndex:indexPath.item];
        if (sizeObj.isSelected) {
            [sizeCell.sizeSelectionButton setSelected:YES];
            sizeCell.sizeSelectionButton.layer.backgroundColor=[UIColor blackColor].CGColor;
            [sizeCell.sizeSelectionButton setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
        }else{
            [sizeCell.sizeSelectionButton setSelected:NO];
            sizeCell.sizeSelectionButton.layer.backgroundColor=[UIColor whiteColor].CGColor;
            [sizeCell.sizeSelectionButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }
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
        
        //        [cell.colorPickerButton setBackgroundColor:[UIColor colorWithHexString:[[filterModelObj.colorArray objectAtIndex:indexPath.item] valueForKey:pName]]];
        
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
        [_tableView reloadData];
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
    [_tableView reloadData];
}
- (void)selectionButtonTapped:(UIButton*)sender {
    TAFilterInfo * sizeObj = [filterModelObj.sizeArray objectAtIndex:sender.tag-20];
    sizeObj.isSelected = !sizeObj.isSelected;
    if (sizeObj.isSelected) {
        [sender setSelected:YES];
        sender.layer.backgroundColor=[UIColor blackColor].CGColor;
        [sender setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
    }else{
        [sender setSelected:NO];
        sender.layer.backgroundColor=[UIColor whiteColor].CGColor;
        [sender setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)colorButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 2000 || sender.tag ==2022) {
        [sender setImage:[UIImage imageNamed:@"checkmark-white"] forState:UIControlStateSelected];
    }
    [_tableView reloadData];
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
    if (sender.tag == 12){
        filterModelObj.isNewSelected = YES;
        filterModelObj.isUsedSelected = NO;
    }else{
        filterModelObj.isNewSelected = NO;
        filterModelObj.isUsedSelected = YES;
    }

}
// save data to NSUserDefault
-(void)saveDataInUserdefault:(NSMutableDictionary *)saveFilterData{
    [saveFilterData setValue:[NSNumber numberWithBool:filterModelObj.isMaleSelected] forKey:@"maleSelection"];
    [saveFilterData setValue:[NSNumber numberWithBool:filterModelObj.isFemaleSelected] forKey:@"femaleSelection"];
    [saveFilterData setValue:filterModelObj.selectedMinimum forKey:@"filterMin"];
    [saveFilterData setValue:filterModelObj.selectedMaximum forKey:@"filterMax"];
    [saveFilterData setValue:[NSNumber numberWithBool:filterModelObj.isNewSelected] forKey:@"newSelected"];
    [saveFilterData setValue:[NSNumber numberWithBool:filterModelObj.isUsedSelected] forKey:@"usedSelected"];
    
    // for heat index
    NSMutableArray * arrayOfheatIndex = [NSMutableArray new];
    for (TAFilterInfo *heatIndex in self.dataSourceArray) {
        NSMutableDictionary * heatIndexDict = [NSMutableDictionary new];
        [heatIndexDict setValue:[NSNumber numberWithBool:heatIndex.isSelectedHeatIndex] forKey:pStatus];
        [arrayOfheatIndex addObject:heatIndexDict];
    }
    [saveFilterData setObject:arrayOfheatIndex forKey:@"HeatSelected"];
    
    // array of category
    NSMutableArray * arrayOfselectedCategory = [NSMutableArray new];
    for (TAFilterInfo *catInfo in filterModelObj.categoryArray) {
        NSMutableDictionary * catDict = [NSMutableDictionary new];
        [catDict setValue:catInfo.name forKey:pName];
        [catDict setValue:catInfo.Id forKey:pId];
        [catDict setValue:[NSNumber numberWithBool:catInfo.isSelected] forKey:pStatus];
        [arrayOfselectedCategory addObject:catDict];
    }
    [saveFilterData setObject:arrayOfselectedCategory forKey:@"categorySelected"];

    
}
#pragma mark - UIButton Action
- (IBAction)applyButtonAction:(UIButton *)sender {
    
    if (filterModelObj.isToggleSelected && self.isFromHome) {
        NSMutableDictionary * saveFilterData = [NSMutableDictionary new];
        [self saveDataInUserdefault:saveFilterData];
        NSLog(@"--------%@",saveFilterData);
        NSData *userEncodeData = [NSKeyedArchiver archivedDataWithRootObject:saveFilterData];
        [NSUSERDEFAULT setValue:userEncodeData forKey:@"userEncodeData"];
        [NSUSERDEFAULT synchronize];
        
    }else{
        if (self.isFromHome) {
            [NSUSERDEFAULT removeObjectForKey:@"userEncodeData"];
            [NSUSERDEFAULT synchronize];
        }
    }
    [NSUSERDEFAULT setBool:filterModelObj.isToggleSelected forKey:pIsToggleSelected];
    [NSUSERDEFAULT synchronize];
    
    // save for category
    if (filterModelObj.isToggleSelected && !self.isFromHome) {
        NSMutableDictionary * saveFilterCategoryData = [NSMutableDictionary new];
        [self saveDataInUserdefault:saveFilterCategoryData];

        // for size
        NSMutableArray * arrayOfSize = [NSMutableArray new];
        for (TAFilterInfo *sizeObj in filterModelObj.sizeArray) {
            NSMutableDictionary * sizeDict = [NSMutableDictionary new];
            [sizeDict setValue:sizeObj.name forKey:pName];
            [sizeDict setValue:sizeObj.Id forKey:pId];
            [sizeDict setValue:[NSNumber numberWithBool:sizeObj.isSelected] forKey:pStatus];
            [arrayOfSize addObject:sizeDict];
        }
        [saveFilterCategoryData setObject:arrayOfSize forKey:@"sizeSelected"];
        
        NSLog(@"--------%@",saveFilterCategoryData);
        NSData *userEncodeData = [NSKeyedArchiver archivedDataWithRootObject:saveFilterCategoryData];
        [NSUSERDEFAULT setValue:userEncodeData forKey:@"userCategoryEncodeData"];
        [NSUSERDEFAULT synchronize];
        
    }else{
        if (!self.isFromHome) {
            [NSUSERDEFAULT removeObjectForKey:@"userCategoryEncodeData"];
            [NSUSERDEFAULT synchronize];
        }
    }
    
    filterModelObj.heat_indexArray = [NSMutableArray new];
    filterModelObj.heat_indexArray = _dataSourceArray;
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForFilter && [_delegateForFilter respondsToSelector:@selector(manageTheNavigation:)])
        {
            [_delegateForFilter manageTheNavigation:self.dataSourceArray filterPreference:filterModelObj];
        }
    }];
}

- (IBAction)toggleBtnAction:(UISwitch *)sender {
    filterModelObj.isToggleSelected = !filterModelObj.isToggleSelected;
    sender.selected = filterModelObj.isToggleSelected;
}

- (IBAction)categoryBtnAction:(id)sender {
    [self.view endEditing:YES];
    TAWhatDoYouSellPopUpVC *customAlertVC = [[TAWhatDoYouSellPopUpVC alloc] initWithNibName:@"TAWhatDoYouSellPopUpVC" bundle:nil];
    customAlertVC.delegate = self;
    customAlertVC.dataType = @"2";
    customAlertVC.arrayOfcategory = filterModelObj.categoryArray;
    customAlertVC.selectedString = _categoryBtn.titleLabel.text;
    customAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:customAlertVC animated:NO completion:nil];
}
- (IBAction)subCategoryBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    TAWhatDoYouSellPopUpVC *customAlertVC = [[TAWhatDoYouSellPopUpVC alloc] initWithNibName:@"TAWhatDoYouSellPopUpVC" bundle:nil];
    customAlertVC.delegate = self;
    customAlertVC.dataType = @"3";
    customAlertVC.selectedString = _subCategoryBtn.titleLabel.text;
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

    filterModelObj.categoryArray = selectedObj;
    NSMutableArray * arrayOfSelectedString = [NSMutableArray new];
    for (TAFilterInfo * info in filterModelObj.categoryArray) {
        if (info.isSelected) {
            [arrayOfSelectedString addObject:info.name];
        }
    }
    NSString * selectedArrayString = [arrayOfSelectedString componentsJoinedByString:@", "];
    if ([type isEqualToString:@"2"]) {
        [_categoryBtn setTitle:[selectedArrayString length]?selectedArrayString:@"GRAPHIC DESIGN" forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"3"]){
        [_subCategoryBtn setTitle:[selectedArrayString length]?selectedArrayString:@"WRITING" forState:UIControlStateNormal];
    }

}
- (IBAction)commonGenderButtonAction:(UIButton *)sender {
    
    
    UIButton *maleBtn = (UIButton *)[self.view viewWithTag:1000];
    UIButton *femaleBtn = (UIButton *)[self.view viewWithTag:1001];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor blackColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        if (sender.tag == 1000) {
            [femaleBtn setBackgroundColor:[UIColor clearColor]];
            [femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [femaleBtn setSelected:NO];
            filterModelObj.isMaleSelected = YES;
            filterModelObj.isFemaleSelected = NO;
        }else{
            [maleBtn setBackgroundColor:[UIColor clearColor]];
            [maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [maleBtn setSelected:NO];
            filterModelObj.isFemaleSelected = YES;
            filterModelObj.isMaleSelected = NO;
        }
    }else{
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(sender.tag == 1000){
            filterModelObj.isMaleSelected = NO;
        }else
            filterModelObj.isFemaleSelected = NO;
    }
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
    filterModelObj.selectedMinimum = [NSString stringWithFormat:@"%f",selectedMinimum];
    filterModelObj.selectedMaximum = [NSString stringWithFormat:@"%f",selectedMaximum];
    
    NSLog(@"Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
}
#pragma mark - WEB API

-(void)makeApiCallToGetTheFilterData{
    
    [[ServiceHelper helper] request:nil apiName:KFilter withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary * resultDict = [result objectForKeyNotNull:@"filter" expectedObj:@""];
            filterModelObj = [TAFilterInfo getFilterInfo:resultDict];
            if ([[NSUSERDEFAULT valueForKey:pIsToggleSelected] boolValue]) {
                [self setUpDefaultsIfSwitchOn];
            }
        });
    }];
}

-(void)makeApiCallToGetTheFilterDataForCategory{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"filter?category=%@",_categoryId] withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"--------------%@",result);
            NSMutableDictionary * resultDict = [result objectForKeyNotNull:@"filter" expectedObj:@""];
            filterModelObj = [TAFilterInfo getFilterInfoForCategory:resultDict];
            if ([[NSUSERDEFAULT valueForKey:pIsToggleSelected] boolValue]) {
                [self setUpDefaultsIfCategroySwitchOn];
            }
        });
    }];
}

#pragma mark - Helper Methods To Get Data From NSUSERDEFAULTS
-(void)setUpDefaultsIfSwitchOn{
    NSData *userDecode = [NSUSERDEFAULT valueForKey:@"userEncodeData"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDecode];
    NSLog(@"initial---------------%@",userDict);
    if (userDict)
        [self setUpDatafromUserDefault:userDict];
}
-(void)setUpDefaultsIfCategroySwitchOn{
    NSData *userDecode = [NSUSERDEFAULT valueForKey:@"userCategoryEncodeData"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDecode];
    NSLog(@"initial---------------%@",userDict);
    if (userDict){
        [self setUpDatafromUserDefault:userDict];
        // For Size Selection.
        NSMutableArray * arrayOfSelectedSize = [NSMutableArray new];
        for (TAFilterInfo *filterInfoObj in [userDict valueForKey:@"sizeSelected"]) {
            TAFilterInfo *filterInfo = [[TAFilterInfo alloc] init];
            filterInfo.isSelected = [[filterInfoObj valueForKey:pStatus] boolValue];
            filterInfo.Id = [filterInfoObj valueForKey:pId];
            filterInfo.name = [filterInfoObj valueForKey:pName];
            [arrayOfSelectedSize addObject:filterInfo];
        }
        filterModelObj.sizeArray = arrayOfSelectedSize;
        UICollectionView * collectionCell = (UICollectionView *)[self.view viewWithTag:300];
        [collectionCell reloadData];
    }
}
-(void)setUpDatafromUserDefault:(NSDictionary *)userDict {
    [_toggleBtn setOn:YES];
    filterModelObj.isToggleSelected = YES;
    
    // Male Female Btn Selection
    UIButton *maleBtn = (UIButton *)[self.view viewWithTag:1000];
    UIButton *femaleBtn = (UIButton *)[self.view viewWithTag:1001];
    if ([[userDict valueForKey:@"maleSelection"]boolValue]) {
        [maleBtn setBackgroundColor:[UIColor blackColor]];
        [maleBtn setSelected:YES];
        [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        filterModelObj.isMaleSelected = YES;
    }
    if ([[userDict valueForKey:@"femaleSelection"]boolValue]) {
        [femaleBtn setBackgroundColor:[UIColor blackColor]];
        [femaleBtn setSelected:YES];
        [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        filterModelObj.isFemaleSelected = YES;
    }
    
    // Range slider
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    TAPriceCell *cell = (TAPriceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    filterModelObj.selectedMinimum = [NSString stringWithFormat:@"%f",[[userDict valueForKey:@"filterMin"] floatValue]];
    filterModelObj.selectedMaximum = [NSString stringWithFormat:@"%f",[[userDict valueForKey:@"filterMax"] floatValue]];
    cell.rangeSlider.selectedMinimum = [filterModelObj.selectedMinimum floatValue];
    cell.rangeSlider.selectedMaximum = [filterModelObj.selectedMaximum floatValue];
    
    // NEW and USED selection
    if ([[userDict valueForKey:@"newSelected"] boolValue]) {
        [cell.cnewButton setBackgroundColor:[UIColor blackColor]];
        [cell.cnewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [cell.cnewButton setSelected:YES];
        filterModelObj.isNewSelected = YES;
        filterModelObj.isUsedSelected = NO;
    }
    if ([[userDict valueForKey:@"usedSelected"] boolValue]) {
        [cell.usedButton setBackgroundColor:[UIColor blackColor]];
        [cell.usedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [cell.usedButton setSelected:YES];
        filterModelObj.isNewSelected = NO;
        filterModelObj.isUsedSelected = YES;
    }
    
    [self.tableView reloadData];
    
    //Category selection
    NSMutableArray * arrayOfSelectedString = [NSMutableArray new];
    for (NSDictionary * info in [userDict valueForKey:@"categorySelected"]) {
        if ([[info valueForKey:@"productStatus"] boolValue]) {
            [arrayOfSelectedString addObject:[info valueForKey:pName]];
        }
    }
    [_categoryBtn setTitle:[[arrayOfSelectedString componentsJoinedByString:@", "] length]?[arrayOfSelectedString componentsJoinedByString:@", "]:@"GRAPHIC DESIGN" forState:UIControlStateNormal];
    
    //HeatIndex selection
    [self.dataSourceArray removeAllObjects];
    for (TAFilterInfo *filterInfoObj in [userDict valueForKey:@"HeatSelected"]) {
        TAFilterInfo *filterInfo = [[TAFilterInfo alloc] init];
        filterInfo.isSelectedHeatIndex = [[filterInfoObj valueForKey:@"productStatus"] boolValue];
        [self.dataSourceArray addObject:filterInfo];
    }
    UICollectionView * collectionCell = (UICollectionView *)[self.view viewWithTag:200];
    [collectionCell reloadData];
}
@end
