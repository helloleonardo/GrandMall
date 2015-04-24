//
//  controllerQrcode.h
//  EQ
//
//  Created by YangYuxin on 14/12/30.
//  Copyright (c) 2014年 YYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "API.h"

@interface controllerQrcode : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,apiDelegate>
@property(strong,nonatomic) AVCaptureSession *session;
@property(strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end
