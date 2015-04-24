//
//  controllerResDetail.h
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface controllerResDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *avg;
@property (weak, nonatomic) IBOutlet UILabel *lowest;
- (IBAction)back:(id)sender;

@end
