//
//  TAThanksVC.m
//  Throne
//
//  Created by Aman Goswami on 17/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAThanksVC.h"
#import "Macro.h"

@interface TAThanksVC ()

@end

@implementation TAThanksVC
#pragma mark - View life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action.
- (IBAction)yesBtnAction:(id)sender {
    
    [self makeApiCallToFlagProductWithId:self.productId];
}
- (IBAction)noBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark-Web Api Method Integration

-(void)makeApiCallToFlagProductWithId:(NSString *)productId {
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"products/%@/flags", productId] withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self && self.thanksDelegate && [self.thanksDelegate respondsToSelector:@selector(dismissPopUp)]) {
                    [self.thanksDelegate dismissPopUp];
                }
            }];

        });
    }];
}

@end
