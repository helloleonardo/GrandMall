//
//  controllerMallInfo.h
//  EQ
//
//  Created by YangYuxin on 15/1/4.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface controllerMallInfo : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewInfo;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@end
