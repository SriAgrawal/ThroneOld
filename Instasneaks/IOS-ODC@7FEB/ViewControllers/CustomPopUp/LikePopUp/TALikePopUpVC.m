//
//  TALikePopUpVC.m
//  Throne
//
//  Created by Priya Sharma on 07/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TALikePopUpVC.h"

@interface TALikePopUpVC ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *likedopeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *followDopeButton;
@property (weak, nonatomic) IBOutlet UIImageView *followTip;
@property (weak, nonatomic) IBOutlet UIImageView *likeTip;
@property (weak, nonatomic) IBOutlet UIImageView *heatTip;

@end

@implementation TALikePopUpVC

#pragma mark - UIView Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:@"HERE'S SOME GOOD NEWS: WE STORE ALL OF YOUR LIKED ITEMS IN YOUR PROFILE. KEEP LIKING AS YOU EXPLORE, THEN GO TAKE A LOOK AT EVERYTHING YOU HAVE LIKED." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:10], NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    NSMutableAttributedString *followText = [[NSMutableAttributedString alloc] initWithString:@"HERE'S SOME GOOD NEWS: WE STORE ALL OF YOUR FOLLOWED BRANDS IN YOUR PROFILE. KEEP FOLLOWING AS YOU EXPLORE, THEN GO TAKE A LOOK AT EVERYTHING YOU HAVE FOLLOWED." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:10], NSForegroundColorAttributeName: [UIColor blackColor]}];
    
     NSMutableAttributedString *heatText = [[NSMutableAttributedString alloc] initWithString:@"WELCOME TO THE SNEAKERS PAGE, WE SHOW SOME MAJOR LOVE FOR THE STORES THAT ARE HAVING TRUE HEAT. THEY ARE OUR HOTTEST AND MOST VIEWED STORES AND WE THINK YOU’LL LOVE THEM AS MUCH AS US." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:10], NSForegroundColorAttributeName: [UIColor blackColor]}];

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [followText addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, [followText length])];
    
    [likeText addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [likeText length])];
    
    [heatText addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [heatText length])];


    if ([_isFrom isEqualToString:@"like"]) {
        _textLabel.attributedText = likeText;
        _titleLabel.text = @"THAT IS YOUR FIRST LIKE!";
        _followTip.hidden = YES;
        _heatTip.hidden = YES;
        _followDopeButton.hidden = YES;
    }
    if ([_isFrom isEqualToString:@"follow"]) {
        _textLabel.attributedText = followText;
        _titleLabel.text = @"THAT IS YOUR FIRST FOLLOW!";
        _likeTip.hidden = YES;
        _heatTip.hidden = YES;
        _likedopeButton.hidden = YES;

    }
    if ([_isFrom isEqualToString:@"heat"]) {
        _textLabel.attributedText = heatText;
        _titleLabel.text = @"THAT’S SOME HEAT";
        _textLabelHeightConstraint.constant = 60 ;
        _likeTip.hidden = YES;
        _followTip.hidden = YES;
        _followDopeButton.hidden = YES;
    }

}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton action

- (IBAction)crossButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

}

@end
