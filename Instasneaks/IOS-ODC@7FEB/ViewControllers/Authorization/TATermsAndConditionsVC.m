//
//  TATermsAndConditionsVC.m
//  Throne
//
//  Created by Suresh patel on 04/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATermsAndConditionsVC.h"
#import "Macro.h"

@interface TATermsAndConditionsVC ()

@property (weak, nonatomic) IBOutlet UIWebView      * termsWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelHeightConstarint;

@end

@implementation TATermsAndConditionsVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];
    // Do any additional setup after loading the view.
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    
    [self.termsWebView setScalesPageToFit:YES];
    [self.topLabelHeightConstarint setConstant:0.5];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TermsOfUse" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.termsWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
