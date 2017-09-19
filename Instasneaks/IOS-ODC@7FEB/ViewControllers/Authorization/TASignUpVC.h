//
//  TASignUpVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 21/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol navigationDelegateForSignUp <NSObject>
- (void)manageTheNavigation:(UIViewController*)isFromViewController;
@end
@interface TASignUpVC : UIViewController

@property(assign, nonatomic) BOOL       isFromOnboard;

@property (nonatomic, weak) id <navigationDelegateForSignUp> delegateForSignUp;
@end
