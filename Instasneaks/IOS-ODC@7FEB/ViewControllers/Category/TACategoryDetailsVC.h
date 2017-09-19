//
//  TACategoryDetailsVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 10/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TACategoryDetailsVC : UIViewController

@property(nonatomic,strong) NSString* navLblString;
@property (nonatomic, assign) BOOL isFromServiceListing;
@property(nonatomic,strong) NSString*  categoryId;

@end
