//
//  API.h
//  EQ
//
//  Created by YangYuxin on 15/1/15.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol apiDelegate <NSObject>

@optional
-(void)getResInfoSuccess;
-(void)loginSuccess;
-(void)addQueueSuccess:(NSInteger)row;
-(void)getMenuSuccess;
@end





@interface API : NSObject<NSXMLParserDelegate>

@property(strong,nonatomic) NSMutableArray *mallInfo;
@property(strong,nonatomic) NSMutableDictionary *selfInfo;
@property(strong,nonatomic) NSMutableDictionary *queueInfo;
@property(strong,nonatomic) NSMutableArray *queueArray;
@property(strong,nonatomic) NSMutableArray *nowQueueArray;
@property(strong,nonatomic) NSMutableArray *menu;
@property(strong,nonatomic) NSString* IP;
@property(strong,nonatomic) NSString* resId;
@property(strong,nonatomic) NSString* type;
@property(strong,nonatomic) NSString* cus;
@property NSInteger row;
@property(nonatomic) BOOL isLogin;

+ (API*) sharedInstance;
-(int)getResInfo:(NSString *)mallId;
-(int)getNotice:(NSString *)resId;
-(int)getResMenu:(NSString *)resId;
-(int)reg:(NSString* )phoneNumber :(NSString*)pwd :(NSString*)name :(NSString*)gender;
-(int)login:(NSString* )phoneNumber :(NSString*)pwd;
-(int)addQueue:(NSString*)cusId :(NSString*)resId :(NSString*)type;
-(int)order:(NSString*)cusId :(NSString*)resId :(NSString*)type :(NSString*)menu;
-(int)searchQueue:(NSString*)cusId;

@property(nonatomic,assign) id<apiDelegate> delegate;
@end
