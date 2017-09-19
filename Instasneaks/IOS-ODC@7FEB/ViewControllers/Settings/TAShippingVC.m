//
//  TAShippingVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 08/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAShippingVC.h"
#import "Macro.h"

@interface TAShippingVC ()

@end

@implementation TAShippingVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapGestureMethod];
}

#pragma mark - UITableView Delegate and Datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 210.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAshippingMethodTVC *cell = (TAshippingMethodTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAshippingMethodTVC" forIndexPath:indexPath];
    [cell.addNewAddressButton addTarget:self action:@selector(addNewAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editAddressButton addTarget:self action:@selector(editAddressButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - IBActions Method

-(IBAction)minusButtonAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)upgradeButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addNewAddressButtonAction:(UIButton *)sender {
    TAAddAddressVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddAddressVC"];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}
- (void)editAddressButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAAddAddressVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddAddressVC"];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}
#pragma mark - Did Receive Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
