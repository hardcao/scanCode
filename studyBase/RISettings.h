//
//  RISetting.h
//  studyBase
//
//  Created by renren on 14-1-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kSettingPageMobileClientServerURL = 0,
    kSettingPageChatServerURL = 1,
    kSettingPageChatServerPort = 2
} SettingPageEnum;

@interface RISettings : NSObject

@property (nonatomic, copy) NSString *appStoreID;
@property (nonatomic, copy) NSString *appBundleID;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appSecretKey;
@property (nonatomic, copy) NSString *fromID;
@property (nonatomic, copy) NSURL *apiURL;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *buildVersion;
@property (nonatomic, copy) NSString *deviceModelName;
@property (nonatomic, copy) NSString *deviceSystemVersion;
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *clientInfo;
@property (nonatomic, copy) NSString *feedBackURL;
@property (nonatomic, copy) NSString *appCenterURL;
@property (nonatomic, copy) NSString *searchFriendsURL;
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, assign) BOOL ignoreStrangerChatMessageSwitchState;
@property (nonatomic, assign) BOOL specialFocusNewsFeedSwitchState;

+ (RISettings*) globalSettings;
- (NSString *)pushSettingEnable;
- (void)saveSettingData:(SettingPageEnum)itemType saveContent:(NSString *)contentsToSave;
- (void)deleteSettingData:(SettingPageEnum)itemType deleteContent:(NSString *)contentsToDelete;
- (void)setIgnoreStrangerChatMessageSwitchState:(BOOL)isIgnore;

@end
