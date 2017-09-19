//
//  IndexPathButton.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexPathButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isRightSide;

+(IndexPathButton*) underlinedButton;
@end
