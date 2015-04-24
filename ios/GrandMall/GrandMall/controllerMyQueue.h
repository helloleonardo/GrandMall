//
//  controllerMyQueue.h
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface controllerMyQueue : UIViewController<UITableViewDataSource,UITableViewDelegate,apiDelegate>
- (IBAction)buttonRefresh:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
