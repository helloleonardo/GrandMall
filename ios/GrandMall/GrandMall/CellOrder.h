//
//  CellOrder.h
//  EQ
//
//  Created by YangYuxin on 15/1/17.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderDelegate <NSObject>


@end


@interface CellOrder : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgSta;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property BOOL sta;
@property(nonatomic,assign) id<OrderDelegate> delegate;

@end
