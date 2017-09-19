//
//  TextField.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "TextField.h"
#import "Macro.h"

@interface TextField ()

@property (strong, nonatomic) UIImageView   *iconImageView;
@property (strong, nonatomic) UIView        *paddingView;
@property (strong, nonatomic) UIColor       *errorColor;
@property (strong, nonatomic) UIColor       *normalColor;
@property (strong, nonatomic) UIColor       *placeHolderColor;
@property (strong, nonatomic) CALayer       *underLine;

@end

@implementation TextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self defaultSetup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    
    if(self){
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y + 5,
                      bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

#pragma mark - Private methods

- (void)defaultSetup {
    
    self.errorColor = [UIColor redColor];
    self.normalColor = [UIColor lightGrayColor];
    self.placeHolderColor = [UIColor darkTextColor];

    self.tintColor = [UIColor whiteColor];
    
//    self.layer.cornerRadius = 0.0f;
//    self.layer.borderColor = [[UIColor clearColor] CGColor];
//    self.layer.borderWidth = 0.0f;
//    self.clipsToBounds = YES;
//    [self setBorderStyle:UITextBorderStyleNone];
    
    self.font = [AppUtility sofiaProLightFontWithSize:15.0f];
    [self placeHolderText:self.placeholder];
    
    [self addUnderline];
   
    self.active = NO;
    
    [self placeHolderText:self.placeholder];

}

- (void)addUnderline {
    
    CGFloat borderWidth = 1.0;
    
    if (!self.underLine) {
        self.underLine = [CALayer layer];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.underLine.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    });
    
    self.underLine.borderWidth = borderWidth;
    
    if (![self.layer.sublayers containsObject:self.underLine]) {
        [self.layer addSublayer:self.underLine];
        [self.layer setMasksToBounds:YES];
        self.underLine.borderColor = [self.normalColor CGColor];
    }
    
    self.active = NO;
}

- (void)removeUnderLine {
    [self.underLine removeFromSuperlayer];
}

- (void)addPaddingWithValue:(CGFloat )value {
    
    if (!self.paddingView) {
        self.paddingView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, value, self.frame.size.height)];
    } else {
        [self.paddingView setFrame:CGRectMake(8, 0, value, self.frame.size.height)];
    }
    [self setLeftView:self.paddingView];
    self.paddingView.tag = 998;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)addplaceHolderImageInsideView:(UIView *)view placeHolderImage:(UIImage *)image {

    if (!self.paddingView) {
        [self addPaddingWithValue:25];
        view = self.paddingView;
    }
    
    UIImageView *placeHolderImageView = [view viewWithTag:999];
    if (!placeHolderImageView) {
        placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        placeHolderImageView.tag = 999;
        placeHolderImageView.contentMode = UIViewContentModeCenter;
        [view addSubview:placeHolderImageView];
    }
    [placeHolderImageView setImage:image];
    placeHolderImageView.center = CGPointMake(view.frame.size.width  / 2,
                                              view.frame.size.height / 2);

    self.iconImageView = placeHolderImageView;
    
    self.active = NO;
}

- (void)setPlaceholderImage:(UIImage *)iconImage {
    if (iconImage) {
        [self setPaddingIcon:iconImage];
    }
}

#pragma mark - Public methods

- (void)setActive:(BOOL)active {
    
//    if (active) {
//        [self.iconImageView color:AppColor];
//        self.underLine.borderColor = [AppColor CGColor];
//        [self placeHolderTextWithColor:[self.attributedPlaceholder string] :AppColor];
//    } else {
//        [self.iconImageView color:self.normalColor];
//        self.underLine.borderColor = [self.normalColor CGColor];
//        [self placeHolderTextWithColor:[self.attributedPlaceholder string] :self.normalColor];
//    }
}

- (void)error:(BOOL)status {
    self.layer.borderColor = status ? [self.errorColor CGColor]:[self.normalColor CGColor];
}

- (void)setPaddingIcon:(UIImage *)iconImage {
    
    [self addplaceHolderImageInsideView:self.paddingView placeHolderImage:iconImage];
}
- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}

- (void)placeHolderText:(NSString *)text {
    
    if (text.length) {//for avoiding nil placehoder
        
        if (self.placeHolderColor) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: self.placeHolderColor}];
        } else {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        }
    }
}

- (void)placeHolderTextWithColor:(NSString *)text :(UIColor *)color {
    
    if (text.length) {//for avoiding nil placehoder
        
        if (color) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
        } else {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        }
    }
}

@end
