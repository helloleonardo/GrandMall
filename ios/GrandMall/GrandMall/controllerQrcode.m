//
//  controllerQrcode.m
//  EQ
//
//  Created by YangYuxin on 14/12/30.
//  Copyright (c) 2014年 YYX. All rights reserved.
//

#import "controllerQrcode.h"
#import "controllerSecondTabBar.h"


@interface controllerQrcode ()
{
    UIAlertView* alert;
}

@end

@implementation controllerQrcode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readQrcode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [API sharedInstance].delegate=self;
}

-(void)readQrcode
{
    AVCaptureDevice* device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError* error=nil;
    
    AVCaptureDeviceInput* input=[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"No camera");
        [[API sharedInstance] getResInfo:@"1"];
        return;
    }
    
    AVCaptureMetadataOutput* output=[[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
    
    AVCaptureSession* session=[[AVCaptureSession alloc] init];
    session=[[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:output];
    
    AVCaptureVideoPreviewLayer* preview=[[AVCaptureVideoPreviewLayer alloc] init];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    preview=[AVCaptureVideoPreviewLayer layerWithSession:session];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [preview setFrame:self.view.bounds];
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer=preview;
    
    [session startRunning];
    self.session=session;

}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];
    
    NSLog(@"%@",metadataObjects);
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject* obj=metadataObjects[0];
        NSLog(@"%@",obj.stringValue);
        NSString* temp=obj.stringValue;
        if([temp isEqual:@"1"])
        {
            [[API sharedInstance] getResInfo:@"1"];
        }
        else
        {
            alert=[[UIAlertView alloc] initWithTitle:nil message:@"二维码错误，请重新扫描." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self.previewLayer removeFromSuperlayer];
    [self readQrcode];
}

-(void)getResInfoSuccess
{
    controllerSecondTabBar* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"secondtabbar"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;

}

@end
