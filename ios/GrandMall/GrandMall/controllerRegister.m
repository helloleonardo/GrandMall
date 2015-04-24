//
//  controllerRegister.m
//  EQ
//
//  Created by YangYuxin on 15/1/16.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import "controllerRegister.h"
#import "controllerMainTabBar.h"

@interface controllerRegister ()
{
    NSMutableArray* source;
}

@end

@implementation controllerRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textPhone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textPwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textName setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    source=[[NSMutableArray alloc] init];
    [source addObject:@"先生"];
    [source addObject:@"女士"];
    [self.pickGender reloadAllComponents];
    [self.textPwd  setSecureTextEntry:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonOk:(id)sender {
    [[API sharedInstance] reg:self.textPhone.text :self.textPwd.text :self.textName.text :[source objectAtIndex:[self.pickGender selectedRowInComponent:0]] ];
    
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [source count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor whiteColor];
    label.text=[source objectAtIndex:row];
    return label;
}



-(void)loginSuccess
{
    controllerRegister* Vc;
    Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"maintabbar"];
    [Vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:Vc animated:YES completion:nil] ;

}

@end
