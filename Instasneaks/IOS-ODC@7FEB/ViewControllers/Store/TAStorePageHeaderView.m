//
//  TAStorePageHeaderView.m
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAStorePageHeaderView.h"

@implementation TAStorePageHeaderView


+ (instancetype)instantiateFromNib {
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.moreInfoPlusButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.moreInfoPlusButton.layer.borderWidth = 1.0f;
    self.heatIndexLabel.attributedText = [NSString setSuperScriptText:self.heatIndexLabel.text withFont:[AppUtility sofiaProBoldFontWithSize:12] withBaseLineOffset:@"3"];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.othersWithHeatIndexTMLabel.text
//                                                                                         attributes:@{NSFontAttributeName:[AppUtility sofiaProBoldFontWithSize:12]}];
//    [attributedString setAttributes:@{NSFontAttributeName :[AppUtility sofiaProBoldFontWithSize:7]
//                                      , NSBaselineOffsetAttributeName : @"3"} range:NSMakeRange(22, 2)];
//    self.othersWithHeatIndexTMLabel.attributedText = attributedString;
    // Initialization code
}


@end
