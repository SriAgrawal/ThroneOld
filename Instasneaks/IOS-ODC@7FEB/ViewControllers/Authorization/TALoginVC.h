//
//  TALoginVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 20/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol navigationDelegateForLogin <NSObject>
- (void)manageTheNavigation:(UIViewController*)isFromViewController;
@end
@interface TALoginVC : UIViewController

@property(assign, nonatomic) BOOL       isFromOnboard;
@property (nonatomic, weak) id <navigationDelegateForLogin> delegateForLogin;

@end
