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
    NSMutableArray* temp=([API sharedInstance].mallInfo)[[API sharedInstance].row];
    NSString* tempURL=[NSString stringWithFormat:@"http://%@:9993/%@",[API sharedInstance].IP,temp[4]];
    [self.img setImageWithURL:[NSURL URLWithString:tempURL]];
    self.name.text=temp[3];
    self.phone.text=temp[5];
    self.info.text=temp[7];
    self.avg.text=temp[8];
    self.lowest.text=temp[9];
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
