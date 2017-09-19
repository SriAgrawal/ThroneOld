 //
//  TAAddShippingAddressVC.m
//  Throne
//
//  Created by Priya Sharma on 10/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAAddShippingAddressVC.h"
#import "Macro.h"

@interface TAAddShippingAddressVC ()<UITextFieldDelegate>
{
    NSInteger errorTag;
    NSMutableArray *countryListArray, *stateListArray, *countryNameListArray;
}
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodThree;
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodTwo;
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodOne;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) UserInfo *userDetails;

- (IBAction)continueButtonAction:(UIButton *)sender;
- (IBAction)commonShippingButtonAction:(UIButton *)sender;
- (IBAction)saveAddressButtonAction:(UIButton *)sender;
- (IBAction)collapseButtonAction:(UIButton *)sender;

@end

@implementation TAAddShippingAddressVC

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeApiCallToGetCountryList];
    [self initialSetup];
   }

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([_btitle isEqualToString:@"edit"]) {
        _userDetails.firstNameString = @"";
        _userDetails.lastNameString = @"";
        _userDetails.streetString = @"";
        _userDetails.streetAddress2String = @"";
        _userDetails.stateString = @"";
        _userDetails.cityString = @"";
        _userDetails.countryString = @"";
        _userDetails.zipCodeString = @"";
    }
}

#pragma mark - Initial Setup

- (void)initialSetup{
    _userDetails = [[UserInfo alloc]init];
    countryListArray = [[NSMutableArray alloc] init];
    stateListArray = [[NSMutableArray alloc] init];
    countryNameListArray = [[NSMutableArray alloc] init];
    [_shippingMethodOne setAttributedTitle:[self UnderLineTextString:@"UPS GROUND (ARRIVES IN 5-7 DAYS) $15" withStart:0 andWithEnd:32] forState:UIControlStateNormal];
    [_shippingMethodTwo setAttributedTitle:[self UnderLineTextString:@"UPS TWO-DAY (ARRIVES IN 2-3 DAYS) $22" withStart:0 andWithEnd:34] forState:UIControlStateNormal];
    [_shippingMethodThree setAttributedTitle:[self UnderLineTextString:@"FEDEX NEXT DAY (ARRIVES IN 1-2 DAYS) $35" withStart:0 andWithEnd:37] forState:UIControlStateNormal];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView delegates and datsource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TASingleTextFieldTVC *singlecell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
    TATwoTextFieldTVC *doublecell = (TATwoTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATwoTextFieldTVC"];
    
    doublecell.firstTextField.delegate = self;
    doublecell.secondTextField.delegate = self;
    singlecell.singleTextField.delegate = self;

    [doublecell.firstTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [doublecell.secondTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [singlecell.singleTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    singlecell.singleTextField.paddingValue = 15;
    doublecell.firstTextField.paddingValue  = 15;
    doublecell.secondTextField.paddingValue = 15;

    switch (indexPath.row) {
        case 0:
        {
            doublecell.firstTextField.tag = 100;
            doublecell.secondTextField.tag = 101;
            doublecell.firstTextField.placeholder = @"FIRST NAME*";
            doublecell.secondTextField.placeholder = @"LAST NAME*";
            doublecell.firstTextField.text = _userDetails.firstNameString;
            doublecell.secondTextField.text = _userDetails.lastNameString;
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            doublecell.secondTextField.returnKeyType = UIReturnKeyNext;

            doublecell.firstTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            

            return doublecell;
        }
            break;
            
            
            
        case 1:
        {
            singlecell.singleTextField.tag = 102;
            singlecell.singleTextField.placeholder = @"STREET*";
            singlecell.singleTextField.text = _userDetails.streetString;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
         return singlecell;
        }
            break;
            
        case 2:
        {
            singlecell.singleTextField.tag = 103;
            singlecell.singleTextField.placeholder = @"STREET ADDRESS 2";
            singlecell.singleTextField.text = _userDetails.streetAddress2String;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return singlecell;
        }
            break;
            
        case 3:
        {
            doublecell.firstTextField.tag = 104;
            doublecell.secondTextField.tag = 105;
            doublecell.firstTextField.placeholder = @"COUNTRY*";
            doublecell.secondTextField.placeholder = @"STATE/PROVINCE*";
            doublecell.firstTextField.text = _userDetails.countryString;
            doublecell.secondTextField.text = _userDetails.stateString;
            
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            doublecell.secondTextField.returnKeyType = UIReturnKeyNext;
            
            doublecell.firstTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return doublecell;
            }
            break;
            
        case 4:
        {
            doublecell.firstTextField.tag = 106;
            doublecell.firstTextField.placeholder = @"CITY*";
             doublecell.firstTextField.text = _userDetails.cityString;
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            
            doublecell.secondTextField.tag = 107;
            doublecell.secondTextField.placeholder = @"ZIP*";
            doublecell.secondTextField.text = _userDetails.zipCodeString;
            doublecell.secondTextField.returnKeyType = UIReturnKeyDone;
            doublecell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
            return doublecell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mrk - Helper Method

- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(_userDetails.firstNameString) length]) {
        errorTag = 200;
        [AlertController customAlertMessage:@BLANK_FirstNAME];
        [self.tableView reloadData];
        return NO;
    }
    else if ([TRIM_SPACE(_userDetails.firstNameString) length] < 2) {
        errorTag = 200;
        [AlertController customAlertMessage:@Mini_FirstNAME];
        [self.tableView reloadData];
        return NO;
    }
    else if (![_userDetails.firstNameString isValidName]) {
        errorTag = 201;
        [AlertController customAlertMessage:@VALID_FirstNAME];
        [self.tableView reloadData];
        return NO;
    }else if (![TRIM_SPACE(_userDetails.lastNameString) length]) {
        errorTag = 201;
        [AlertController customAlertMessage:@BLANK_LastNAME];
        [self.tableView reloadData];
        return NO;
    }else if ([TRIM_SPACE(_userDetails.lastNameString) length] < 2) {
        errorTag = 201;
        [AlertController customAlertMessage:@Mini_LastNAME];
        [self.tableView reloadData];
        return NO;
    }else if (![_userDetails.lastNameString isValidName]) {
        errorTag = 201;
        [AlertController customAlertMessage:@VALID_LastNAME];
        [self.tableView reloadData];
        return NO;
    }
    else if (!([TRIM_SPACE(_userDetails.streetString) length] )) {
        errorTag = 202;
        [AlertController customAlertMessage:@STREET_ADDRESS];
           [self.tableView reloadData];
        return NO;
    } else if (!([TRIM_SPACE(_userDetails.cityString) length] )) {
        errorTag = 204;
        [AlertController customAlertMessage:@BLANK_CITY];
           [self.tableView reloadData];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.stateString) length] )) {
        errorTag = 205;
        [AlertController customAlertMessage:@BLANK_STATE];
        [self.tableView reloadData];
        return NO;
    }
    else if (!([TRIM_SPACE(_userDetails.countryString) length] )) {
        errorTag = 206;
        [AlertController customAlertMessage:@BLANK_COUNTRY];
        [self.tableView reloadData];
        return NO;
    }
    else if (!([TRIM_SPACE(_userDetails.zipCodeString) length] )) {
        errorTag = 207;
        [AlertController customAlertMessage:@BLANK_ZIP];
        [self.tableView reloadData];
        return NO;
    }
    else if (([TRIM_SPACE(_userDetails.zipCodeString) length] ) < 5) {
        errorTag = 207;
        [AlertController customAlertMessage:@Valid_ZIP];
        [self.tableView reloadData];
        return NO;
    }
    else {
        return YES;
    }
}


-(NSMutableAttributedString *)UnderLineTextString:(NSString *)str
                                        withStart:(NSUInteger)start andWithEnd:(NSUInteger)end{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [titleString addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:14] range:NSMakeRange(start, end)];// set your text lenght..
    
    return titleString;
}


#pragma mark - UITextField Delegate Methode

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            _userDetails.firstNameString = TRIM_SPACE(textField.text);
            break;
        case 101:
            _userDetails.lastNameString = TRIM_SPACE(textField.text);
            break;
        case 102:
            _userDetails.streetString = TRIM_SPACE(textField.text);
            break;
        case 103:
            _userDetails.streetAddress2String = TRIM_SPACE(textField.text);
            break;
        case 106:
            _userDetails.cityString = TRIM_SPACE(textField.text);
            break;
        case 107:
            _userDetails.zipCodeString = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TextField *txtField = (TextField *)textField;
    
    if (txtField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
        [KTextField(textField.tag+1) becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    if (textField.tag == 100)
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
    else if (textField.tag == 101)
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
    else if (textField.tag == 102)
        return ([textField.text length] > 70 && range.length == 0)? NO : YES;
    else if (textField.tag == 103)
        return ([textField.text length] > 40 && range.length == 0)? NO : YES;
    else if (textField.tag == 106)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 107)
        return ([textField.text length] > 10 && range.length == 0)? NO : YES;
    else
        return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 107) {
        [textField setInputAccessoryView:toolBarForNumberPad(self,@"Done")];
    }else {
        [textField setInputAccessoryView:nil];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
{
    [[TWMessageBarManager sharedInstance] hideAll];
        if(textField.tag == 104){
                [self.view endEditing:YES];
                [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:[self countryData] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
                    self.userDetails.countryString = [selectedValues firstObject];
                    UserInfo *obj = [countryListArray objectAtIndex:[[selectedIndexes firstObject] integerValue]];
                    self.userDetails.counrtyId = obj.counrtyId;
                    [self.tableView reloadData];
                }];
                return NO;
            }
        else if (textField.tag == 105){
                [self.view endEditing:YES];
            if (self.userDetails.counrtyId) {
                [self makeApiCallToGetStateList:self.userDetails.counrtyId];
            }
            else
                [AlertController customAlertMessage:@"Please select country first"];
                return NO;
            }
    }
    return YES;
}
-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
}

-(NSArray*)countryData{
    NSMutableArray *countryName = [[NSMutableArray alloc] init];
    if (countryListArray.count) {
        for (UserInfo *countryObj in countryListArray) {
            [countryName addObject:countryObj.countryISOName];
        }
        return countryName;
    }
    else
    {
        [countryName addObject:@"Select Country"];
        return countryName;
    }
}
-(NSArray*)stateData{
    NSMutableArray *stateName = [[NSMutableArray alloc] init];
    if (stateListArray.count) {
        for (UserInfo *stateNameObj in stateListArray) {
            [stateName addObject:stateNameObj.stateISOName];
        }
        return stateName;
    }
    else
    {
        [stateName addObject:@"Select State"];
        return stateName;
    }
}

#pragma mark - UIButton Action

- (IBAction)continueButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validateAndEnableLoginButton]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        for (int tag = 100; tag <= 107; tag++) {
            UITextField *text = (UITextField *)[self.view viewWithTag:tag];
            
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = [UIColor blackColor];
            text.borderColor = RGBCOLOR(181,181,181,1.0);
        }
        
        if (errorTag) {
            UITextField *text = (UITextField *)[self.view viewWithTag:errorTag-100];
            text.backgroundColor = RGBCOLOR(254,228,228,1.0);
            text.textColor = [UIColor redColor];
            text.borderColor = [UIColor redColor];
    }
    }
}
- (IBAction)commonShippingButtonAction:(UIButton *)sender {
    
    for (int tag = 10; tag<=30; tag++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        button.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)saveAddressButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self makeApiCallToSaveTheAddress];
    }
}

- (IBAction)collapseButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Web Service Method To Get Order

-(void)makeApiCallToSaveTheAddress{

    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *orderParam = [[NSMutableDictionary alloc]init];
     NSMutableDictionary *billingParam = [[NSMutableDictionary alloc]init];
     [billingParam setValue:[NSString stringWithFormat:@"%@ %@",_userDetails.firstNameString,_userDetails.lastNameString] forKey:@"full_name"];
    [billingParam setValue:_userDetails.firstNameString forKey:pFirstName];
     [billingParam setValue:_userDetails.lastNameString forKey:pLastName];
     [billingParam setValue:_userDetails.streetString forKey:pAddressOne];
     [billingParam setValue:_userDetails.streetAddress2String forKey:pAddressTwo];
     [billingParam setValue:_userDetails.cityString forKey:pCity];
     [billingParam setValue:self.userDetails.counrtyId forKey:pCountryId];
     [billingParam setValue:_userDetails.stateId forKey:pStateId];
     [billingParam setValue:_userDetails.zipCodeString forKey:pZipCode];
    [billingParam setValue:@"8285471477" forKey:@"phone"];

    
    [orderParam setObject:billingParam forKey:@"ship_address_attributes"];
    [orderParam setObject:billingParam forKey:@"bill_address_attributes"];
    
    [param setValue:[NSUSERDEFAULT valueForKey:@"OrderNumber"] forKey:pId];
    [param setObject:orderParam forKey:@"order"];
    [[ServiceHelper helper] request:param apiName:@"checkouts/delivery_or_reset_shipments" withToken:YES method:PATCH onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[countryListArray removeAllObjects];
            //countryListArray = [UserInfo parseDataForCountryList:[result objectForKeyNotNull:KCountry expectedObj:@""]];
        });
    }];
}

-(void)makeApiCallToGetCountryList{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"%@?per_page=250",KCountry]withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [countryListArray removeAllObjects];
            countryListArray = [UserInfo parseDataForCountryList:[result objectForKeyNotNull:KCountry expectedObj:@""]];
        });
    }];
}


-(void)makeApiCallToGetStateList:(NSString *)stateId{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"%@/%@",KCountry,stateId] withToken:NO method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [stateListArray removeAllObjects];
            stateListArray = [UserInfo parseDataForStateList:[result objectForKeyNotNull:@"states" expectedObj:@""]];
            [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:[self stateData] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
                self.userDetails.stateString = [selectedValues firstObject];
                UserInfo *obj = [stateListArray objectAtIndex:[[selectedIndexes firstObject] integerValue]];
                self.userDetails.stateId = obj.stateId;
                [self.tableView reloadData];
            }];
        });
    }];
}
@end
