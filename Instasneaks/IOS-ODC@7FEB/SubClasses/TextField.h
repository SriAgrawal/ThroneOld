//
//  TextField.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextField : UITextField

@property (nonatomic, setter=setPaddingValue:) IBInspectable NSInteger paddingValue;
@property (nonatomic, strong) IBInspectable UIImage *paddingIcon;

@property (strong, nonatomic) NSIndexPath *indexPath; // use if cell for getting easily the cell & txtfield

- (void)placeHolderText:(NSString *)text;
- (void)placeHolderTextWithColor:(NSString *)text :(UIColor *)color;
- (void)setPlaceholderImage:(UIImage *)iconImage;
- (void)error:(BOOL)status;

@property (assign, nonatomic) BOOL active;

- (void)removeUnderLine;

@end