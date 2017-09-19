//
//  TAAvailabilityVC.m
//  Throne
//
//  Created by Suresh patel on 02/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "Macro.h"

@interface TAAvailabilityVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView     * availableCollectionView;

@property (strong, nonatomic) NSMutableArray                * daysDataArray;
@property (strong, nonatomic) NSString                      * currentDay;

@end

@implementation TAAvailabilityVC

#pragma mark- Life Cycle of View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];
    // Do any additional setup after loading the view.
}

#pragma mark- Helper Method

-(void)setUpDefaults{
    self.daysDataArray = [NSMutableArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    NSDateFormatter* day = [[NSDateFormatter alloc] init];
    [day setDateFormat: @"EEE"];
    self.currentDay = [day stringFromDate:[NSDate date]];
    NSLog(@"the day is: %@", [day stringFromDate:[NSDate date]]);
    [self.availableCollectionView setBackgroundColor:RGBCOLOR(231.0, 231.0, 231.0, 1.0f)];
}


#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 98;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TAAvailableCollectionCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAAvailableCollectionCell" forIndexPath:indexPath];
    NSInteger index = [self.daysDataArray indexOfObject:self.currentDay];
    if (indexPath.item%7 == index) {
        [cell setBackgroundColor:[UIColor blackColor]];
        [cell.timeLbl setTextColor:[UIColor whiteColor]];
    }
    else if (indexPath.item%7 == 5){
        [cell setBackgroundColor:RGBCOLOR(231.0, 231.0, 231.0, 1.0f)];
        [cell.timeLbl setTextColor:RGBCOLOR(181.0, 181.0, 181.0, 1.0f)];
    }
    else{
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.timeLbl setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width - 8)/7, collectionView.frame.size.width/7);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - IBAction Method

-(IBAction)minusButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Handling the memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
