//
//  controllerRegister.h
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface controllerRegister : UIViewController<apiDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textPwd;
@property (weak, nonatomic) IBOutlet UIPickerView *pickGender;

- (IBAction)buttonBack:(id)sender;
- (IBAction)buttonOk:(id)sender;

@end
