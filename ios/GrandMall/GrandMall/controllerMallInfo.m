//
//  controllerMallInfo.m
//  EQ
//
//  Created by YangYuxin on 15/1/4.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerMallInfo.h"

@interface controllerMallInfo ()

@end

@implementation controllerMallInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollViewInfo.contentSize=CGSizeMake(1280, 0);
    self.scrollViewInfo.delegate=self;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page=scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageController.currentPage=page;
}


@end
