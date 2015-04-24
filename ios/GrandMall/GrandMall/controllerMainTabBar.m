//
//  controllerMainTabBar.m
//  EQ
//
//  Created by YangYuxin on 15/1/3.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerMainTabBar.h"

@interface controllerMainTabBar ()

@end

@implementation controllerMainTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mall_1"]];
    UITabBarItem* temp0=[self.tabBar.items objectAtIndex:0];
    temp0.selectedImage=[[UIImage imageNamed:@"mall_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [temp0 setImageInsets:UIEdgeInsetsMake(5, 0.0, -6, 0.0)];
    
    [[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"cam_1"]];
    UITabBarItem* temp1=[self.tabBar.items objectAtIndex:1];
    temp1.selectedImage=[[UIImage imageNamed:@"cam_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [temp1 setImageInsets:UIEdgeInsetsMake(5, 0.0, -6, 0.0)];
    
    [[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"profile_1"]];
    UITabBarItem* temp2=[self.tabBar.items objectAtIndex:2];
    temp2.selectedImage=[[UIImage imageNamed:@"profile_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [temp2 setImageInsets:UIEdgeInsetsMake(5, 0.0, -6, 0.0)];
    
    self.tabBar.backgroundImage=[UIImage imageNamed:@"btmbar"];

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

@end
