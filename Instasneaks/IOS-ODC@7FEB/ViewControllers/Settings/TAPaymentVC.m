//
//  TAPaymentVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 08/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPaymentVC.h"
#import "Macro.h"
@interface TAPaymentVC ()<BTDropInViewControllerDelegate>
@property (nonatomic, strong) BTAPIClient *apiClient;

@end

@implementation TAPaymentVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapGestureMethod];
}

#pragma mark - Helper Methods
- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - IBActions Method

-(IBAction)minusButtonAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)upgradeButtonAction:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboard {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate and Datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 261.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAPaymentMethodTVC *cell = (TAPaymentMethodTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAPaymentMethodTVC" forIndexPath:indexPath];
    [cell.creditCardButton addTarget:self action:@selector(creditCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editCardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
      [cell.paypalButton addTarget:self action:@selector(payPalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//PayPal Method
- (void)payPalButtonTapped:(UIButton *)sender {
        [self fetchClientToken];
        [self showDropIn];
}
- (void)creditCardButtonAction:(UIButton *)sender {
    TACreditCardVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TACreditCardVC"];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}
- (void)editCardButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TACreditCardVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TACreditCardVC"];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}
- (void)showDropIn {
    
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = @"THRONE";
    paymentRequest.summaryDescription = @"Quisque condimentum nisl id neque euismod, vel ornare lacus rhoncus. Vestibulum tincidunt augue et luctus varius. Phasellus lorem quam, luctus mollis euismod sit amet, luctus sed ante. Quisque luctus at quam non feugiat. Vivamus vitae euismod augue, sed molestie nisl. In luctus venenatis felis, vel suscipit massa rutrum eget. In a consectetur ligula. Quisque laoreet nunc ligula, eget rutrum libero feugiat vel. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus bibendum, ipsum in lacinia lacinia, turpis sapien malesuada nibh, eget";
    paymentRequest.displayAmount = @"$19.00";
    paymentRequest.callToActionText = @"$19 - Subscribe Now";
    paymentRequest.shouldHideCallToAction = NO;
    BTDropInViewController *dropIn = [[BTDropInViewController alloc] initWithAPIClient:self.apiClient];
    dropIn.delegate = self;
    dropIn.paymentRequest = paymentRequest;
    dropIn.title = @"Check Out";
    
    dropIn.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancel)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dropIn];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tappedCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BTDropInViewController Delegate
- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    [viewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Nonce-------%@", paymentMethodNonce.nonce);
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAThankYouPopUpVC *obj = [[TAThankYouPopUpVC alloc]initWithNibName:@"TAThankYouPopUpVC" bundle:nil];
        obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
    }];
}
- (void)dropInViewControllerWillComplete:(__unused BTDropInViewController *)viewController {
    
    UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAThankYouPopUpVC *obj = [[TAThankYouPopUpVC alloc]initWithNibName:@"TAThankYouPopUpVC" bundle:nil];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)fetchClientToken {
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.apiClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    }] resume];
}
#pragma mark - Did Receive Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
