//
//  TAThanksVC.h
//  Throne
//
//  Created by Aman Goswami on 17/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TAThanksVCDelgate <NSObject>
-(void) dismissPopUp;
@end
@interface TAThanksVC : UIViewController
@property (assign , nonatomic) id<TAThanksVCDelgate> thanksDelegate;
@property (strong , nonatomic) NSString         *productId;

@end
