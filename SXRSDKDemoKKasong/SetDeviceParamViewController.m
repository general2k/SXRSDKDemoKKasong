//
//  SetDeviceParamViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/13.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "SetDeviceParamViewController.h"
#import "SXRService.h"

@interface SetDeviceParamViewController ()
@property(nonatomic, strong)UILabel* infolabel;

@end

@implementation SetDeviceParamViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCmdFinish:) name:notify_key_did_finish_send_cmd object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSString* labelstr = [NSString stringWithFormat:@"Set DeviceInfo :\nis24hour Heartrate detect:NO\nScreen light time:10\nNap Alarm:Open\nSleep Alarm:Open\nBand Language:CHS"];
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
    if ([[SXRSDKConfig getCurrentDeviceUUID] isEqualToString:@""]||[SXR shareInstance].isConnect == NO) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"ERROR\n Connect Device first", nil) preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    NSMutableDictionary* paramlist = [[NSMutableDictionary alloc] init];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_TIME_UNIT];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_TEMPERATURE_UNIT];
    [paramlist setObject:@10 forKey:KKASONG_PARAM_SCREEN_TIME];
    [paramlist setObject:@1 forKey:KKASONG_PARAM_SCREEN_DIRECTION];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_UNIT];
    [paramlist setObject:@1 forKey:KKASONG_PARAM_VIB];
    [paramlist setObject:@1 forKey:KKASONG_PARAM_TURN_WRIST];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_NO_DISTURB];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_NO_DISTURB_BEGIN_HOUR];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_NO_DISTURB_BEGIN_MINUTE];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_NO_DISTURB_END_HOUR];
    [paramlist setObject:@0 forKey:KKASONG_PARAM_NO_DISTURB_END_MINUTE];
    
    
    [SXRService SetDeviceParam:paramlist];
    
}

-(void)onCmdFinish:(NSNotification*)notify{
    NSDictionary* dict = notify.userInfo;
    int substate = [[dict objectForKey:NOTIFY_KEY_SUBSTATE] intValue];
    bool isok = [[dict objectForKey:NOTIFY_KEY_ISOK] boolValue];
    switch (substate) {
        case SUB_STATE_KKASONG_WAIT_SET_DEVICEPARAM_RSP:
            if (isok) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set DeviceParam OK", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set DeviceParam Error", nil) preferredStyle:UIAlertControllerStyleAlert];
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
