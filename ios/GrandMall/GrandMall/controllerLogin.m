//
//  controllerLogin.m
//  EQ
//
//  Created by YangYuxin on 14/12/30.
//  Copyright (c) 2014年 YYX. All rights reserved.
//

#import "controllerLogin.h"
#import "controllerMainTabBar.h"
#import "controllerRegister.h"
@interface controllerLogin ()

@end

@implementation controllerLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.viewPhoneTrue.hidden=true;
    self.viewPwdTrue.hidden=true;
    self.buttonLoginTrue.hidden=true;
    [self.textPwd  setSecureTextEntry:YES];
    self.buttonRegTrue.hidden=true;
    [self.textPhone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSThread sleepForTimeInterval:0.4];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue=[NSNumber numberWithInt:-100];
    animation.duration=0.4;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    CABasicAnimation *animationAlpha=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animationAlpha.toValue=[NSNumber numberWithInt:1];
    animationAlpha.duration=0.4;
    animationAlpha.removedOnCompletion=YES;
    animationAlpha.fillMode=kCAFillModeForwards;
    
    [self.imgLogo.layer addAnimation:animation forKey:@"animationMove"];
    [self.viewPhone.layer addAnimation:animation forKey:@"animationMove"];
    [self.viewPwd.layer addAnimation:animation forKey:@"animationMove"];
    [self.buttonLogin.layer addAnimation:animation forKey:@"animationMove"];
    [self.buttonReg.layer addAnimation:animation forKey:@"animationMove"];
    [self.viewPhone.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    [self.viewPwd.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    [self.buttonLogin.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    [self.buttonReg.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    }


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:0.4];
    self.viewPhoneTrue.hidden=false;
    self.viewPwdTrue.hidden=false;
    self.buttonLoginTrue.hidden=false;
    self.buttonRegTrue.hidden=false;
    [API sharedInstance].delegate=self;

    
}


- (IBAction)buttonLoginDown:(id)sender {
    
    [[API sharedInstance] login:self.textPhone.text :self.textPwd.text];
}

- (IBAction)buttonRegDown:(id)sender {
    controllerMainTabBar* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;
}


-(void)loginSuccess
{
    controllerRegister* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"maintabbar"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;

}


@end
