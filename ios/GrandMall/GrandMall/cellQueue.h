//
//  cellQueue.h
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QueueDelegate <NSObject>

@required
-(void)addQueue:(NSInteger)row;
-(void)addOrder:(NSInteger)row;

@end


@interface cellQueue : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picRes;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property NSInteger row;
- (IBAction)queue:(id)sender;
- (IBAction)order:(id)sender;

@property(nonatomic,assign) id<QueueDelegate> delegate;
@end
