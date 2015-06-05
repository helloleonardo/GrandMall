//
//  controllerQueue.m
//  EQ
//
//  Created by YangYuxin on 15/1/15.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerQueue.h"
#import "UIImageView+AFNetworking.h"
#import "controllerOrder.h"
#import "controllerResDetail.h"


@interface controllerQueue ()
{
    NSMutableArray* mallInfo;
    NSMutableArray* source;
    NSInteger number;
}

@end

@implementation controllerQueue

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mallInfo=[[NSMutableArray alloc] init];
    mallInfo=[API sharedInstance].mallInfo;
    source=[[NSMutableArray alloc] init];
    [source addObject:@"2人桌"];
    [source addObject:@"4人桌"];
    [source addObject:@"6人桌"];
    [source addObject:@"8人桌"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imgBack.hidden=true;
    self.viewBack.hidden=true;

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [API sharedInstance].delegate=self;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mallInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"cellqueue";
    UINib* nib = [UINib nibWithNibName:@"cellQueue" bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:TableSampleIdentifier];
    cellQueue *cell = [tableView dequeueReusableCellWithIdentifier:
                          TableSampleIdentifier];
    cell.delegate=self;
    if (cell == nil) {
        cell = [[cellQueue alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    NSMutableDictionary* temp=mallInfo[indexPath.row];
    cell.labelName.text=[temp objectForKey:@"busi_name"];
    cell.labelInfo.text=[temp objectForKey:@"busi_intro"];
    NSString* tempURL=[NSString stringWithFormat:@"http://%@/%@",[API sharedInstance].IP,[temp objectForKey:@"busi_pic"]];
    [cell.picRes setImageWithURL:[NSURL URLWithString:tempURL]];
    cell.row=indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [API sharedInstance].row=indexPath.row;
    controllerResDetail* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resdetail"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [source count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [source objectAtIndex:row];
}


-(void)addQueue:(NSInteger)row
{
    self.imgBack.hidden=false;
    self.viewBack.hidden=false;
    number=row;
}

-(void)addOrder:(NSInteger)row
{
    NSString* resId=[[([API sharedInstance].mallInfo) objectAtIndex:row] objectForKey:@"busi_id"];
    [[API sharedInstance] getResMenu:resId];
    [API sharedInstance].resId=resId;
}

-(void)addQueueSuccess:(NSInteger)row{
    self.imgBack.hidden=true;
    self.viewBack.hidden=true;
    NSMutableDictionary* temp=([API sharedInstance].queueArray)[row];
    NSMutableDictionary* temp2=mallInfo[number];
    [temp setObject:[temp2 objectForKey:@"busi_id"] forKey:@"busi_id"];

}

-(void)getMenuSuccess
{
    controllerOrder* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"order"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;

}


- (IBAction)queueOk:(id)sender {
    NSMutableDictionary* temp=mallInfo[number];
    NSString* type;
    if ([self.pickerTable selectedRowInComponent:0]==0) {
        type=@"2";
    }
    else if ([self.pickerTable selectedRowInComponent:0]==1) {
        type=@"4";
    }
    else if ([self.pickerTable selectedRowInComponent:0]==2) {
        type=@"6";
    }
    else if ([self.pickerTable selectedRowInComponent:0]==3) {
        type=@"8";
    }
    [[API sharedInstance] addQueue:[[API sharedInstance].selfInfo valueForKey:@"customer_id"] :[temp objectForKey:@"busi_id"] :type];
}

- (IBAction)queueCancel:(id)sender {
    self.imgBack.hidden=true;
    self.viewBack.hidden=true;
}


@end
