//
//  cellQueue.m
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "cellQueue.h"

@implementation cellQueue

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)queue:(id)sender {
    [self.delegate addQueue:self.row];
}

- (IBAction)order:(id)sender {
    [self.delegate addOrder:self.row];
}
@end
