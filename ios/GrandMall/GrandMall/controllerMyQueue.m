//
//  controllerMyQueue.m
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerMyQueue.h"
#import "CellMyQueue.h"

@interface controllerMyQueue ()

@end

@implementation controllerMyQueue

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [API sharedInstance].delegate=self;
    [[API sharedInstance] getQueue:[[API sharedInstance].selfInfo valueForKey:@"customer_id"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)buttonRefresh:(id)sender {
    [[API sharedInstance] getQueue:[[API sharedInstance].selfInfo valueForKey:@"customer_id"]];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [API sharedInstance].queueArray.count;
}

-(void)addQueueSuccess:(NSInteger)row
{
    [self.table reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"cellmyqueue";
    UINib* nib = [UINib nibWithNibName:@"CellMyQueue" bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:TableSampleIdentifier];
    CellMyQueue *cell = [tableView dequeueReusableCellWithIdentifier:
                       TableSampleIdentifier];
    if (cell == nil) {
        cell = [[CellMyQueue alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSMutableDictionary* temp=([API sharedInstance].queueArray)[indexPath.row];
    NSLog(@"2...%@",temp);
    NSString* resName=[temp valueForKey:@"busi_name"];
    NSMutableDictionary* res=[[NSMutableDictionary alloc] init];
    NSMutableArray* mall=[API sharedInstance].mallInfo;
    for (int i=0; i<mall.count; i++) {
        NSString* a=[NSString stringWithFormat:@"%@",[mall[i] valueForKey:@"busi_name"]];
        if([a isEqualToString:resName])
            res=mall[i];
    }
    cell.labelName.text=[temp valueForKey:@"busi_name"];
    
    NSString* type;
    if ([[temp valueForKey:@"table_type"] intValue]==2) {
        type=@"A";
    }
    else if ([[temp valueForKey:@"table_type"] intValue]==4) {
        type=@"B";
    }
    else if ([[temp valueForKey:@"table_type"] intValue]==6) {
        type=@"C";
    }
    else if ([[temp valueForKey:@"table_type"] intValue]==8) {
        type=@"D";
    }
    cell.labelNumber.text=[NSString stringWithFormat:@"%@%@",type,[temp valueForKey:@"queue_order"]];
    int people=[[temp valueForKey:@"queue_startNumber"] intValue]-[[temp valueForKey:@"queue_nowNumber"] intValue];
    int num=[[temp valueForKey:@"queue_nowNumber"] intValue];
    NSString* mes;
    
    NSString* startString=[temp valueForKey:@"queue_time"];
    startString=[startString substringFromIndex:10];
    NSInteger startHour=[[startString substringToIndex:2] intValue];
    startString=[startString substringFromIndex:3];
    NSInteger startMinute=[[startString substringToIndex:2] intValue];
    
    NSDate* now=[[NSDate alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:now];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    if (num==1) {
        mes=@"您为当前第一位，请立即赶往餐厅。";
    }
    else if(people<2)
    {
        NSString* time;
        if ([[temp valueForKey:@"table_type"] isEqual:@"2"]) {
            time=[res valueForKey:@"table_type_2_wait"];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"4"]) {
            time=[res valueForKey:@"table_type_4_wait"];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"6"]) {
            time=[res valueForKey:@"table_type_6_wait"];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"8"]) {
            time=[res valueForKey:@"table_type_8_wait"];
        }
        NSInteger pos=num*[time intValue];
        mes=[NSString stringWithFormat:@"%ld分钟",(long)pos];
    
    }
    else
    {
        double v=(hour*60+minute-startHour*60-startMinute)/(double)people;
        int number=v*num;
        if (number==0) {
            number=1;
        }
        mes=[NSString stringWithFormat:@"%d分钟",number];

    }
    cell.labelTime.text=mes;
    cell.labelPosition.text=[NSString stringWithFormat:@"第%d位",[[temp valueForKey:@"queue_nowNumber"] intValue]];
    cell.static1.hidden=false;
    
    return cell;
    
}
@end
