//
//  CurrentDeviceInfoViewController.m
//  CZJKFuncList
//
//  Created by qf on 16/10/12.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "CurrentDeviceInfoViewController.h"

@interface CurrentDeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableview;
@property(nonatomic, strong)NSDictionary* bonginfo;
@end

@implementation CurrentDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bonginfo = [SXRSDKUtils getDeviceInformation:[SXRSDKConfig getCurrentDeviceUUID]];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-65) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];

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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bonginfo.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"simplecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"simplecell"];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text =[NSString stringWithFormat:@"%@" ,[self.bonginfo objectForKey:[self.bonginfo.allKeys objectAtIndex:indexPath.row]] ];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@" ,[self.bonginfo.allKeys objectAtIndex:indexPath.row] ];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.5;
  
    return cell;
    
}
@end
