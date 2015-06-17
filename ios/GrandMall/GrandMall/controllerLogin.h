//
//  controllerLogin.h
//  EQ
//
//  Created by YangYuxin on 14/12/30.
//  Copyright (c) 2014年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface controllerLogin : UITableViewController<apiDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UIView *viewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UIButton *buttonReg;
@property (weak, nonatomic) IBOutlet UITextField *textPwd;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIView *viewPhoneTrue;
@property (weak, nonatomic) IBOutlet UIView *viewPwdTrue;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoginTrue;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegTrue;
- (IBAction)buttonLoginDown:(id)sender;
- (IBAction)buttonRegDown:(id)sender;

@end
