//
//  CommonDefine.h
//  IntelligentRingKing
//
//  Created by qf on 14-5-11.
//  Copyright (c) 2014年 JAGA. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height >= 568)


#define DEMO_APPID @"test"
#define DEMO_SECRET @"test"
#define DEMO_VID @"000004001004"

//默认为男性 gender is male
#define DEMO_GENDER 1
#define DEMO_HEIGHT 170.0f
#define DEMO_WEIGHT 65.0f
#define DEMO_STRIDE 45.0f
#define DEMO_BLOODTYPE @"O"
#define DEMO_BIRTH @"1980-01-01"
#define DEMO_NICKNAME @"TestSXRSDKUSER"
//默认为公制，demo unit is METRIX
#define DEMO_UNIT 1
#define DEMO_SCREENTIME 10
#define DEMO_SLEEPSTARTHOUR 22
#define DEMO_SLEEPENDHOUR 8
#define DEMO_ALARM_SNOOZE 5
#define DEMO_ALARM_ENABLE 1
#define DEMO_ALARM_SNOOZE_REPEAT 1
#define DEMO_TARGET_STEP 10000

//闹钟周期为每天
#define DEMO_ALARM_WEEKLY 0x7F
#define GEAR_TYPE @"001"


#define TEMP_TYPE_C 1
#define TEMP_TYPE_F 0


#define MAX_MAIN_PAGE_COUNT  5

#define GEAR_BLE_NAME_S1 @"WannaFit-T1D"
#define GEAR_BLE_NAME_S3 @"WannaFit-T3D"
#define GEAR_BLE_NAME_S9 @"WannaFit-T9D"
#define GEAR_BLE_NAME_S10 @"WannaFit-T10D"
#define GEAR_BLE_NAME_F1 @"WannaFit-G1D"
#define GEAR_BLE_NAME_U9 @"WannaFit-U9D"
#define GEAR_BLE_NAME_X6 @"iiwatch-X6"

#endif
