//
//  controllerResDetail.m
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerResDetail.h"
#import "API.h"
#import "UIImageView+AFNetworking.h"


@interface controllerResDetail ()

@end

@implementation controllerResDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary* temp=([API sharedInstance].mallInfo)[[API sharedInstance].row];
    NSString* tempURL=[NSString stringWithFormat:@"http://%@/%@",[API sharedInstance].IP,[temp valueForKey:@"busi_pic"]];
    [self.img setImageWithURL:[NSURL URLWithString:tempURL]];
    self.name.text=[temp valueForKey:@"busi_name"];
    self.phone.text=[temp valueForKey:@"busi_tel"];
    self.info.text=[temp valueForKey:@"busi_intro"];
    self.avg.text=[temp valueForKey:@"busi_avgCost"];
    self.lowest.text=[temp valueForKey:@"busi_minCost"];
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
