//
//  controllerSelfInfo.h
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface controllerSelfInfo : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *textPhone;
- (IBAction)buttonSignOut:(id)sender;

@end
