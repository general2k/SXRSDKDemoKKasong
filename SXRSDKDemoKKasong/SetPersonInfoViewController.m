//
//  SetPersonInfoViewController.m
//  SXRSDKWannafit
//
//  Created by qf on 16/10/18.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "SetPersonInfoViewController.h"
#import "SXRService.h"

@interface SetPersonInfoViewController ()
@property(nonatomic, strong)UILabel* infolabel;
@property(nonatomic, assign)int alarm1hour;
@property(nonatomic, assign)int alarm2hour;
@property(nonatomic, assign)int alarm1minute;
@property(nonatomic, assign)int alarm2minute;

@end

@implementation SetPersonInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCmdFinish:) name:notify_key_did_finish_send_cmd object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, 10, 200, 30)];
    [btn setTitle:NSLocalizedString(@"Sync", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.infolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10, CGRectGetWidth(self.view.frame), 300)];
    self.infolabel.textColor = [UIColor blackColor];
    self.infolabel.numberOfLines = 0;
    self.infolabel.adjustsFontSizeToFitWidth = YES;
    self.infolabel.minimumScaleFactor = 0.5;
    self.infolabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.infolabel];
    
    
    NSString* labelstr = [NSString stringWithFormat:@"Person info:\nHeight:%f\nWeight:%f\nStride:%f\nUnit:Matrix(%d)\nBirth:%@\nAlarm:{}",DEMO_HEIGHT,DEMO_WEIGHT,DEMO_STRIDE,DEMO_UNIT,DEMO_BIRTH];
    self.infolabel.text = labelstr;
    
    
    // Do any additional setup after loading the view.
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
-(void)onClickBtn:(id)sender{
    NSDictionary* paramlist = @{KKASONG_PARAM_GENDER:[NSNumber numberWithInt:DEMO_GENDER],
                                KKASONG_PARAM_HEIGHT:[NSNumber numberWithFloat:DEMO_HEIGHT],
                                KKASONG_PARAM_WEIGHT:[NSNumber numberWithFloat:DEMO_WEIGHT],
                                KKASONG_PARAM_STRIDE:[NSNumber numberWithFloat:DEMO_STRIDE],
                                KKASONG_PARAM_UNIT:[NSNumber numberWithInt:DEMO_UNIT],
                                KKASONG_PARAM_ALARMLIST:@[],
                                KKASONG_PARAM_TARGETSTEP:@10000,
                                KKASONG_PARAM_SEDENTARYALARM:@{
                                        KKASONG_PARAM_ALARM_ENABLE:@0,
                                        KKASONG_PARAM_START_HOUR:@0,
                                        KKASONG_PARAM_END_HOUR:@0,
                                        KKASONG_PARAM_SNOOZE:@0,
                                        KKASONG_PARAM_WEEKLY:@0
                                        }};
    [SXRService SetPersonInfo:paramlist];
    
}

-(void)onCmdFinish:(NSNotification*)notify{
    NSDictionary* dict = notify.userInfo;
    int substate = [[dict objectForKey:NOTIFY_KEY_SUBSTATE] intValue];
    bool isok = [[dict objectForKey:NOTIFY_KEY_ISOK] boolValue];
    switch (substate) {
        case SUB_STATE_KKASONG_WAIT_SET_PERSONINFO_RSP:
            if (isok) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set PersonInfo OK", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set PersonInfo Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;
        default:
            break;
    }
}

@end
