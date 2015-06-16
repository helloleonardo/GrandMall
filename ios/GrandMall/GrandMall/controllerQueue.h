//
//  controllerQueue.h
//  EQ
//
//  Created by YangYuxin on 15/1/15.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "cellQueue.h"


@interface controllerQueue : UIViewController<UITableViewDataSource,UITableViewDelegate,QueueDelegate,apiDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTable;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (IBAction)queueOk:(id)sender;
- (IBAction)queueCancel:(id)sender;

@end
