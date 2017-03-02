//
//  SXRService.h
//  SXRSDKDemo4Goband
//
//  Created by qf on 16/10/10.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"

@interface SXRService : NSObject
+(SXRService*)SharedInstance;
+(void)InitSXRSDK;
+(void)GetHistoryData:(NSDictionary*)paramlist;
+(void)SetPersonInfo:(NSDictionary*)paramlist;
+(void)SetDeviceParam:(NSDictionary*)paramlist;
+(void)ReadTime:(NSDictionary*)paramlist;
+(void)SetTime:(NSDictionary*)paramlist;
+(void)ReadFirmware:(NSDictionary*)paramlist;
+(void)ReadMacID:(NSDictionary*)paramlist;
+(void)ReadCurrentStep:(NSDictionary*)paramlist;
+(void)ReadSportData:(NSDictionary*)paramlist;
@end
