//
//  TAFilterServiceVC.h
//  Throne
//
//  Created by Anil Kumar on 27/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol navigationDelegateForFilterService <NSObject>
- (void)manageTheNavigation:(NSMutableArray*)arrayForFilterObj;
@end

@interface TAFilterServiceVC : UIViewController
@property (nonatomic, weak) id <navigationDelegateForFilterService> delegateForFilter;
@property (assign, nonatomic) BOOL isFromHome;
@end
