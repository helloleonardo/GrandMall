//
//  controllerOrder.m
//  EQ
//
//  Created by YangYuxin on 15/1/17.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerOrder.h"
#import "UIImageView+AFNetworking.h"


@interface controllerOrder ()
{
    NSMutableArray* source;
    NSMutableArray* cellArray;
    NSMutableArray* array;
    BOOL isSort;
    NSMutableArray* sourceSort;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (IBAction)sort:(id)sender;
@end

@implementation controllerOrder

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    isSort=false;
    [super viewDidLoad];
    array=[[NSMutableArray alloc] init];
    for (int i=0; i<[API sharedInstance].menu.count;i++ ) {
        [array addObject:@"false"];
    }
    self.viewBack.hidden=true;
    self.imgBack.hidden=true;
    source=[[NSMutableArray alloc] init];
    [source addObject:@"2人桌"];
    [source addObject:@"4人桌"];
    [source addObject:@"6人桌"];
    [source addObject:@"8人桌"];
    sourceSort=[[NSMutableArray alloc] init];
    sourceSort=@[@"默认排列",@"按价格降序",@"按价格升序"];
    cellArray=[[NSMutableArray alloc] init];
    [API sharedInstance].delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isSort) {
        return [sourceSort count];
    }
    else
    {
        return [source count];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (isSort) {
        return [sourceSort objectAtIndex:row];
    }
    else
    {
        return [source objectAtIndex:row];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [API sharedInstance].menu.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"cellorder";
    UINib* nib = [UINib nibWithNibName:@"CellOrder" bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:TableSampleIdentifier];
    CellOrder *cell = [tableView dequeueReusableCellWithIdentifier:
                       TableSampleIdentifier];
    cell.delegate=self;
 
    if (cell == nil) {
        cell = [[CellOrder alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
        cell.sta=false;
    }
     
    
    
    NSMutableArray* temp=([API sharedInstance].menu)[indexPath.row];
    /*
    if (cell.sta) {
        cell.imgSta.hidden=false;
    }
    else
    {
        cell.imgSta.hidden=true;

    }
     */
    if ([array[indexPath.row]isEqualToString:@"true"]) {
        cell.imgSta.hidden=false;
    }
    else
    {
        cell.imgSta.hidden=true;
        
    }
    NSString* tempURL=[NSString stringWithFormat:@"http://%@/%@",[API sharedInstance].IP,temp[4]];
    [cell.imgPic setImageWithURL:[NSURL URLWithString:tempURL]];

    cell.labelName.text=temp[1];
    cell.labelPrice.text=[temp[2] stringByAppendingString:@"元"];
    [cellArray addObject:cell];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellOrder* cell=(CellOrder*)[tableView cellForRowAtIndexPath:indexPath];
    if ([array[indexPath.row]isEqualToString:@"true"]) {
        array[indexPath.row]=@"false";
        cell.imgSta.hidden=false;
    }
    else
    {
        array[indexPath.row]=@"true";
        cell.imgSta.hidden=true;
    }
    [tableView reloadData];
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ok:(id)sender {
    isSort=false;
    [self.pickerTable reloadAllComponents];
    self.labelTitle.text=@"请选择座位";
    self.viewBack.hidden=false;
    self.imgBack.hidden=false;
}

- (IBAction)sure:(id)sender {
    if(!isSort)
    {
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
        NSString* temp=@"";
        for (int i=0; i<[API sharedInstance].menu.count; i++) {
    //        CellOrder* cell=(CellOrder*)cellArray[i];
            if ([array[i]isEqualToString:@"true"]) {
                NSRange range=[temp rangeOfString:([API sharedInstance].menu)[i][0]];
                if (range.location ==NSNotFound) {
                    if ([temp isEqualToString:@""]) {
                        temp=[temp stringByAppendingString:[NSString stringWithFormat:@"%@", ([API sharedInstance].menu)[i][0]]];
                    }
                    else
                        temp=[temp stringByAppendingString:[NSString stringWithFormat:@",%@", ([API sharedInstance].menu)[i][0]]];
                }
                
            }
        }
        [[API sharedInstance] order:[[API sharedInstance].selfInfo valueForKey:@"customer_id"] :[API sharedInstance].resId :type :temp];
    }
    else{
        NSString* temp=[NSString stringWithFormat:@"%ld",(long)[self.pickerTable selectedRowInComponent:0]];
        [[API sharedInstance] getResMenu:[API sharedInstance].resId :temp];
    }

}

- (IBAction)nvd:(id)sender {
    self.viewBack.hidden=true;
    self.imgBack.hidden=true;
}

-(void)addQueueSuccess:(NSInteger)row{
    self.imgBack.hidden=true;
    self.viewBack.hidden=true;
//    NSMutableDictionary* temp=([API sharedInstance].queueArray)[row];
//    NSMutableArray* temp2=[[NSMutableArray alloc] init];
//    for (int i=0; i<[API sharedInstance].mallInfo.count; i++) {
//        NSMutableArray *j=[API sharedInstance].mallInfo[i];
//        if (j[0]==[API sharedInstance].resId) {
//            temp2=j;
//        }
//    }
//    [temp setObject:temp2[3] forKey:@"name"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)getResInfoSuccess
{
    [self.table reloadData];
    self.imgBack.hidden=true;
    self.viewBack.hidden=true;
}

- (IBAction)sort:(id)sender {
    isSort=true;
    [self.pickerTable reloadAllComponents];
    self.labelTitle.text=@"请选择排序方式";
    self.imgBack.hidden=false;
    self.viewBack.hidden=false;

}

-(void)getMenuSuccess
{
    [self.table reloadData];
}
@end
