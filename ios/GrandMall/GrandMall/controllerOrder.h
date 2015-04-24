//
//  controllerOrder.h
//  EQ
//
//  Created by YangYuxin on 15/1/17.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellOrder.h"
#import "API.h"

@interface controllerOrder : UIViewController<UITableViewDelegate,UITableViewDataSource,OrderDelegate,UIPickerViewDataSource,UIPickerViewDelegate,apiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *viewBack;
@property (weak, nonatomic) IBOutlet UIView *imgBack;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTable;
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)sure:(id)sender;
- (IBAction)nvd:(id)sender;

@end
