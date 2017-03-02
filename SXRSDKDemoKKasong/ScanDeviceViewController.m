//
//  ScanDeviceViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/10.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "ScanDeviceViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ScanDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableview;
@property(nonatomic, strong)NSMutableArray* peripharellist;
@property(nonatomic, strong)UILabel* labelcurrent;
@end

@implementation ScanDeviceViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTranslucent:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScanDevice:) name:notify_key_did_scan_device object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceReady:) name:notify_key_did_device_ready object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.peripharellist = [[NSMutableArray alloc] init];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 100, 40)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"Scan" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    btn.layer.cornerRadius = 5;
    
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-80-65-49) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onClickBtn:(UIButton*)sender{
    [self.peripharellist removeAllObjects];
    [[SXR shareInstance] scanDevice:nil withOption:nil];
    [self.tableview reloadData];
}

-(void)onScanDevice:(NSNotification*)notify{
    //    NSLog(@"onScanDevice :%@",notify.userInfo);
    CBPeripheral* p = [notify.userInfo objectForKey:@"peripheral"];
    if (![self.peripharellist containsObject:p]) {
        [self.peripharellist addObject:p];
        [self.tableview reloadData];
    }
}

-(void)onDeviceReady:(NSNotification*)notify{
    [self.navigationController popViewControllerAnimated:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripharellist.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral* p = [self.peripharellist objectAtIndex:indexPath.row];
    UITableViewCell* cell  = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = p.name;
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text = p.identifier.UUIDString;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral* p = [self.peripharellist objectAtIndex:indexPath.row];
    [[SXR shareInstance] stopScanDevice];
    [[SXR shareInstance] connectDeviceWithUUID:p.identifier.UUIDString];
}


@end
