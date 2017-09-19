//
//  TASkipLoginVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 17/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol navigationDelegateForSkipLogin <NSObject>
- (void)manageTheNavigationForSkip:(UIViewController*)isFromViewController;
@end
@interface TASkipLoginVC : UIViewController
@property(assign, nonatomic) BOOL       isFromOnboard;
@property (nonatomic, weak) id <navigationDelegateForSkipLogin> delegateForSkipLogin;
@end
