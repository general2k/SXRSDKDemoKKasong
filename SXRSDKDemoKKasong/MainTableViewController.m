//
//  MainTableViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/10.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "MainTableViewController.h"
#import "ScanDeviceViewController.h"
enum {
    FuncRegister,
    FuncLogin,
    FuncForgetPassword,
    FuncChangePassword,
    FuncGetMemberInfo,
    FuncUpdateMemberInfo,
    FuncUpdateAlarms,
    FuncUploadHeadimage,
    FuncLogout,
    FuncScanDevice,
    FuncCurrentData,
    FuncSportData,
    FuncHistoryData,
    FuncSetParameter,
    FuncPersonInfo,
    FuncSetAlarm,
    FuncHeartRate,
    FuncAntiLost,
    FuncMusicPlayer,
    FuncCurrentDevice,
    FuncSendANCSPair,
    FuncTakePhoto,
    FuncSedentary,
    FuncHydration,
    FuncConnectDefaultDevice,
    FuncReadDeviceTime,
    FuncSetDeviceTime,
    FuncSetAlarmName,
    FuncGetFirmware,
    FuncGetMacid,
    FuncClear,
    FuncSyncSportData
};


@interface MainTableViewController ()
@property(nonatomic,strong)NSArray* serveritemname;
@property(nonatomic,strong)NSArray* serveritemtag;
@property(nonatomic,strong)NSArray* deviceitemname;
@property(nonatomic,strong)NSArray* deviceitemtag;
@property(nonatomic,strong)UILabel* currentmember;
@property(nonatomic,strong)UILabel* currentdevice;
@property(nonatomic,strong)UILabel* connectstatus;
@property(nonatomic,strong)UILabel* currenttoken;

@end

@implementation MainTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [self refreshText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshText) name:notify_key_did_device_ready object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshText) name:notify_key_did_disconnect_device object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshText) name:notify_key_did_connect_device object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCamera) name:notify_key_did_recv_photo_control object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMusic:) name:notify_key_did_recv_music_control object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSOS:) name:notify_key_kkasong_did_recv_sos_request object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFindPhone:) name:notify_key_did_recv_device_find_phone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCmdFinish:) name:notify_key_did_finish_send_cmd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentData:) name:notify_key_kkasong_did_read_current_data object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.serveritemname = @[];
//    self.serveritemname = @[NSLocalizedString(@"Register", nil),
//                            NSLocalizedString(@"Login", nil),
//                            NSLocalizedString(@"ForgetPassword", nil),
//                            NSLocalizedString(@"ChangePassword", nil),
//                            NSLocalizedString(@"GetMemberInfo", nil),
//                            NSLocalizedString(@"UpdateMemberInfo", nil),
//                            NSLocalizedString(@"UpdateAlarms", nil),
//                            NSLocalizedString(@"UploadHeadimage", nil),
//                            NSLocalizedString(@"Logout", nil),
//                            ];
    self.serveritemtag = @[[NSNumber numberWithInt:FuncRegister],
                           [NSNumber numberWithInt:FuncLogin],
                           [NSNumber numberWithInt:FuncForgetPassword],
                           [NSNumber numberWithInt:FuncChangePassword],
                           [NSNumber numberWithInt:FuncGetMemberInfo],
                           [NSNumber numberWithInt:FuncUpdateMemberInfo],
                           [NSNumber numberWithInt:FuncUpdateAlarms],
                           [NSNumber numberWithInt:FuncUploadHeadimage],
                           [NSNumber numberWithInt:FuncLogout]
                           ];
    self.deviceitemname = @[NSLocalizedString(@"ConnectDefaultDevice", nil),
                            NSLocalizedString(@"ScanDevice", nil),
                            NSLocalizedString(@"CurrentDevice", nil),
                            NSLocalizedString(@"ReadMacid", nil),
                            NSLocalizedString(@"ReadFirmware", nil),
                            NSLocalizedString(@"ReadDeviceTime", nil),
                            NSLocalizedString(@"SetDeviceTime", nil),
                            NSLocalizedString(@"CurrentData", nil),
                            NSLocalizedString(@"HistoryData", nil),
                            NSLocalizedString(@"SetParameter", nil),
                            NSLocalizedString(@"PersonInfo", nil),
                            NSLocalizedString(@"SportData", nil)
                            ];
    self.deviceitemtag = @[[NSNumber numberWithInt:FuncConnectDefaultDevice],
                           [NSNumber numberWithInt:FuncScanDevice],
                           [NSNumber numberWithInt:FuncCurrentDevice],
                           [NSNumber numberWithInt:FuncGetMacid],
                           [NSNumber numberWithInt:FuncGetFirmware],
                           [NSNumber numberWithInt:FuncReadDeviceTime],
                           [NSNumber numberWithInt:FuncSetDeviceTime],
                           [NSNumber numberWithInt:FuncCurrentData],
                           [NSNumber numberWithInt:FuncHistoryData],
                           [NSNumber numberWithInt:FuncSetParameter],
                           [NSNumber numberWithInt:FuncPersonInfo],
                           [NSNumber numberWithInt:FuncSyncSportData]
                           ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 145)];
        view.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        self.currentdevice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
        self.currentdevice.textColor = [UIColor blackColor];
        self.currentdevice.adjustsFontSizeToFitWidth = YES;
        self.currentdevice.minimumScaleFactor = 0.5;
        self.currentdevice.textAlignment = NSTextAlignmentLeft;
        self.connectstatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, CGRectGetWidth(self.view.frame), 30)];
        self.connectstatus.textColor = [UIColor blackColor];
        self.connectstatus.textAlignment = NSTextAlignmentLeft;
        self.connectstatus.adjustsFontSizeToFitWidth = YES;
        self.connectstatus.minimumScaleFactor = 0.5;
        self.currentmember = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), 30)];
        self.currentmember.textColor = [UIColor blackColor];
        self.currentmember.textAlignment = NSTextAlignmentLeft;
        self.currentmember.adjustsFontSizeToFitWidth = YES;
        self.currentmember.minimumScaleFactor = 0.5;
        self.currenttoken = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, CGRectGetWidth(self.view.frame), 30)];
        self.currenttoken.textColor = [UIColor blackColor];
        self.currenttoken.textAlignment = NSTextAlignmentLeft;
        self.currenttoken.adjustsFontSizeToFitWidth = YES;
        self.currenttoken.minimumScaleFactor = 0.5;
       
        
        [view addSubview:self.currentdevice];
        [view addSubview:self.currentmember];
        [view addSubview:self.connectstatus];
        [view addSubview:self.currenttoken];
        view;
    });
}

-(void)refreshText{
    self.currentdevice.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Current Device", nil), [SXRSDKConfig getCurrentDeviceUUID]];
    self.connectstatus.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Connect Status", nil),[[SXR shareInstance] isConnect]?@"YES":@"NO"];
    self.currentmember.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Current Member", nil), [SXRSDKConfig getCurrentMemberID]];
    self.currenttoken.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Current Token", nil), [SXRSDKConfig getCurrentTokenID]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
            return [self.deviceitemname count];
            break;
        case 1:
            return [self.serveritemname count];
        default:
            break;
    }
    return 0;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Device Function List", nil);
            break;
        case 1:
            return NSLocalizedString(@"Server Function List", nil);
            break;
            
        default:
            break;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simplecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"simplecell"];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.deviceitemname objectAtIndex:indexPath.row];
            cell.tag = [[self.deviceitemtag objectAtIndex:indexPath.row] intValue];
            break;
        case 1:
            cell.textLabel.text = [self.serveritemname objectAtIndex:indexPath.row];
            cell.tag = [[self.serveritemtag objectAtIndex:indexPath.row] intValue];
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (cell.tag) {
        case FuncRegister:{
            [self performSegueWithIdentifier:@"register" sender:nil];
        }
            break;
        case FuncLogin:{
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
            break;
        case FuncForgetPassword:{
            [self performSegueWithIdentifier:@"forgetpassword" sender:nil];
        }
            break;
        case FuncChangePassword:{
            [self performSegueWithIdentifier:@"changepassword" sender:nil];
        }
            break;
        case FuncGetMemberInfo:{
            [self performSegueWithIdentifier:@"memberinfo" sender:nil];
        }
            break;
        case FuncUpdateMemberInfo:{
            [self performSegueWithIdentifier:@"memberinfo" sender:nil];
        }
            break;
        case FuncUpdateAlarms:{
            [self performSegueWithIdentifier:@"memberinfo" sender:nil];
        }
            break;
        case FuncUploadHeadimage:{
            [self performSegueWithIdentifier:@"memberinfo" sender:nil];
        }
            break;
        case FuncLogout:{
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
            break;
        case FuncScanDevice:{
            [self performSegueWithIdentifier:@"scandevice" sender:nil];
//            ScanDeviceViewController* vc = [[ScanDeviceViewController alloc] init];
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
//            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case FuncCurrentData:{
            [SXRService ReadCurrentStep:nil];
        }
            break;
        case FuncHistoryData:{
            [self performSegueWithIdentifier:@"gethistorydata" sender:nil];
        }
            break;
        case FuncSetParameter:{
            [self performSegueWithIdentifier:@"setdeviceparam" sender:nil];
        }
            break;
        case FuncPersonInfo:{
            [self performSegueWithIdentifier:@"setalarm" sender:nil];
        }
            break;
        case FuncHeartRate:{
            [self performSegueWithIdentifier:@"heartrate" sender:nil];
        }
            break;
        case FuncConnectDefaultDevice:{
            [[SXR shareInstance] connectDefaultDevice];
        }
            break;
        case FuncReadDeviceTime:{
            [SXRService ReadTime:nil];
        }
            break;
        case FuncSetDeviceTime:{
            [SXRService SetTime:nil];
        }
            break;
        case FuncCurrentDevice:{
            [self performSegueWithIdentifier:@"deviceinfo" sender:nil];
        }
            break;
        case FuncGetMacid:{
            [SXRService ReadMacID:nil];
        }
            break;
        case FuncGetFirmware:{
            [SXRService ReadFirmware:nil];
            
        }
            break;
        case FuncSyncSportData:{
            [self performSegueWithIdentifier:@"sportdata" sender:nil];
        }
            break;

        default:
            break;
    }
}
//- (UIViewController *)getPresentedViewController
//{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    
//    return topVC;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(void)onGetCurrentData:(NSNotification*)notify{
//    NSDictionary* userinfo = notify.userInfo;
//    if (userinfo) {
//        int steps = [[userinfo objectForKey:CZJK_NOTIFY_PARAM_CURRENT_STEPS] intValue];
//        int cal = [[userinfo objectForKey:CZJK_NOTIFY_PARAM_CURRENT_CAL] intValue];
//        int dist = [[userinfo objectForKey:CZJK_NOTIFY_PARAM_CURRENT_DIST] intValue];
//        
//        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nStep = %d\nCalories=%d\nDistance=%d",NSLocalizedString(@"Read Current Data OK.", nil),steps,cal,dist] preferredStyle:UIAlertControllerStyleAlert];
//        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [self presentViewController:ac animated:YES completion:nil];
//         
//        
//        
//    }
//}

-(void)onCmdFinish:(NSNotification*)notify{
    NSDictionary* dict = notify.userInfo;
    int substate = [[dict objectForKey:NOTIFY_KEY_SUBSTATE] intValue];
    bool isok = [[dict objectForKey:NOTIFY_KEY_ISOK] boolValue];
    switch (substate) {
        case SUB_STATE_KKASONG_WAIT_GET_DEVICETIME_RSP:
            if (isok) {
                int year = [[dict objectForKey:KKASONG_NOTIFY_PARAM_YEAR] intValue];
                int month = [[dict objectForKey:KKASONG_NOTIFY_PARAM_MONTH] intValue];
                int day = [[dict objectForKey:KKASONG_NOTIFY_PARAM_DAY] intValue];
                int hour = [[dict objectForKey:KKASONG_NOTIFY_PARAM_HOUR] intValue];
                int minute = [[dict objectForKey:KKASONG_NOTIFY_PARAM_MINUTE] intValue];
                int second = [[dict objectForKey:KKASONG_NOTIFY_PARAM_SECOND] intValue];
                int weekday = [[dict objectForKey:KKASONG_NOTIFY_PARAM_WEEKDAY] intValue];
                
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nyear=%d\nmonth=%d\nday=%d\nhour=%d\nminute=%d\nsecond=%d\nweekday=%d",NSLocalizedString(@"Read Time OK", nil),year,month,day,hour,minute,second,weekday] preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Time Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;

        case SUB_STATE_KKASONG_WAIT_SET_DEVICETIME_RSP:
            if (isok) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Time OK", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];

            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Time Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];

            }
            break;
        case SUB_STATE_KKASONG_WAIT_SET_DEVICEPARAM_RSP:
            if (isok) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Device Param OK", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Device Param Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;
        case SUB_STATE_KKASONG_WAIT_SET_PERSONINFO_RSP:
            if (isok) {
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set PersonInfo  OK", nil) preferredStyle:UIAlertControllerStyleAlert];
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
         case SUB_STATE_KKASONG_WAIT_GET_MACID_RSP:
            if (isok) {
                NSString* macidstr = [dict objectForKey:NOTIFY_KEY_MACID];
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nMacid=%@",NSLocalizedString(@"Read Macid OK", nil), macidstr] preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Sedentary Alarm Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;
        case SUB_STATE_KKASONG_WAIT_GET_FIRMWARE_RSP:
            if (isok) {
                NSString* firmware = [dict objectForKey:NOTIFY_KEY_FIRMWARE];
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@\nFirmWare Version =%@",NSLocalizedString(@"Read FirmWare Version OK", nil), firmware] preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Sedentary Alarm Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;
        case SUB_STATE_KKASONG_WAIT_GET_CURRENTSTEP_RSP:
            if (isok) {
                NSNumber* step = [dict objectForKey:KKASONG_NOTIFY_PARAM_STEP];
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"get current step ok!\ncurrent step =%d",step.intValue] preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else{
                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Sedentary Alarm Error", nil) preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            break;

          
        default:
            break;
    }
}

-(void)onCurrentData:(NSNotification*)notify{
    NSLog(@"onCurrentData::%@",notify);
    NSDictionary* dict = notify.userInfo;
    NSNumber* step = [dict objectForKey:KKASONG_NOTIFY_PARAM_CURRENT_STEPS];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"get current step ok!\ncurrent step =%d",step.intValue] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];

}
-(void)openMusic:(NSNotification*)notify{
    NSLog(@"openMusic::%@",notify);
    NSDictionary* dict = notify.userInfo;
    NSNumber* action = [dict objectForKey:NOTIFY_KEY_MUSIC_CONTROL];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"get music control\ncurrent action =%d",action.intValue] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];

}
-(void)openFindPhone:(NSNotification*)notify{
    NSLog(@"openFindPhone::%@",notify);
    NSDictionary* dict = notify.userInfo;
    NSNumber* action = [dict objectForKey:NOTIFY_KEY_FINDPHONE_ONOFF];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"get find phone control \ncurrent action =%d",action.intValue] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];

}
-(void)openSOS:(NSNotification*)notify{
    NSLog(@"openFindPhone::%@",notify);
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"get SOS control"] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)openCamera{
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:@"Recvieve Photo Control Message" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
    //    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    if(authStatus == AVAuthorizationStatusAuthorized) {
    //        // do your logic
    //        UIViewController* contentview = [self getPresentedViewController];
    //        if ([contentview isKindOfClass:[SXRPhoto2ViewController class]] == NO){
    //            //        if (self.pickcontrol == nil){
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                SXRPhoto2ViewController* vc = [[SXRPhoto2ViewController alloc] init];
    //                [self presentViewController:vc animated:YES completion:nil];
    //
    //            });
    //        }else{
    //        }
    //
    //    }else if(authStatus == AVAuthorizationStatusNotDetermined){
    //        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    //            if(granted){
    //                UIViewController* contentview = [self getPresentedViewController];
    //                if ([contentview isKindOfClass:[SXRPhoto2ViewController class]] == NO){
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        SXRPhoto2ViewController* vc = [[SXRPhoto2ViewController alloc] init];
    //                        [self presentViewController:vc animated:YES completion:nil];
    //
    //                    });
    //                }
    //
    //            } else {
    //                NSLog(@"Not granted access");
    //            }
    //        }];
    //
    //    }else{
    //        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Camera Authorization Denied!", nil) preferredStyle:UIAlertControllerStyleAlert];
    //        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }]];
    //        [self presentViewController:ac animated:YES completion:nil];
    //        // impossible, unknown authorization status
    //    }
    
}

@end
