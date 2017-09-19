//
//  TAThankYouPopUpVC.h
//  Throne
//
//  Created by Priya Sharma on 07/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@protocol navigationDelegateForThankUPopUP <NSObject>
-(void)manageTheNavigation;
@end

@interface TAThankYouPopUpRegisterVC : UIViewController
@property (nonatomic, weak) id <navigationDelegateForThankUPopUP> delegateForThankUPopUp;
@end
