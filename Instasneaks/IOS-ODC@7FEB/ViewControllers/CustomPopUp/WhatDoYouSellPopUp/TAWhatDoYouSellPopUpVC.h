//
//  TAWhatDoYouSellPopUpVC.h
//  Throne
//
//  Created by Anil Kumar on 22/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sendOTP <NSObject>

@optional

-(void)dismissView ;
-(void)dismissViewWithData:(NSMutableArray *)selectedObj dataType:(NSString *)type;

@end
@interface TAWhatDoYouSellPopUpVC : UIViewController
@property (nonatomic,retain) id delegate;
@property(strong,nonatomic)NSString * selectedString;
@property(strong,nonatomic)NSString * dataType;
@property(strong,nonatomic)NSMutableArray * arrayOfcategory;

@end
