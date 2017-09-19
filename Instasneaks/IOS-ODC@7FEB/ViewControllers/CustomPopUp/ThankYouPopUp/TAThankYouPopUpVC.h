//
//  TAThankYouPopUpVC.h
//  Throne
//
//  Created by Priya Sharma on 07/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@protocol navigationDelegateForBuyProduct <NSObject>
-(void)manageTheNavigation;
@end
@interface TAThankYouPopUpVC : UIViewController
@property (nonatomic, weak) id <navigationDelegateForBuyProduct> delegateForProduct;
@property (strong, nonatomic) NSMutableDictionary    * productDetailsDic;
@end
