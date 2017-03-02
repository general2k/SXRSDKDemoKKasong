//
//  SXRService.m
//  SXRSDKDemo4Goband
//
//  Created by qf on 16/10/10.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "SXRService.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface SXRService()
@end

@implementation SXRService
+(SXRService *)SharedInstance
{
    static SXRService *service = nil;
    if (service == nil) {
        service = [[SXRService alloc] init];
    }
    return service;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#define GEAR_BLE_NAME_E02PLUS @"power watch2"
#define GEAR_BLE_NAME_E06 @"power watch"
#define GEAR_BLE_NAME_E06PLUS @"power watch+"
#define GEAR_BLE_NAME_TOUCHBAND @"Touch Bands"
#define GEAR_BLE_NAME_E07 @"Smart Watch"
#define GEAR_BLE_NAME_SPRINGBAND @"spring band"
#define GEAR_BLE_NAME_PL3330 @"PL-3330"

+(void)InitSXRSDK{
    [SXR initializeWithProtocolType:SXRSDKProtoclType_KKasong andAppID:DEMO_APPID andSecret:DEMO_SECRET andVid:DEMO_VID];
    NSLog(@"%d",[SXR shareInstance].protocolType);
    [SXR shareInstance].bleNameFilter = ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
        NSLog(@"sxrblenamefilter, %@",peripheral.name);
        if ([peripheral.name hasPrefix:GEAR_BLE_NAME_E02PLUS]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_E06]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_E06PLUS]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_TOUCHBAND]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_E07]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_SPRINGBAND]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_PL3330]) {
            return YES;
        }
        return NO;
    };
    [SXR shareInstance].deviceReady = testDeviceReady;
    
    
    
}
void testDeviceReady(){
    NSLog(@"testDeviceReady");
    NSMutableDictionary* bi = [SXRSDKUtils getDeviceInformation:[SXRSDKConfig getCurrentDeviceUUID]];
    NSString* macid = @"";
    if (bi){
        NSString* tmpid = [bi objectForKey:BONGINFO_KEY_BLEADDR];
        if(tmpid && ![tmpid isEqualToString:@""]){
            macid = tmpid;
        }
    }
    if ([macid isEqualToString:@""]) {
        [SXRService ReadMacID:nil];
    }
    [SXRService ReadFirmware:nil];
    [SXRService ReadTime:nil]; 
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


+(void)GetHistoryData:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_SYNC_HISTORYDATA withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }

}
+(void)SetPersonInfo:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_SET_PERSONINFO withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
 
}

+(void)SetDeviceParam:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_SET_DEVICEPARAM withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}
+(void)ReadTime:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_GET_DEVICETIME withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}
+(void)SetTime:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_SET_DEVICETIME withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}


+(void)ReadFirmware:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_GET_FIRMWARE withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
 
}
+(void)ReadMacID:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_GET_MACID withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
  
}
+(void)ReadCurrentStep:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_GET_CURRENTSTEP withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}
+(void)ReadSportData:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_KKASONG_SYNC_SPORTDATA withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}

@end
