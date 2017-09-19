//
//  TAFeedbackVC.m
//  Throne
//
//  Created by Aman Goswami on 21/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAFeedbackVC.h"
#import "TAFeedbackThanksVC.h"
#import "Macro.h"

@interface TAFeedbackVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *itemRatingView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *storeRatingView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;

@end

@implementation TAFeedbackVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setUpView{
    _storeRatingView.allowsHalfStars = NO;
     self.feedbackLabel.attributedText = [NSString customAttributeString:self.feedbackLabel.text withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProLightFontWithSize:14]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeApiCallToRateVendorAfterDelay) name:@"callApiToRate" object:nil];
}

#pragma mark - Button Action.

- (IBAction)rateTransactionBtnAction:(id)sender {
    TAFeedbackThanksVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAFeedbackThanksVC"];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:obj animated:YES completion:nil];
    
}

- (IBAction)walletBtnAction:(id)sender {
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeApiCallToRateVendorAfterDelay{
    [self performSelector:@selector(makeApiCallToRateVendor) withObject:nil afterDelay:0.5];
}
-(void)makeApiCallToRateVendor{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:pVendor_id];
    [param setValue:[NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%f",_storeRatingView.value] intValue]] forKey:pRate];
 
    [[ServiceHelper helper] request:param apiName:kVendors_rates withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        NSLog(@"-----------%@",result);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            TAStoreInfo *obj = [self.storeArray objectAtIndex:indexpath.row];
//            obj.isFollow = !obj.isFollow;
//            if (![NSUSERDEFAULT boolForKey:pIsFirstFollow]) {
//                [NSUSERDEFAULT setBool:YES forKey:pIsFirstFollow];
//                
//                UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
//                TALikePopUpVC *obj = [[TALikePopUpVC alloc]initWithNibName:@"TALikePopUpVC" bundle:nil];
//                obj.isFrom = @"follow";
//                obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//                [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//                [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
//            }
//            if (_layoutSet == List)
//                [self.homeTableView reloadData];
//            else
//                [(UICollectionView *)[self.view viewWithTag:3000] reloadData];
//        });
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
