//
//  TAProductDetailsVC.m
//  Throne
//
//  Created by Priya Sharma on 09/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPurchaseDetailsVC.h"
#import "TADiscountCell.h"
#import "TAServiceDeliveryCell.h"
#import "TASingleTextFieldTVC.h"
#import "TATwoTextFieldTVC.h"
#import "TABioVC.h"
#import "TACheckOutInfo.h"
#import "Macro.h"


static CGFloat purchaseViewHeight = 336;

@interface TAPurchaseDetailsVC ()<BTDropInViewControllerDelegate,navigationDelegateForBuyProduct,UITextFieldDelegate,UITableViewDataSource>
{
    BOOL tapped,continueTapped;
    TACheckOutInfo *orderInfo;
    int totalAmount;
}
@property (weak, nonatomic) IBOutlet UILabel *headerBottomFromLbl;

@property (weak, nonatomic) IBOutlet UILabel *headerBottomContentLbl;
@property (weak, nonatomic) IBOutlet UIView *dismissView;

- (IBAction)crossButtonAction:(UIButton *)sender;
- (IBAction)buyButtonAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton    *buyButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *descArray;
@property (strong, nonatomic) NSMutableArray *variantsArray;
@property (strong, nonatomic) NSMutableArray *checkOutArray;
@property (strong, nonatomic) IBOutlet UILabel *productLbl;
@property (nonatomic, strong) BTAPIClient *apiClient;

@end

@implementation TAPurchaseDetailsVC

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self tapGestureMethod];
}

#pragma mark - Initial Method

-(void)initialSetup{
    
    orderInfo = [[TACheckOutInfo alloc] init];
    totalAmount = 0.0;
    self.productLbl.text = self.productInfoObj.productName;
    [self.buyButton setTitle:[NSString stringWithFormat:@"%@ - BUY NOW",self.productInfoObj.productPrice] forState:UIControlStateNormal];

    [self.navigationController setNavigationBarHidden:YES];
    //Array initialization
    self.variantsArray = [[NSMutableArray alloc] initWithArray:self.productInfoObj.productVariantsArray];
    self.checkOutArray = [[NSMutableArray alloc]init];
    if (_isBuyForService) {
        self.titleArray = [[NSMutableArray alloc]init];
        for (NSString * title in @[@"AVAILABILITY",@"SERVICE DELIVERY",@"DISCOUNT",@"PAYMENT",@"TOTAL"]) {
            
            TAProductInfo *objExpand = [[TAProductInfo alloc] init];
            [objExpand setProductName:title];
            [self.titleArray addObject:objExpand];
        }

    }else{
        self.titleArray = [[NSMutableArray alloc]init];
        NSArray * sectionTitles = [NSArray arrayWithObjects:@"SIZE",@"SHIPPING",@"DISCOUNT",@"PAYMENT",@"TOTAL", nil];
        [sectionTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TAProductInfo *objExpand = [[TAProductInfo alloc] init];
            [objExpand setProductName:obj];
            [objExpand setIsEnabled:(idx == 0)];
            [self.titleArray addObject:objExpand];
        }];
    }
    self.descArray = [[NSMutableArray alloc]initWithObjects:@"MENS 10.5",@"1645 VINE ST. #808",@"",@"AMEX 1234",@"$490 (TAX + SHIPPING INCLUDED)",nil];
    
    tapped = NO;
    
    if(!_isBuyForService){
        [_headerBottomFromLbl setHidden:YES];
        [_headerBottomContentLbl setHidden:YES];
    }
  //[self makeApiCallToGetOrderDetail];
    [self fetchClientToken];
}


- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate And Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TAProductInfo *objExpand = [self.titleArray objectAtIndex:section];
    if (objExpand.isTapped) {
        
        if (_isBuyForService) {
            if (section == 0) {
                return 0;
            }
            if(section == 1){
                if (objExpand.isRemote) {
                    return 2;
                }else if(objExpand.isOnLocation){
                    return 6;
                }else{
                    return 1;
                }
            }else
                return 1;
        }
        else
        {
            return 1;
        }
    }else
    {
    return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TAProductDetailsTVC *cell = (TAProductDetailsTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAProductDetailsTVC"];
    TAProductInfo *objInfo = [self.titleArray objectAtIndex:section];

    [cell.titleLabel setText:objInfo.productName];

    [cell.expabdButton setTag:section+1000];
    [cell.expabdButton addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.expabdButton setSelected:objInfo.isTapped];
    
    [cell.expabdButton setUserInteractionEnabled:objInfo.isEnabled];
    cell.titleLabel.textColor = (objInfo.isEnabled ? RGBCOLOR(0, 0, 0, 1.0) : RGBCOLOR(181, 181, 181, 1.0));
    cell.descLabel.textColor = (objInfo.isEnabled ? RGBCOLOR(0, 0, 0, 1.0) : RGBCOLOR(181, 181, 181, 1.0));

    if (objInfo.isTapped) {
        [cell.descLabel setHidden:YES];
    }else{
        switch (section) {
            case 0:{
                TAProductInfo *sizeObj = [_variantsArray objectAtIndex:section];
                if (sizeObj.isTapped) {
                    [cell.descLabel setText:[[NSString stringWithFormat:@"%@ %@",self.productInfoObj.productGender,sizeObj.productSize ]uppercaseString]];
                }
            }
                break;
            case 1:{
            }
                break;
            case 2:{
            }
                break;
            case 3:{
   
            }
                break;
            case 4:{
                    [cell.descLabel setText:[NSString stringWithFormat:@"%d (TAX + SHIPPING INCLUDED)",totalAmount]];
            }
                break;
            default:
                break;
        }
        
    }
       return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!_isBuyForService){
            TASizeSelectionTVC *cell = (TASizeSelectionTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASizeSelectionTVC"];
            [cell.sizeCollectionView setTag:123456];
            return cell;
        }

    }
    
    if (indexPath.section == 1) {
        if (!_isBuyForService){
            TAshippingMethodTVC *cell = (TAshippingMethodTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAshippingMethodTVC"];
            
            cell.editAddressView.hidden = orderInfo.isEmptyAddress;
            
            
            cell.addressLabel.attributedText = [NSString customAttributeString:[[NSString stringWithFormat:@"%@, %@, %@ %@, %@",orderInfo.userInfo.streetAddress2String,orderInfo.userInfo.cityString,orderInfo.userInfo.stateString,orderInfo.userInfo.zipCodeString,orderInfo.userInfo.countryString] uppercaseString] withAlignment:NSTextAlignmentLeft withLineSpacing:6 withFont:[AppUtility sofiaProLightFontWithSize:14]];
            
            [cell.addNewAddressButton addTarget:self action:@selector(newAddressButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editAddressButton addTarget:self action:@selector(editAddressButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shippingMethodOne addTarget:self action:@selector(shippingMethodTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shippingMethodTwo addTarget:self action:@selector(shippingMethodTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shippingMethodThree addTarget:self action:@selector(shippingMethodTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.shippingMethodOne setAttributedTitle:[self UnderLineTextString:@"UPS GROUND (ARRIVES IN 5-7 DAYS) $15" withStart:0 andWithEnd:32] forState:UIControlStateNormal];
            [cell.shippingMethodTwo setAttributedTitle:[self UnderLineTextString:@"UPS TWO-DAY (ARRIVES IN 2-3 DAYS) $22" withStart:0 andWithEnd:34] forState:UIControlStateNormal];
            [cell.shippingMethodThree setAttributedTitle:[self UnderLineTextString:@"FEDEX NEXT DAY (ARRIVES IN 1-2 DAYS) $35" withStart:0 andWithEnd:37] forState:UIControlStateNormal];
            return cell;
        }else{
            switch (indexPath.row) {
                case 0:{
                    TAProductInfo *objExpand = [self.titleArray objectAtIndex:1];
                    
                    TAServiceDeliveryCell *cell = (TAServiceDeliveryCell *)[tableView dequeueReusableCellWithIdentifier:@"TAServiceDeliveryCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    cell.remoteImageView.tag = 9999;
                    cell.onLocationImageView.tag = 8888;
                    cell.emailTextField.delegate = self;
                    [cell.remoteBtn setTag:1000];
                    [cell.onLocationBtn setTag:1001];
                    
                    [cell.remoteImageView setImage:objExpand.isRemote?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
                    [cell.onLocationImageView setImage:objExpand.isOnLocation?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
                    
                    [cell.remoteBtn addTarget:self action:@selector(remoteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.onLocationBtn addTarget:self action:@selector(onLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.seperatorLabel setHidden:YES];
                    
                    return cell;
                }
                    break;
                case 1:{
                    TASingleTextFieldTVC *cell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    return cell;
                }
                    break;
                case 2:{
                    TASingleTextFieldTVC *cell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"STREET*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    return cell;
                }
                    break;
                case 3:{
                    TASingleTextFieldTVC *cell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"STREET ADDRESS 2" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    return cell;
                }
                    break;
                case 4:{
                    TATwoTextFieldTVC *cell = (TATwoTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATwoTextFieldTVC"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.firstTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CITY*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    cell.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"STATE*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    return cell;
                }
                    break;
                case 5:{
                    TATwoTextFieldTVC *cell = (TATwoTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATwoTextFieldTVC"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.firstTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"COUNTRY*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    cell.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"POSTAL CODE*" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }

    }
    if (indexPath.section == 2) {
        TADiscountCell *cell = (TADiscountCell *)[tableView dequeueReusableCellWithIdentifier:@"TADiscountCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.applyBtn addTarget:self action:@selector(applyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.walletCreditBtn addTarget:self action:@selector(walletCreditBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.enterPromocodeTextField.delegate = self;
        cell.enterPromocodeTextField.tag = 5000;
        cell.enterPromocodeTextField.text = orderInfo.discountCode;
        return cell;
        
    }
    
    if (indexPath.section == 3) {
        TAPaymentMethodTVC *cell = (TAPaymentMethodTVC *)[tableView dequeueReusableCellWithIdentifier:@"TAPaymentMethodTVC"];
        [cell.creditCardButton addTarget:self action:@selector(creditCardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.paypalButton addTarget:self action:@selector(payPalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.saveCardBtn addTarget:self action:@selector(savedCardBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.editButton addTarget:self action:@selector(editcreditCardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (tapped) {
            cell.creditCardViewHeightConstraint.constant = 99;
            cell.creditCardButtonTopConstraint.constant = 112;
            [cell.creditCardButton setTitle:@"ADD NEW CARD" forState:UIControlStateNormal];
            
        }
        else{
            cell.creditCardViewHeightConstraint.constant = 0;
            cell.creditCardButtonTopConstraint.constant = 15;
        }
        return cell;
    }
    
    if (indexPath.section == 4) {
        TATotalTVC *cell = (TATotalTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATotalTVC"];
        if ([orderInfo.promoCodeSuccess boolValue ]) {
            cell.discountAmtLbl.text = orderInfo.discountAmount;
        }
        cell.subTotalAmtLbl.text = orderInfo.orderPrice;
        cell.taxAmtLbl.text = orderInfo.taxAmount;
        cell.shippingLbl.text = orderInfo.shippingAmount;
        totalAmount = ([orderInfo.orderPrice intValue]+[orderInfo.taxAmount intValue]+ [orderInfo.shippingAmount intValue])- [orderInfo.discountAmount intValue];
        cell.totalAmtLbl.text = [NSString stringWithFormat:@"$%d",totalAmount];
        return cell;
    }
    return nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    TAProductInfo *objExpand = [self.titleArray objectAtIndex:section];

    if (section == 1) {
        if (_isBuyForService) {
            if (!objExpand.isTapped) {
                return 0.0;
            }else if (objExpand.isRemote || objExpand.isOnLocation) {
                return 40;
            }else{
                return 0.0;
            }
        }else{
            return 0;
        }
    }else{
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TAProductInfo *objExpand = [self.titleArray objectAtIndex:section];
    if (objExpand.isTapped) {
        if(section == 1){
            if (_isBuyForService) {
                if (objExpand.isRemote || objExpand.isOnLocation) {
                    UIView *baseView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
                    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 0.1, 150, 21)];
                    headerLabel.text = @"* MANDATORY";
                    headerLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
                    headerLabel.font = [AppUtility sofiaProLightFontWithSize:12];
                    headerLabel.backgroundColor = [UIColor clearColor];
                    [headerLabel setTextAlignment:NSTextAlignmentLeft];
                    [baseView addSubview:headerLabel];
                    return baseView;
                }else{
                    return nil;
                }

            }
            else{
                return nil;
            }

        }else
            return nil;
    }else
        return nil;


}

-(void)remoteBtnPressed:(UIButton *)sender{
    sender.selected = YES;
    UIImageView * remoteimg = (UIImageView *)[self.view viewWithTag:9999];
    UIImageView * onLocationimg = (UIImageView *)[self.view viewWithTag:8888];
    UIButton * location = (UIButton *)[self.view viewWithTag:1001];
    [location setSelected: NO];
    
    TAProductInfo *objExpand = [self.titleArray objectAtIndex:1];
    objExpand.isRemote = YES;
    objExpand.isOnLocation = NO;

    [remoteimg setImage:objExpand.isRemote?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
    [onLocationimg setImage:objExpand.isOnLocation?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
    [self.tableView reloadData];

}
-(void)onLocationPressed:(UIButton *)sender{
    sender.selected = YES;
    UIImageView * remoteimg = (UIImageView *)[self.view viewWithTag:9999];
    UIImageView * onLocationimg = (UIImageView *)[self.view viewWithTag:8888];
    UIButton * remote = (UIButton *)[self.view viewWithTag:1000];
    [remote setSelected: NO];

    TAProductInfo *objExpand = [self.titleArray objectAtIndex:1];
    objExpand.isRemote = NO;
    objExpand.isOnLocation = YES;
    
    [onLocationimg setImage:objExpand.isRemote?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
    [remoteimg setImage:objExpand.isOnLocation?[UIImage imageNamed:@"Shipping-Radio-Closed"]:[UIImage imageNamed:@"Shipping-Radio-Open"]];
    [self.tableView reloadData];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 120;
            break;
        case 1:{
            if (_isBuyForService) {
                TAProductInfo *objExpand = [self.titleArray objectAtIndex:1];
                switch (indexPath.row) {
                    case 0:
                        return 116;
                        break;
                    case 1:{
                        if (objExpand.isRemote) {
                            return 70;
                        }else if (objExpand.isOnLocation){
                            return 94;
                        }else{
                            return 0.0f;
                        }
                    }
                    default:
                        return  68;
                        break;
                }
            }else{
                return (orderInfo.isEmptyAddress)? 310 : 375;
            }
        }
            break;
        case 2:{
            return 182;
        }
            break;
        case 3:
            return (tapped ? 253 : 170);
            break;
        case 4:
            return 230;
            break;
        default:
            return  0;
            break;
    }
}


#pragma mark - CollectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _variantsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TASizeSelectionCell  *sizeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TASizeSelectionCell" forIndexPath:indexPath];
    TAProductInfo *sizeInfo = [self.variantsArray objectAtIndex:indexPath.item];
//    [sizeCell.sizeSelectionButton setBackgroundColor:(sizeInfo.isStock) ? [UIColor whiteColor] : [UIColor redColor]];
   
    [sizeCell.sizeSelectionButton setTitle:sizeInfo.productSize forState:UIControlStateNormal];
    sizeCell.sizeSelectionButton.tag = indexPath.item + 200;
    [sizeCell.sizeSelectionButton addTarget:self action:@selector(selectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sizeCell.leftConstraint setConstant:((indexPath.item%7 == 0) ? 1 : 0)];
    [sizeCell.topConstraint setConstant:((indexPath.item > 6) ? 0 : 1)];
    if (sizeInfo.isTapped) {
        sizeCell.sizeSelectionButton.layer.backgroundColor = [UIColor blackColor].CGColor;
        [sizeCell.sizeSelectionButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    }
    else{
        [sizeCell.sizeSelectionButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [sizeCell.sizeSelectionButton setBackgroundColor:[UIColor whiteColor]];
    }
    if (!sizeInfo.isStock) {
        [sizeCell.sizeSelectionButton setBackgroundColor:RGBCOLOR(181, 181, 181, 1.0f)];
        [sizeCell.sizeSelectionButton setUserInteractionEnabled:NO];
    }

    return sizeCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/7, 50);
}


#pragma mark - UITableView Selector Method
-(void)sectionButtonTapped:(UIButton*)sender{
    
    TAProductInfo *tap = [self.titleArray objectAtIndex:sender.tag%1000];
    if (tap.isTapped) {
        tap.isTapped = NO;
        
    }
    else{
        for (TAProductInfo *tap in self.titleArray) {
            tap.isTapped = NO;
        }
        tap.isTapped = YES ;
        continueTapped = NO;
    }
    CGFloat remainingHeight = (windowHeight - purchaseViewHeight)-20;
    if (tap.isTapped) {
        [_buyButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        if (_isBuyForService) {
            switch (sender.tag) {
                case 1000:{
                    tap.isTapped = NO;
                    [[TWMessageBarManager sharedInstance] hideAll];
                    TAAvailabilityVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAAvailabilityVC"];
                    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:obj animated:YES completion:nil];
                }
                    break;
                case 1001:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, (tapped ? 130 : 170));
                    break;
                case 1002:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, (tapped ? 253 : 170));
                    break;
                case 1003:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, 219);
                    break;
                default:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, 219);
                    break;
            }
        }
        else{
            
            switch (sender.tag) {
                case 1000:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, 120);
                    break;
                case 1001:
                    _viewHeightConstraint.constant = windowHeight;
                    break;
                case 1002:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, (tapped ? 253 : 170));
                    break;
                case 1003:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, 219);
                    break;
                default:
                    _viewHeightConstraint.constant = purchaseViewHeight + MIN(remainingHeight, 219);
                    break;
            }
        }
        
    }else{
        [self.buyButton setTitle:[NSString stringWithFormat:@"%@ - BUY NOW",self.productInfoObj.productPrice] forState:UIControlStateNormal];
        _viewHeightConstraint.constant = 389;
    }
    [self.tableView reloadData];

}

- (void)selectionButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAProductInfo *sizeInfo = [self.variantsArray objectAtIndex:sender.tag%200];
    if (sizeInfo.isTapped) {
        sizeInfo.isTapped = !sizeInfo.isTapped;
    }
    else{
        for (TAProductInfo *objInfo in self.variantsArray) {
            if (objInfo != sizeInfo) {
                objInfo.isTapped = NO;
            }
        }
        sizeInfo.isTapped = !sizeInfo.isTapped;
    }
    
    [(UICollectionView *)[self.view viewWithTag:123456] reloadData];
}

- (void)savedCardBtnTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    [_tableView reloadData];
}
- (void)newAddressButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAAddShippingAddressVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddShippingAddressVC"];
    obj.btitle = @"new";
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}

- (void)editAddressButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAAddShippingAddressVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddShippingAddressVC"];
    obj.btitle = @"edit";
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];

}

- (void)shippingMethodTapped:(UIButton*)sender {
    for (int tag = 10; tag<=30; tag = tag+10) {
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        button.selected = NO;
    }
    sender.selected = YES;
}

- (void)creditCardButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        tapped = YES;
        [self.tableView reloadData];
    }else{
        [[TWMessageBarManager sharedInstance] hideAll];
        TAAddCreditCardVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddCreditCardVC"];
        obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:obj animated:YES completion:nil];
    }
}

- (void)editcreditCardButtonTapped:(UIButton*)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    TAAddCreditCardVC *obj = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAAddCreditCardVC"];
    obj.btitle = @"edit";
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}

- (void)payPalButtonTapped:(UIButton*)sender {
    [self showDropIn];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 5000:
            orderInfo.discountCode = textField.text;
            
    }
}

#pragma mark - UIButton Action

- (IBAction)crossButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)buyButtonAction:(UIButton *)sender {
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([sender.titleLabel.text isEqualToString:@"CONTINUE"]){
        TAProductInfo *sizeObj = [self.variantsArray firstObject];
        if (sizeObj.isTapped){
            continueTapped = YES;
            [self makeApiCallToAddToCart:sizeObj.variantsId optionTypeId:sizeObj.optionId];
        }
        else
            [AlertController customAlertMessage:@"Please select at least one size."];
    }
    else
        [self showDropIn];
}

-(void)applyBtnPressed:(UIButton *)sender{
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([orderInfo.discountCode length]) {
        [self makeApiCallToPromoCode:orderInfo.discountCode];
    }
    else{
        [AlertController customAlertMessage:@"Please enter valid promo code."];
    }
}

-(void)walletCreditBtnPressed:(UIButton *)sender {
    orderInfo.discountCode = @"PROMO CODE";
    [self.tableView reloadData];
    
}
- (void)showDropIn {
    
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = @"THRONE";
    paymentRequest.summaryDescription = @"Quisque condimentum nisl id neque euismod, vel ornare lacus rhoncus. Vestibulum tincidunt augue et luctus varius. Phasellus lorem quam, luctus mollis euismod sit amet, luctus sed ante. Quisque luctus at quam non feugiat. Vivamus vitae euismod augue, sed molestie nisl. In luctus venenatis felis, vel suscipit massa rutrum eget. In a consectetur ligula. Quisque laoreet nunc ligula, eget rutrum libero feugiat vel. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus bibendum, ipsum in lacinia lacinia, turpis sapien malesuada nibh, eget";
    paymentRequest.displayAmount = @"$19.00";
    paymentRequest.callToActionText = @"$19 - Subscribe Now";
    paymentRequest.shouldHideCallToAction = NO;
    BTDropInViewController *dropIn = [[BTDropInViewController alloc] initWithAPIClient:self.apiClient];
    dropIn.delegate = self;
    dropIn.paymentRequest = paymentRequest;
    dropIn.title = @"Check Out";
    
    dropIn.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancel)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dropIn];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tappedCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Method


-(NSMutableAttributedString *)UnderLineTextString:(NSString *)str
                                        withStart:(NSUInteger)start andWithEnd:(NSUInteger)end{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [titleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SofiaProLight" size:14.0f] range:NSMakeRange(start, end)];// set your text lenght..
    return titleString;
}

#pragma mark - Web Service Method To Get Order

-(void)makeApiCallToGetOrderDetail{
    
    [[ServiceHelper helper] request:nil apiName:kOrders_Current withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
 
            orderInfo = [TACheckOutInfo parseOrderDetails:result];
    });
    }];
    
 
}

-(void)makeApiCallToAddToCart:(NSString *)varId optionTypeId:(NSString*)optionId{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"8" forKey:@"variant_id"];
    //[param setObject:varId forKey:@"variant_id"];
    
    [[ServiceHelper helper] request:param apiName:@"orders/populate" withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            orderInfo = [TACheckOutInfo parseOrderDetails:result];
            
            [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([(TAProductInfo *)obj isTapped]) {
                    [(TAProductInfo *)obj setIsTapped:NO];
                    if (idx<4) {
                        TAProductInfo * info = [self.titleArray objectAtIndex:idx+1];
                        info.isEnabled = YES;
                    }
                }
            }];
            [self.buyButton setTitle:[NSString stringWithFormat:@"%@ - BUY NOW",self.productInfoObj.productPrice] forState:UIControlStateNormal];
            _viewHeightConstraint.constant = 389;
            [self.tableView reloadData];
        });
    }];
    
}
-(void)makeApiCallToPromoCode:(NSString *)promoCode{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"PROMO" forKey:@"coupon_code"];
    //[param setObject:promoCode forKey:@"coupon_code"];
    [[ServiceHelper helper] request:param apiName:[NSString stringWithFormat:@"orders/%@/apply_coupon_code",orderInfo.orderNumber] withToken:YES method:PUT onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            orderInfo.promoCodeSuccess = [result objectForKeyNotNull:@"successful" expectedObj:@""];
        });
    }];
    
}

-(NSMutableArray *)parseCategoryListDataWithList:(NSArray *)categories{
    
    NSMutableArray * categoryData = [NSMutableArray array];
    
    for (NSDictionary * dict in categories) {
        TACategoryInfo * catInfo = [[TACategoryInfo alloc] init];
        [catInfo setCategoryId:[dict objectForKeyNotNull:pId expectedObj:0]];
        [catInfo setCategoryName:[[dict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [catInfo setCategoryDescription:[[dict objectForKeyNotNull:pDescription expectedObj:@""] uppercaseString]];
        [catInfo setCategoryImage:[dict objectForKeyNotNull:pCategoryUrl expectedObj:@""]];
        
        [categoryData addObject:catInfo];
    }
    
    return categoryData;
}


#pragma mark - BTDropInViewController Delegate
- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    [viewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Nonce-------%@", paymentMethodNonce.nonce);
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAThankYouPopUpVC *obj = [[TAThankYouPopUpVC alloc]initWithNibName:@"TAThankYouPopUpVC" bundle:nil];
        obj.delegateForProduct = self;
        obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
    }];
}

- (void)dropInViewControllerWillComplete:(__unused BTDropInViewController *)viewController {
    
        UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
        TAThankYouPopUpVC *obj = [[TAThankYouPopUpVC alloc]initWithNibName:@"TAThankYouPopUpVC" bundle:nil];
        obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        obj.delegateForProduct = self;
        [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchClientToken {
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.apiClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];

        // As an example, you may wish to present Drop-in at this point.
        // Continue to the next section to learn more...
    }] resume];
}

- (void)manageTheNavigation{
    [self dismissViewControllerAnimated:NO completion:^{
        if(self.delegateForProductDetails)
        {
            [_delegateForProductDetails manageTheNavigation];
        }
    }];
}


@end
