//
//  TAWhatDoYouSellPopUpVC.m
//  Throne
//
//  Created by Anil Kumar on 22/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAWhatDoYouSellPopUpVC.h"
#import "TAWhatDoYouSellCell.h"
#import "Macro.h"

static NSString * whatToDoCellIdentifier = @"TAWhatDoYouSellCell";
@interface TAWhatDoYouSellPopUpVC ()
{
    NSMutableArray * arrayOfSellChoices;
    TAFilterInfo * selectionModelObj;
    NSMutableArray * arrayOfSelection;
//    NSMutableArray * categoryArray;
//    NSMutableArray * subcategoryArray;

}
@property (weak, nonatomic) IBOutlet UIView *popUpBackGroundView;
@property (weak, nonatomic) IBOutlet UITableView *whatsOnTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *whatDoYouSellLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImageView;

@end

@implementation TAWhatDoYouSellPopUpVC

#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // register cell
    [_whatsOnTableView registerNib:[UINib nibWithNibName:@"TAWhatDoYouSellCell" bundle:nil] forCellReuseIdentifier:whatToDoCellIdentifier];
    if ([_dataType isEqualToString:@"1"]) {
            arrayOfSellChoices = [[NSMutableArray alloc] initWithObjects:@"ORIGINAL APPAREL",@"OTHERS", nil];
    }else if ([_dataType isEqualToString:@"2"]){
        arrayOfSellChoices = _arrayOfcategory;
//        arrayOfSellChoices = [[NSMutableArray alloc]initWithObjects:@"APPAREL",@"SNEAKERS",@"ACCESORIES",@"CUSTOMS",@"ART",@"VINTAGE",nil];
    }else if ([_dataType isEqualToString:@"3"]){
        arrayOfSellChoices = [[NSMutableArray alloc]initWithObjects:@"AIR JORDANS",@"NIKE",@"ADIDAS",@"REEBOOK",@"ASICS",@"VANS",nil];
       }

    
    arrayOfSelection = [NSMutableArray new];
    for (int i = 0; i<arrayOfSellChoices.count; i++) {
        selectionModelObj = [TAFilterInfo alloc];
        TAFilterInfo * filterInfo = [arrayOfSellChoices objectAtIndex:i];
        selectionModelObj.name = filterInfo.name;
        selectionModelObj.Id = filterInfo.Id;
        selectionModelObj.isSelected = NO;
        [arrayOfSelection addObject:selectionModelObj];
    }
    // in case have already selected items
    if (_selectedString) {
        NSArray * forwardedSelection = [_selectedString componentsSeparatedByString:@", "];
        NSLog(@"-----%@",forwardedSelection);
        for (int i = 0; i<arrayOfSellChoices.count; i++){
            TAFilterInfo * selectedObj = [arrayOfSelection objectAtIndex:i];
            for (NSString * str in forwardedSelection) {
                if ([selectedObj.name isEqualToString:str]) {
                    selectedObj.isSelected = YES;
                    break;
                }
            }
        }
    }
}
#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate And DataSource Method.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayOfSellChoices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TAWhatDoYouSellCell *cell = (TAWhatDoYouSellCell *)[tableView dequeueReusableCellWithIdentifier:whatToDoCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    TAFilterInfo * filterInfo = [arrayOfSellChoices objectAtIndex:indexPath.row];
    cell.titleLabel.text = filterInfo.name;
    TARequestCategoryInfo * selectedObj = [arrayOfSelection objectAtIndex:indexPath.row];
    cell.checkMarkImageView.image = selectedObj.isSelected?[UIImage imageNamed:@"checkmark"]:[UIImage new];
    if (indexPath.row == arrayOfSellChoices.count-1) {
        [cell.seperatorLabel setHidden:YES];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TAFilterInfo * selectedObj = [arrayOfSelection objectAtIndex:indexPath.row];
    selectedObj.isSelected = !selectedObj.isSelected;
    [self.whatsOnTableView reloadData];
}

#pragma mark - IBOutlet Button Action.
- (IBAction)okBtnAction:(id)sender {
    NSMutableArray * arrayOFSelectedObj = [NSMutableArray new];
    for (int i = 0; i<arrayOfSellChoices.count; i++) {
        TAFilterInfo * selectedObj = [arrayOfSelection objectAtIndex:i];
        [arrayOFSelectedObj addObject:selectedObj];
    }
    [self.delegate dismissViewWithData:arrayOFSelectedObj dataType:_dataType];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.delegate dismissView];
}

@end
