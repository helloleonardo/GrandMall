//
//  controllerSelfInfo.m
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerSelfInfo.h"


@interface controllerSelfInfo ()

@end

@implementation controllerSelfInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* name=[NSString stringWithFormat:@"%@",[[API sharedInstance].selfInfo valueForKey:@"customer_name"]];
    name=[name stringByAppendingString:[NSString stringWithFormat:@"%@",[[API sharedInstance].selfInfo valueForKey:@"customer_gender"]]];
    self.textName.text=name;
    self.textPhone.text=[[API sharedInstance].selfInfo valueForKey:@"customer_phone" ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonSignOut:(id)sender {
    if([API sharedInstance].isLogin)
    {
        [API sharedInstance].isLogin=false;
        id temp=self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            
            [temp dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
