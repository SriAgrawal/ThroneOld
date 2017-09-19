//
//  TAMyWalletVC.m
//  Throne
//
//  Created by Krati Agarwal on 03/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAMyWalletVC.h"
#import "Macro.h"

@interface TAMyWalletVC ()<FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel    *promoCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMessageLbl;
@property (weak, nonatomic) IBOutlet UILabel *creditLbl;

@property (strong, nonatomic) NSArray           *myWalletTitleArray;
@property (strong, nonatomic) NSArray           *myWalletTitleImageeArray;

@end

@implementation TAMyWalletVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self makeApiCallToGetWalletDetails];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    self.myWalletTitleArray = @[@"TEXT", @"FACEBOOK", @"TWITTER", @"EMAIL", @"COPY SHARE LINK"];
    self.myWalletTitleImageeArray = @[@"phone", @"facebook", @"twitter", @"email-gi", @"paperclip"];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.walletMessageLbl.text];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentCenter;
    [pStyle setLineSpacing:8];
    [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:12] range:NSMakeRange(0, [self.walletMessageLbl.text length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [self.walletMessageLbl.text length])];
    self.walletMessageLbl.attributedText =  string;
    [_promoCodeLabel setUserInteractionEnabled:YES];
    
    //Layout adjust
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
}
- (void)manageSpaceInPromoCode:(NSString *)promoTest {
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:promoTest];
    [attrStr addAttribute:NSKernAttributeName value:@(10.0) range:NSMakeRange(0, attrStr.length)];
    
    self.promoCodeLabel.attributedText = attrStr;
}

- (void)copyText:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        UIMenuController *copyMenu = [UIMenuController sharedMenuController];
        [copyMenu setTargetRect:self.promoCodeLabel.bounds inView:self.promoCodeLabel];
        copyMenu.arrowDirection = UIMenuControllerArrowDefault;
        [copyMenu setMenuVisible:YES animated:YES];
    }
}
#pragma mark- UIButton Action Method

- (IBAction)crossButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate and Datasource Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myWalletTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *walletCellID = @"TAMyWalletCell";
    
    TAMyWalletTableCell *walletCell = (TAMyWalletTableCell *)[tableView dequeueReusableCellWithIdentifier:walletCellID forIndexPath:indexPath];
    
    walletCell.titleLabel.text = [self.myWalletTitleArray objectAtIndex:indexPath.row];
    walletCell.titleIconIageView.image = [UIImage imageNamed:[self.myWalletTitleImageeArray objectAtIndex:indexPath.row]];
    
    
    return walletCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            // uncommented code
            TAInviteFriendsVC *inviteFrnds = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAInviteFriendsVC"];
            [self.navigationController pushViewController:inviteFrnds animated:YES];
        }
            break;
        case 1:
        {
            [self inviteFacebook];
        }
            break;
        case 2:
        {
            [self shareOnTwitter];
        }
            break;
        case 3:
        {
            [self showMail];
        }
            break;
        case 4:
        {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:[NSString stringWithFormat:@"https://throne1.app.link/profile"]];
            [AlertController message:@"Link copied" onViewController:self];
        }
            break;
        default:
            break;
    }
}
#pragma mark - CustomMethod


- (void)inviteFacebook{
    
    FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1818178491739030"];
    //optionally set previewImageURL
    //content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
    [FBSDKAppInviteDialog  showFromViewController:self withContent:content delegate:self];
}
-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"Error");
    
}
-(void)shareOnTwitter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"https://throne1.app.link/profile"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    });
}
//Body of Mail
- (void)showMail
{
    if(![MFMailComposeViewController canSendMail]) {
        [AlertController title:@"Error" message:@"Your device doesn't support Mail!" onViewController:self];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message =[NSString stringWithFormat:@"https://throne1.app.link/profile"];
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:recipents];
    [mailController setSubject:@"THRONE APP"];
    [mailController setMessageBody:message isHTML:YES];
    
    // Present message view controller on screen
    [self presentViewController:mailController animated:YES completion:nil];
}
#pragma mark - MFMessageComposeViewControllerDelegate delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send Mail!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MFMailComposeResultSaved:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Mail Saved!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MFMailComposeResultSent:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail Send!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
            
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Web Api Method Integration


-(void)makeApiCallToGetWalletDetails{
    
    [[ServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"users/%@/wallet",[NSUSERDEFAULT objectForKey:pUserId]] withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.creditLbl.text = [result objectForKeyNotNull:pCredits expectedObj:@""];
            [self manageSpaceInPromoCode:[result objectForKeyNotNull:pPromoCode expectedObj:@""]];
            
        });
    }];
}

@end
