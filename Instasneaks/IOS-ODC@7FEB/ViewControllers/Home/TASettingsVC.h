//
//  TASettingsVC.h
//  Throne
//
//  Created by Anil Kumar on 02/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol navigationDelegateForSetting <NSObject>
- (void)manageTheNavigation;
@end

@interface TASettingsVC : UIViewController

@property (nonatomic, weak) id <navigationDelegateForSetting> delegateForSetting;

@end
