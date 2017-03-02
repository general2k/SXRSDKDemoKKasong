//
//  CurrentDataViewController.m
//  SXRSDKWannafit
//
//  Created by qf on 16/10/18.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "CurrentDataViewController.h"
#import "SXRService.h"

@interface CurrentDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableview;
@property(nonatomic, strong)UILabel* infolabel;
@property(nonatomic, strong)NSMutableArray* resultlist;
@property(nonatomic, assign)int sensorflag;
@property(nonatomic, assign)int sensorvalue;

@end

@implementation CurrentDataViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReadData:) name:notify_key_JY_did_recv_current_step object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.sensorflag = 0;
    self.sensorvalue = 0;
    self.resultlist = [[NSMutableArray alloc] init];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-65) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view.
    //    self.tableview.tableHeaderView = ({
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 145)];
    //        view.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    //        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, 10, 200, 30)];
    //        [btn setTitle:NSLocalizedString(@"Start / Stop ", nil) forState:UIControlStateNormal];
    //        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [btn setBackgroundColor:[UIColor darkGrayColor]];
    //        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:btn];
    //
    //        self.infolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 90)];
    //        self.infolabel.textColor = [UIColor blackColor];
    //        self.infolabel.adjustsFontSizeToFitWidth = YES;
    //        self.infolabel.minimumScaleFactor = 0.5;
    //        self.infolabel.textAlignment = NSTextAlignmentLeft;
    //        self.infolabel.numberOfLines = 0;
    //
    //        [view addSubview:self.infolabel];
    //        view;
    //    });
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
//-(void)onClickBtn:(id)sender{
//    if ([[SXR shareInstance] isConnect]) {
//        if(self.sensorflag == 1){
//            NSDictionary* paramlist = @{CZJK_PARAM_SENSOR_MODE:[NSNumber numberWithInt:0x80],
//                                        CZJK_PARAM_SENSOR_ONOFF:[NSNumber numberWithBool:NO],
//                                        CZJK_PARAM_SENSOR_REPORT:[NSNumber numberWithBool:NO]};
//            [SXRService SetSensorState:paramlist];
//            self.sensorflag = 0;
//            [self.resultlist insertObject:@"Send Sensor Change [mode=0x80,state=OFF,report=OFF]" atIndex:0];
//            [self.tableview reloadData];
//        }else{
//            NSDictionary* paramlist = @{CZJK_PARAM_SENSOR_MODE:[NSNumber numberWithInt:0x80],
//                                        CZJK_PARAM_SENSOR_ONOFF:[NSNumber numberWithBool:YES],
//                                        CZJK_PARAM_SENSOR_REPORT:[NSNumber numberWithBool:YES]};
//            [SXRService SetSensorState:paramlist];
//            self.sensorflag = 1;
//            [self.resultlist insertObject:@"Send Sensor Change [mode=0x80,state=ON,report=ON]" atIndex:0];
//            [self.tableview reloadData];
//       }
//    }else{
//        UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Device not Connected", nil) preferredStyle:UIAlertControllerStyleAlert];
//        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//        [self presentViewController:ac animated:YES completion:nil];
//
//    }
//}

//-(void)refreshInfoLabel{
//    
//    self.infolabel.text = [NSString stringWithFormat:@"HEARTRATE INFO:\n\nSensor Value:  %d\n",self.sensorvalue];
//    
//}

-(void)onReadData:(NSNotification*)notify{
    NSDictionary* param = notify.userInfo;
    int sensorvalue = [[param objectForKey:JY_NOTIFY_PARAM_STEP] intValue];
    self.sensorvalue = sensorvalue;
    NSString* str = [NSString stringWithFormat:@"Recv date,step->[%d]",sensorvalue];
    [self.resultlist insertObject:str atIndex:0];
    [self.tableview reloadData];
//    [self refreshInfoLabel];
    
}
//-(void)onSensorChange:(NSNotification*)notify{
//    NSDictionary* param = notify.userInfo;
//    int sensorstate = [[param objectForKey:CZJK_NOTIFY_PARAM_SENSORSTATE] intValue];
//    int sensortype = [[param objectForKey:CZJK_NOTIFY_PARAM_SENSORTYPE] intValue];
//    self.sensorflag = sensorstate;
//    NSString* str = [NSString stringWithFormat:@"Recv Sensor state ,mode->[%d],state->[%d]",sensortype,sensorstate];
//    [self.resultlist insertObject:str atIndex:0];
//    [self.tableview reloadData];
//    [self refreshInfoLabel];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultlist.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"simplecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"simplecell"];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [self.resultlist objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    return cell;
    
}

//-(void)onCmdFinish:(NSNotification*)notify{
//    NSDictionary* dict = notify.userInfo;
//    int substate = [[dict objectForKey:NOTIFY_KEY_SUBSTATE] intValue];
//    bool isok = [[dict objectForKey:NOTIFY_KEY_ISOK] boolValue];
//    switch (substate) {
//        case SUB_STATE_CZJK_WAIT_SENSOR_CHANGE_RSP:
//            if (isok) {
//                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Sensor State OK", nil) preferredStyle:UIAlertControllerStyleAlert];
//                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//                }]];
//                [self presentViewController:ac animated:YES completion:nil];
//
//            }else{
//                UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Set Sensor State Error", nil) preferredStyle:UIAlertControllerStyleAlert];
//                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//                }]];
//                [self presentViewController:ac animated:YES completion:nil];
//
//            }
//            break;
//        default:
//            break;
//    }
//}

@end
