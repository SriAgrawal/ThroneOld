//
//  TAInviteFriendsVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 04/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAInviteFriendsVC.h"
#import "Macro.h"

@interface TAInviteFriendsVC ()
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchLeftContraints;
@property (weak, nonatomic) IBOutlet UILabel *inviteAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectedContactLbl;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;

@property (strong, nonatomic) KTSContactsManager        * contactsManager;
@property (strong, nonatomic) NSMutableArray            * contactsDataArray;
@property (strong, nonatomic) NSMutableArray            * searchedDataArray;
@property (strong, nonatomic) NSMutableArray            * dataSourceArray;
@property (strong, nonatomic) NSMutableArray            * phoneDataArray;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@property (nonatomic, assign) bool isFiltered;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraints;

@end

@implementation TAInviteFriendsVC

#pragma mark- UIView Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}
#pragma mark - Helper Methods

-(void)initialMethod{
    self.cancelBtn.hidden = YES;
    _phoneDataArray = [[NSMutableArray alloc] init];
    _dataSourceArray  = [[NSMutableArray alloc] init];
    
    self.inviteAmountLbl.attributedText = [self.inviteAmountLbl.text getAttributedString:self.inviteAmountLbl.text withColor:RGBCOLOR(182, 154, 92, 1.0f) withFont:[AppUtility sofiaProBoldFontWithSize:14]];
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    [self loadData];
    
    _searchView.layer.borderColor = [UIColor blackColor].CGColor;
    _searchView.layer.borderWidth = 1.0f;
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search your contacts" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.contactsDataArray = [NSMutableArray arrayWithArray:contacts];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             for (int i =0 ; i<self.contactsDataArray.count; i++)
             {
                 TAInviteFriendInfo *contactInfo = [[TAInviteFriendInfo alloc] init];
                 contactInfo.isSelected = NO;
                 NSDictionary *contact = [self.contactsDataArray objectAtIndex:i];
                 contactInfo.friendName = TRIM_SPACE([contact objectForKeyNotNull:@"name" expectedObj:@""]);
                 for (NSDictionary *dic in [contact objectForKeyNotNull:@"phones" expectedObj:[NSArray array]])
                 {
                     contactInfo.friendContactNumber = [dic objectForKeyNotNull:@"value" expectedObj:@""];
                     [_dataSourceArray addObject: contactInfo];
                     break;
                 }
             }
             
             [self.contactTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
         });
     }];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltered ? self.searchedDataArray.count : self.dataSourceArray.count);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAInviteFriendsTVC *cell = (TAInviteFriendsTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAInviteFriendsTVC"];
    TAInviteFriendInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.item];
    if (obj.isSelected) {
        [cell.checkBoxBtn setBackgroundColor:[UIColor blackColor]];
        [cell.checkBoxBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:228/255.0 blue:29/255.0 alpha:1.0] forState:UIControlStateNormal];
        cell.checkBoxBtn.selected = obj.isSelected;
    }
    else{
        [cell.checkBoxBtn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:228/255.0 blue:29/255.0 alpha:1.0]];
        [cell.checkBoxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cell.checkBoxBtn.selected = obj.isSelected;
    }
    [cell.seperatorLbl setHidden:YES];
    [cell.checkBoxBtn addTarget:self action:@selector(checkBoxButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.contactNameLbl.text = [obj.friendName length] ? obj.friendName : obj.friendContactNumber ;
    UIImage *image = obj.friendImage;
    cell.contactImageView.image = (image != nil) ? image : [UIImage imageNamed:@"ico_user"];
    
    //newly added code
    cell.boldNameBtn.layer.borderWidth = 2.0f;
    NSMutableArray* ar = [NSMutableArray array];
    [obj.friendName enumerateSubstringsInRange:NSMakeRange(0, [obj.friendName length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
        [ar addObject:[word substringToIndex:1]];
        if (ar.count == 2) {
            *stop = YES;
        }
    }];
    
    NSString * logoString = [ar componentsJoinedByString:@""];
    if ([logoString length])
        [cell.boldNameBtn setTitle:[logoString uppercaseString] forState:UIControlStateNormal];
    else
        [cell.boldNameBtn setTitle:@"NA" forState:UIControlStateNormal];

    
    return cell;
}
#pragma mark - TextField Delegates Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString1 = [searchStr componentsSeparatedByString:@"."];
    
    if ([arrayOfString1 count] > 1 )
        return NO;
    self.searchedDataArray = [[NSMutableArray alloc] init];
    self.isFiltered = YES;
    for (TAInviteFriendInfo* item in self.dataSourceArray)
    {
        //case insensative search - way cool
        if ([item.friendName rangeOfString:searchStr options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [self.searchedDataArray addObject:item];
        }

    }
    if ([searchStr isEqualToString:@""]) {
        self.searchedDataArray = self.dataSourceArray;
    }
    [self.contactTableView reloadData];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:3.0 animations:^{
        self.cancelBtn.hidden = NO;
        self.searchLeftContraints.constant = 75.0f;
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    self.cancelBtn.hidden = YES;
    self.searchLeftContraints.constant = 15;
    return YES;
}


#pragma mark- UIButton Action Method

- (IBAction)cancelButtonAction:(id)sender {
    
    self.isFiltered = NO;
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    self.cancelBtn.hidden = YES;
    self.searchLeftContraints.constant = 15;
    [self.contactTableView reloadData];
}

#pragma mark- UIButton Action Method
- (IBAction)selectAllAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"UNSELECT ALL"]) {
        for (TAInviteFriendInfo *contactInfo in _dataSourceArray)
        {
            contactInfo.isSelected = NO;
        }
        [_selectAllBtn setTitle:@"INVITE ALL" forState:UIControlStateNormal];
    }else{
        for (TAInviteFriendInfo *contactInfo in _dataSourceArray)
        {
            contactInfo.isSelected = YES;
        }
        [_selectAllBtn setTitle:@"UNSELECT ALL" forState:UIControlStateNormal];
    }
    
    [self.contactTableView reloadData];
}
- (IBAction)sendBtnAction:(id)sender {
    [self.phoneDataArray removeAllObjects];
    for (TAInviteFriendInfo *obj in self.dataSourceArray) {
        if (obj.isSelected) {
            if ([obj.friendContactNumber containsString:@"+"]== NO)
            {
                BDVCountryNameAndCode *bDVCountryNameAndCode = [[BDVCountryNameAndCode alloc] init];
                obj.friendContactNumber = [NSString stringWithFormat:@"+%@%@",[bDVCountryNameAndCode prefixForCurrentLocale],obj.friendContactNumber];
                [self.phoneDataArray addObject:obj.friendContactNumber];
            }
            [self.phoneDataArray addObject:obj.friendContactNumber];
        }
    }
}

-(void)checkBoxButtonAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    NSIndexPath * indexPath = [self.contactTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.contactTableView]];
    
    TAInviteFriendInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.item];
    obj.isSelected = !obj.isSelected;
    [self.contactTableView reloadData];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Memory Management Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
