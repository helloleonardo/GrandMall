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
    [[API sharedInstance] searchQueue:[API sharedInstance].cus];
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
    
    NSMutableDictionary* tempnow=([API sharedInstance].nowQueueArray)[indexPath.row];
    NSLog(@"1...%@",tempnow);
    NSMutableDictionary* temp=([API sharedInstance].queueArray)[indexPath.row];
    NSLog(@"2...%@",temp);
    NSString* resid=[temp valueForKey:@"res_id"];
    NSMutableArray* res=[[NSMutableArray alloc] init];
    NSMutableArray* mall=[API sharedInstance].mallInfo;
    for (int i=0; i<mall.count; i++) {
        NSString* a=[NSString stringWithFormat:@"%@",mall[i][0]];
        if([a isEqualToString:resid])
            res=mall[i];
    }
    cell.labelName.text=[temp valueForKey:@"name"];
    
    NSString* type;
    if ([[tempnow valueForKey:@"table_type"] intValue]==2) {
        type=@"A";
    }
    else if ([[tempnow valueForKey:@"table_type"] intValue]==4) {
        type=@"B";
    }
    else if ([[tempnow valueForKey:@"table_type"] intValue]==6) {
        type=@"C";
    }
    else if ([[tempnow valueForKey:@"table_type"] intValue]==8) {
        type=@"D";
    }
    cell.labelNumber.text=[NSString stringWithFormat:@"%@%@",type,[temp valueForKey:@"max"] ];
    int num=[[tempnow valueForKey:@"min"] intValue]-[[temp valueForKey:@"min"] intValue];
    int people=[[temp valueForKey:@"max"] intValue]-[[tempnow valueForKey:@"min"] intValue];
    NSString* mes;
    
    NSString* startString=[temp valueForKey:@"wait_time"];
    startString=[startString substringFromIndex:11];
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
    if ([[temp valueForKey:@"max"] isEqualToString:@"1"]) {
        mes=@"您为当前第一位，请立即赶往餐厅。";
    }
    else if(num<5)
    {
        NSString* time;
        if ([[temp valueForKey:@"table_type"] isEqual:@"2"]) {
            time=res[15];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"4"]) {
            time=res[16];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"6"]) {
            time=res[17];
        }
        else if ([[temp valueForKey:@"table_type"] isEqual:@"8"]) {
            time=res[18];
        }
        NSInteger pos=people*[time intValue];
        
        pos=pos-(hour*60+minute-startHour*60-startMinute);
        mes=[NSString stringWithFormat:@"%ld分钟",(long)pos];
    
    }
    else
    {
        int v=(hour*60+minute-startHour*60-startMinute)/num;
        int number=[[tempnow valueForKey:@"max"] intValue]-[[temp valueForKey:@"min"] intValue];
        mes=[NSString stringWithFormat:@"%d分钟",v*number];

    }
    cell.labelTime.text=mes;
    
    return cell;
    
}
@end
