//
//  TAProductDetailsVC.h
//  Throne
//
//  Created by Priya Sharma on 09/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@class TAProductInfo;
@protocol navigationDelegateForProductDetails <NSObject>
-(void)manageTheNavigation;
@end
@interface TAPurchaseDetailsVC : UIViewController
@property (nonatomic, weak) id <navigationDelegateForProductDetails> delegateForProductDetails;
@property (assign, nonatomic) BOOL isBuyForService;
@property (nonatomic ,strong) TAProductInfo* productInfoObj;
@end
