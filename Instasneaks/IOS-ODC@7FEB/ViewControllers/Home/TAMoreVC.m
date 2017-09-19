//
//  TAMoreVC.m
//  Throne
//
//  Created by Aman Goswami on 17/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAMoreVC.h"
#import "TAMoreTVCell.h"
#import "Macro.h"

@interface TAMoreVC ()<UITableViewDelegate,UITableViewDataSource,TAThanksVCDelgate> {
    BOOL  isFrom;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TAMoreVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    isFrom = NO;
}

#pragma mark - UITableView Delegate and Datasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAMoreTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAMoreTVCell" forIndexPath:indexPath];
    [cell.crossBtnOutlet addTarget:self action:@selector(cellCrossBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (isFrom  == YES) {
        cell.thanksView.hidden = NO;
    } else {
        cell.thanksView.hidden = YES;
    }
    return  cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAThanksVC *obj = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAThanksVC"];
    obj.thanksDelegate = self;
    obj.productId = self.productId;
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:obj animated:YES completion:nil];
}

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cellCrossBtn:(id)sender {
    isFrom = NO;
    [self.tableView reloadData];
}

#pragma mark - Back Delegate.
-(void) dismissPopUp {
    isFrom = YES;
    [self.tableView reloadData];
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
