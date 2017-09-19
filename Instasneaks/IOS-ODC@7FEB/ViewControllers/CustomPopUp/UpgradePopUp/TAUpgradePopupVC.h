//
//  TAUpgradePopupVC.h
//  Throne
//
//  Created by Aman Goswami on 07/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TAUpgradePopupVCDelegate <NSObject>
-(void)dismissPopUp;
-(void)dismisPopUp;
@end
@interface TAUpgradePopupVC : UIViewController
@property (assign,nonatomic) id <TAUpgradePopupVCDelegate> popUp;
@property (nonatomic, assign) BOOL isfrom;
@end
