//
//  API.m
//  EQ
//
//  Created by YangYuxin on 15/1/15.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "API.h"
#import <AFHTTPRequestOperation.h>
#import <AFHTTPRequestOperationManager.h>

static API* _sharedInstance = nil;
UIAlertView* publicAlert;
BOOL flag;
int choice;
NSString* element;
NSString* certainQueueId;
NSString* certainResId;
NSString* certainPhone;
@implementation API



//单例
+ (API*) sharedInstance{
    if (_sharedInstance == nil) {
        _sharedInstance = [[API alloc] init];
        _sharedInstance.IP=@"192.168.1.104";
        _sharedInstance.isLogin=false;
        _sharedInstance.queueArray=[[NSMutableArray alloc] init];
        _sharedInstance.nowQueueArray=[[NSMutableArray alloc] init];
        _sharedInstance.mallInfo=[[NSMutableArray alloc] init];
        element=@"";
        choice=0;
    }
    return _sharedInstance;
}

-(NSMutableURLRequest*)createRequest:(NSString*)action Parameters:(NSString*)para
{
    NSString* URLtemp=[NSString stringWithFormat:@"http://%@/WebService.asmx/%@",self.IP,action];
    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
    NSData* data=[para dataUsingEncoding:NSUTF8StringEncoding];
    unsigned long long postLength = data.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    element=[element stringByAppendingString:string];
    NSLog(@"str %@",string);
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSArray* tempArry=(NSArray*)[self jsonToArray:element];
   
    NSMutableDictionary* tempDic=[[NSMutableDictionary alloc] init];
    if (choice==0) {
        self.mallInfo=[[NSMutableArray alloc] init];
        for (int i=0; i<tempArry.count; i++) {
            NSArray* temp=tempArry[i];
            NSMutableDictionary* tempD=[[NSMutableDictionary alloc] init];
            [tempD setObject:temp[0] forKey:@"busi_id"];
            [tempD setObject:temp[5] forKey:@"busi_name"];
            [tempD setObject:temp[6] forKey:@"busi_pic"];
            [tempD setObject:temp[7] forKey:@"busi_tel"];
            [tempD setObject:temp[8] forKey:@"busi_addr"];
            [tempD setObject:temp[9] forKey:@"busi_intro"];
            [tempD setObject:temp[10] forKey:@"busi_avgCost"];
            [tempD setObject:temp[11] forKey:@"busi_minCost"];
            [tempD setObject:temp[18] forKey:@"table_type_2_wait"];
            [tempD setObject:temp[20] forKey:@"table_type_4_wait"];
            [tempD setObject:temp[22] forKey:@"table_type_6_wait"];
            [tempD setObject:temp[24] forKey:@"table_type_8_wait"];
            [self.mallInfo addObject:tempD];
            
        }
        
    }
    else if (choice==1)
    {
        self.menu=[tempArry mutableCopy];
    }
    else if (choice==3)
    {
        flag=true;
        if ([tempArry[0] isEqualToString:@"fail"]) {
            flag=false;
            publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名已存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [publicAlert show];
        }
    }
    else if(choice==4)
    {
        flag=true;
        if ([tempArry count]==0) {
            flag=false;
            publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [publicAlert show];
            return;
        }
        [tempDic setObject:tempArry[0] forKey:@"customer_id"];
        [tempDic setObject:tempArry[1] forKey:@"customer_name"];
        [tempDic setObject:tempArry[2] forKey:@"customer_gender"];
        [tempDic setObject:certainPhone forKey:@"customer_phone"];
        self.selfInfo=[tempDic mutableCopy];

    }
    else if(choice==5)
    {
        [self getQueue:[self.selfInfo valueForKey:@"customer_id"]];

    }
    else if(choice==6)
    {
        NSMutableDictionary* temp;
        for (NSMutableDictionary* dic in self.queueArray) {
            if ([[dic objectForKey:@"queue_id"] isEqualToString:certainQueueId]) {
                temp=dic;
            }
        }
        [temp setObject:tempArry[0] forKey:@"queue_nowNumber"];
    }
    else if(choice==7)
    {
        [self getQueue:[self.selfInfo valueForKey:@"customer_id"]];

    }
    else if(choice==8)
    {
        self.queueArray=[[NSMutableArray alloc] init];
        for (NSArray* temp in tempArry) {
            NSMutableDictionary* te=[[NSMutableDictionary alloc] init];
            [te setObject:temp[0] forKey:@"queue_id"];
            [te setObject:temp[1] forKey:@"table_type"];
            [te setObject:temp[2] forKey:@"queue_time"];
            [te setObject:temp[3] forKey:@"queue_order"];
            [te setObject:temp[4] forKey:@"queue_startNumber"];
            [te setObject:temp[5] forKey:@"busi_name"];
            [te setObject:temp[6] forKey:@"queue_nowNumber"];
            [te setObject:[NSDate date] forKey:@"queue_time_now"];
            [self.queueArray addObject:te];
        }
        
        
    }



    element=@"";
}


-(id)jsonToArray:(NSString*)string;
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil)
    {
        NSLog(@"Json Transfer Error.");
        return nil;
    }
    return result;
}


//通过商场id获取餐厅信息
-(int)getResInfo:(NSString *)mallId :(NSString *)sortType :(NSString*)sort
{
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/getResInfo.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"mall_id=%@",mallId]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        self.mallInfo=[resultDic mutableCopy];
//        
//        for(int i=0;i<self.mallInfo.count;i++)
//        {
//            NSMutableArray* temp=self.mallInfo[i];
//            for(int j=0;j<temp.count;j++)
//            {
//                NSLog(@"%@",temp[j]);
//            }
//        }
//        [self getQueue:self.cus];
//        [self.delegate getResInfoSuccess];
//
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_mall_id=%@&_sort_type=%@&_sort=%@",mallId,sortType,sort];
    NSMutableURLRequest* request=[self createRequest:@"getBusiInfo" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        choice=0;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
        [self.delegate getResInfoSuccess];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];

    
    return 0;
}

//通过餐厅id获取餐厅菜单
-(int)getResMenu:(NSString *)resId :(NSString*)sortType
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/getMenu.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"res_id=%@",resId]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        NSLog(@"Success: %@", operation.responseString);
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",resultDic);
//        self.menu=[resultDic mutableCopy];
//        [self.delegate getMenuSuccess];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_busi_id=%@&_sort_type=%@",resId,sortType];
    NSMutableURLRequest* request=[self createRequest:@"getFoodInfo" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        choice=1;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
        [self.delegate getMenuSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;
}

//通过餐厅id获取餐厅公告
-(int)getNotice:(NSString *)resId
{
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/getNotice.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"res_id=%@",resId]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",resultDic);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    
    NSString* param=[NSString stringWithFormat:@"_busi_id=%@",resId];
    NSMutableURLRequest* request=[self createRequest:@"getNoticeInfo" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        choice=2;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;
}

-(int)reg:(NSString* )phoneNumber :(NSString*)pwd :(NSString*)name :(NSString*)gender
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/register.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_phone_number=%@",phoneNumber]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&customer_password=%@",pwd]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&customer_name=%@",name]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&customer_gender=%@",gender]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        self.selfInfo=[resultDic mutableCopy];
//        NSLog(@"%@",self.selfInfo);
//        NSString* sta=[self.selfInfo valueForKey:@"state"];
//        if ([sta isEqualToString:@"0"]) {
//            publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名已存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [publicAlert show];
//        }
//        else if([sta isEqualToString:@"1"])
//        {
//            self.isLogin=true;
//            [self.delegate loginSuccess];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_customer_phone_number=%@&_customer_password=%@&_customer_name=%@&_customer_gender=%@",phoneNumber,pwd,name,gender];
    NSMutableURLRequest* request=[self createRequest:@"setRegister" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        choice=3;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
        if (flag) {
            [self login:phoneNumber :pwd];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;

}

-(int)login:(NSString* )phoneNumber :(NSString*)pwd
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/login.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_phone_number=%@",phoneNumber]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&customer_password=%@",pwd]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        self.selfInfo=[resultDic mutableCopy];
//        NSLog(@"%@",self.selfInfo);
//        NSString* sta=[self.selfInfo valueForKey:@"state"];
//        self.cus=[self.selfInfo valueForKey:@"customer_id"];
//        if ([sta isEqualToString:@"00"]) {
//            publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名不存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [publicAlert show];
//            
//        }
//        else if([sta isEqualToString:@"10"])
//        {
//            publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [publicAlert show];
//        }
//        else if([sta isEqualToString:@"11"])
//        {
//            [self.delegate loginSuccess];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_customer_phone_number=%@&_customer_password=%@",phoneNumber,pwd];
    NSMutableURLRequest* request=[self createRequest:@"logIn" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        certainPhone=phoneNumber;
        choice=4;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
        if (flag) {
            
            [self.delegate loginSuccess];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];

    
    return 0;
    
}

-(int)addQueue:(NSString*)cusId :(NSString*)resId :(NSString*)type
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/queueing_add.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_id=%@",cusId]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&res_id=%@",resId]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&table_type=%@",type]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        self.queueInfo=[resultDic mutableCopy];
//        [self.queueArray addObject:self.queueInfo];
//        [self.nowQueueArray addObject:self.queueInfo];
//        NSString* sta=[self.queueInfo valueForKey:@"state"];
//        if ([sta isEqualToString:@"1"]) {
//            [self.delegate addQueueSuccess:self.queueArray.count-1];
//            
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_customer_id=%@&_type=%@&_busi_id=%@",cusId,type,resId];
    NSMutableURLRequest* request=[self createRequest:@"insertQueue" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        certainResId=resId;
        choice=5;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
//        [self.delegate addQueueSuccess:self.queueArray.count-1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];

    
    return 0;

}

-(int)searchQueue:(NSString*)queueId
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/getQueueing.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_id=%@",cusId]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        NSMutableArray* arr=[resultDic mutableCopy];
//        for (int i=0; i<arr.count; i++) {
//            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
//            [dic setObject:arr[i][0] forKey:@"queueing_id"];
//            [dic setObject:arr[i][1] forKey:@"res_id"];
//            //[dic setObject:arr[i][2] forKey:@"max"];
//            [dic setObject:arr[i][3] forKey:@"table_type"];
//            [dic setObject:arr[i][4] forKey:@"wait_time"];
//            [dic setObject:arr[i][5] forKey:@"max"];
//            [dic setObject:arr[i][7] forKey:@"min"];
//            NSMutableArray* temp=[[NSMutableArray alloc] init];
//            for (int j=0; j<self.mallInfo.count; j++) {
//                if ([self.mallInfo[j][0] isEqualToString:arr[i][1] ]) {
//                    temp=self.mallInfo[j];
//                }
//            }
//            [dic setObject:temp[3] forKey:@"name"];
//            
//            int k=0;
//            for (int j=0; j<self.queueArray.count; j++) {
//                NSDictionary* te=self.nowQueueArray[j];
//                if ([[te valueForKey:@"res_id"] isEqualToString:[dic valueForKey:@"res_id"]] ) {
//                    k=j;
//                }
//            }
//            [self.nowQueueArray removeObjectAtIndex:k];
//            [self.nowQueueArray insertObject:dic atIndex:k];
//            [self.delegate addQueueSuccess:0];
//
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_queueing_id=%@",queueId];
    NSMutableURLRequest* request=[self createRequest:@"queryQueueing" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        choice=6;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
         @synchronized(self)
        {
            certainQueueId=queueId;
            [xml parse];
        }
  
 //       [self.delegate addQueueSuccess:0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;
    
}

-(int)order:(NSString*)cusId :(NSString*)resId :(NSString*)type :(NSString*)menu
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];
//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/queueing_and_order.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_id=%@",cusId]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&res_id=%@",resId]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&table_type=%@",type]];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"&food_list=%@",menu]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        self.queueInfo=[resultDic mutableCopy];
//        [self.queueArray addObject:self.queueInfo];
//        [self.nowQueueArray addObject:self.queueInfo];
//
//            [self.delegate addQueueSuccess:self.queueArray.count-1];
//
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",URLtemp);
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_customer_id=%@&_busi_id=%@&_table_type=%@&_food_list=%@",cusId,resId,type,menu];
    NSMutableURLRequest* request=[self createRequest:@"orderFood" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        choice=7;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
 //       [self.delegate addQueueSuccess:self.queueArray.count-1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;
    
}

-(int)getQueue:(NSString*)cusId
{
    publicAlert=[[UIAlertView alloc] initWithTitle:nil message:@"请稍候" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [publicAlert show];

//    NSString * URLtemp=[NSString stringWithFormat:@"http://%@:9993/ClientRequest/getQueueing.php?",self.IP];
//    URLtemp =[URLtemp stringByAppendingString:[NSString stringWithFormat:@"customer_id=%@",cusId]];
//    URLtemp =[URLtemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLtemp]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        NSMutableArray* arr=[resultDic mutableCopy];
//        for (int i=0; i<arr.count; i++) {
//            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
//            [dic setObject:arr[i][0] forKey:@"queueing_id"];
//            [dic setObject:arr[i][1] forKey:@"res_id"];
//            //[dic setObject:arr[i][2] forKey:@"max"];
//            [dic setObject:arr[i][3] forKey:@"table_type"];
//            [dic setObject:arr[i][4] forKey:@"wait_time"];
//            [dic setObject:arr[i][5] forKey:@"max"];
//            [dic setObject:arr[i][7] forKey:@"min"];
//            NSMutableArray* temp=[[NSMutableArray alloc] init];
//            for (int j=0; j<self.mallInfo.count; j++) {
//                if ([self.mallInfo[j][0] isEqualToString:arr[i][1] ]) {
//                    temp=self.mallInfo[j];
//                }
//            }
//            [dic setObject:temp[3] forKey:@"name"];
//            [self.queueArray addObject:dic];
//            [self.nowQueueArray addObject:dic];
//
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        
//    }];
//    
//    [operation start];
    NSString* param=[NSString stringWithFormat:@"_customer_id=%@",cusId];
    NSMutableURLRequest* request=[self createRequest:@"get_Queue" Parameters:param];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer new];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [publicAlert dismissWithClickedButtonIndex:0 animated:YES];
        choice=8;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSXMLParser* xml=[[NSXMLParser alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];
        [self.delegate addQueueSuccess:self.queueArray.count-1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    [op start];
    
    return 0;

    
    return 0;
    
}
@end
