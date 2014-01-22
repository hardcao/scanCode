//
//  RISetting.m
//  studyBase
//
//  Created by renren on 14-1-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

//
//  RISettings.m
//  RenrenOfficial-iOS-Base
//
//  Created by Jonathan Dong on 13-4-10.
//  Copyright (c) 2013年 Renren-inc. All rights reserved.
//

#import "RISetting.h"

#import "UIDevice+AdditionalInfo.h"
#import "RRKeyChain.h"

#define BUILD_FOR_IPAD

#ifdef BUILD_FOR_IPAD
static NSString * const appIDDefault = @"243151";
static NSString* const appStoreIDDefault = @"455215726";
static NSString* const apiKeyDefault = @"20b2d2fe6c8745099ceadd9bbc24a2ff";
static NSString* const appSecretKeyDefault = @"e284c7d331414c4fb0621ce06c4ecea6";
static NSString* const clientNameDefault = @"Renren_iPad";
#else
static NSString * const appIDDefault = @"215897";
static NSString* const appStoreIDDefault = @"316709252";
static NSString* const apiKeyDefault = @"03247d142a9f4842ae766b286595979d";
static NSString* const appSecretKeyDefault = @"8ffb0169fae9422dabb084cfe4d34d81";
static NSString* const clientNameDefault = @"xiaonei_iphone";
#endif

static NSString * const apiURLDefault = @"http://api.m.renren.com/api";
static NSString * const fromIDDefault = @"2000505";
static NSString * const kRenRenChatHostName = @"talk.m.renren.com";
static const NSInteger kRenRenChatHostPort = 25553;
static NSString * const kRIChatDomainForSingleChat = @"talk.m.renren.com";
static NSString * const kRIChatDomainForMultiUserChat = @"muc.talk.renren.com";
static int const kRIChatServerVersion = 22;
static NSString * const feedBackURLDefault = @"http://3g.renren.com/help/guestbook.do?";
static NSString * const appCentetURLDefault = @"http://3gapp.renren.com?access_version=1";
static NSString * const searchFriendsURLDefault = @"http://mt.renren.com/client/search";
static NSString * const ignoreStrangerChatMessageSwitchStateKeyInUserDefaults = @"ignoreStrangerChatMessageSwitchStateKey";
static NSString * const specialFocusNewsFeedSwitchStateKeyInUserDefaults = @"specialFocusNewsFeedSwitchStateKey";

@implementation RISetting

+ (RISetting*) globalSettings
{
    static dispatch_once_t once;
    static RISetting *_sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[RISetting alloc] initWithDefaults];
    });
    return _sharedInstance;
}

- (RISetting*) initWithDefaults
{
    if (self = [super init]) {
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        
        self.appStoreID = appStoreIDDefault;
        self.appBundleID = [bundleInfo objectForKey:(NSString*)kCFBundleIdentifierKey];
        self.appID = appIDDefault;
        self.appSecretKey = appSecretKeyDefault;
        self.fromID = fromIDDefault;
        self.apiURL = [NSURL URLWithString:[self getMCSServer]];
        self.apiKey = apiKeyDefault;
        self.clientName = clientNameDefault;
        self.version = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        self.buildVersion = [bundleInfo objectForKey:(NSString*)kCFBundleVersionKey];
        self.deviceModelName = [UIDevice deviceModelName];
        self.deviceSystemVersion = [UIDevice currentDevice].systemVersion;
        self.udid = [RRKeyChain sharedUUIDString];
        self.userAgent = [NSString stringWithFormat:@"%@%@", self.clientName, self.version];
        self.clientInfo = [UIDevice clientInfo:self.fromID version:self.buildVersion userAgent:self.userAgent];
        self.feedBackURL = feedBackURLDefault;
        self.searchFriendsURL = searchFriendsURLDefault;
        self.appCenterURL = appCentetURLDefault;
        self.specialFocusNewsFeedSwitchState = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults]  objectIsForcedForKey:ignoreStrangerChatMessageSwitchStateKeyInUserDefaults]) {
        self.ignoreStrangerChatMessageSwitchState = [[NSUserDefaults standardUserDefaults]boolForKey:ignoreStrangerChatMessageSwitchStateKeyInUserDefaults];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:specialFocusNewsFeedSwitchStateKeyInUserDefaults]) {
        self.specialFocusNewsFeedSwitchState = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:specialFocusNewsFeedSwitchStateKeyInUserDefaults]).boolValue;
    }
    
    return self;
}

#pragma mark ServerSetting
- (NSArray *)getServerSettingData:(SettingPageEnum)itemType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * plistPath = [documentsDirectory stringByAppendingPathComponent:@"ServerSetting.plist"];
    NSMutableDictionary *ServerInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (!ServerInfo) {
        ServerInfo = [NSMutableDictionary dictionary];
    }
    NSArray *rowContentArray = nil;
    switch (itemType) {
        case kSettingPageMobileClientServerURL:
        {
            NSMutableArray *moblieClientServerURLArray = [ServerInfo objectForKey:@"MCSServer"];
            if (!moblieClientServerURLArray) {
                moblieClientServerURLArray = [NSMutableArray arrayWithArray:@[@{@"name":@"http://api.m.renren.com/api",@"status":@(YES)},@{@"name":@"http://mc1.test.renren.com/api",@"status":@(NO)},@{@"name":@"http://mc2.test.renren.com/api",@"status":@(NO)},@{@"name":@"http://mc3.test.renren.com/api",@"status":@(NO)}]];
                [ServerInfo setObject:moblieClientServerURLArray forKey:@"MCSServer"];
                [ServerInfo writeToFile:plistPath atomically:YES];
            }
            rowContentArray = moblieClientServerURLArray;
            break;
        }
        case kSettingPageChatServerURL:
        {
            NSArray *chatServerURLArray = [ServerInfo objectForKey:@"TalkServerAddress"];
            if (!chatServerURLArray) {
                chatServerURLArray = [NSMutableArray arrayWithArray:@[@{@"name":@"talk.m.renren.com",@"status":@(YES)},@{@"name":@"talk.test.renren.com",@"status":@(NO)},@{@"name":@"talk.apis.tk",@"status":@(NO)}]];
                [ServerInfo setObject:chatServerURLArray forKey:@"TalkServerAddress"];
                [ServerInfo writeToFile:plistPath atomically:YES];
            }
            rowContentArray = chatServerURLArray;
            break;
        }
        case kSettingPageChatServerPort:
        {
            NSArray *chatServerPortArray = [ServerInfo objectForKey:@"TalkServerPort"];
            if (!chatServerPortArray) {
                chatServerPortArray = [NSMutableArray arrayWithArray:@[@{@"name":@"25553",@"status":@(YES)},@{@"name":@"25554",@"status":@(NO)},@{@"name":@"2903",@"status":@(NO)}]];
                [ServerInfo setObject:chatServerPortArray forKey:@"TalkServerPort"];
                [ServerInfo writeToFile:plistPath atomically:YES];
            }
            rowContentArray = chatServerPortArray;
        }
        default:
            break;
    }
    return rowContentArray;
}

- (void)saveSettingData:(SettingPageEnum)itemType saveContent:(NSString *)contentsToSave
{
    NSString *dataKey = nil;
    switch (itemType) {
        case kSettingPageMobileClientServerURL: {
            dataKey = @"MCSServer";
            break;
        }
        case kSettingPageChatServerURL:
            dataKey = @"TalkServerAddress";
            break;
        case kSettingPageChatServerPort:
            dataKey = @"TalkServerPort";
            break;
        default:
            break;
    }
    if (dataKey) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * plistPath = [documentsDirectory stringByAppendingPathComponent:@"ServerSetting.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSMutableArray *Servers = [data objectForKey:dataKey];
        BOOL isNewValue = YES;
        if (Servers) {
            for (NSMutableDictionary *svr in Servers) {
                NSString *url = [svr objectForKey:@"name"];
                if ([url compare:contentsToSave] == NSOrderedSame) {
                    [svr setObject:@(YES) forKey:@"status"];
                    isNewValue = NO;
                }
                else {
                    [svr setObject:@(NO) forKey:@"status"];
                }
            }
        }
        if (isNewValue) {
            [Servers addObject:@{@"name":contentsToSave,@"status":@(YES)}];
        }
        [data writeToFile:plistPath atomically:YES];
    }
}

- (void)deleteSettingData:(SettingPageEnum)itemType deleteContent:(NSString *)contentsToDelete
{
    NSString *dataKey = nil;
    switch (itemType) {
        case kSettingPageMobileClientServerURL:
            dataKey = @"MCSServer";
            break;
        case kSettingPageChatServerURL:
            dataKey = @"TalkServerAddress";
            break;
        case kSettingPageChatServerPort:
            dataKey = @"TalkServerPort";
            break;
        default:
            return;
    }
    if (dataKey) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * plistPath = [documentsDirectory stringByAppendingPathComponent:@"ServerSetting.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSMutableArray *Servers = [data objectForKey:dataKey];
        for (NSMutableDictionary *svr in Servers) {
            NSString *url = [svr objectForKey:@"name"];
            if ([url isEqualToString:contentsToDelete]) {
                [Servers removeObject:svr];
                [data writeToFile:plistPath atomically:YES];
                break;
            }
        }
    }
}

- (NSString *)getMCSServer
{
#ifdef DEBUG
    for (NSDictionary *dic in [self getServerSettingData:kSettingPageMobileClientServerURL]) {
        if (dic && [[dic objectForKey:@"status"] boolValue]) {
            return [dic objectForKey:@"name"];
        }
    }
#endif
    return apiURLDefault;
}

- (NSString *)getTalkServerUrl
{
#ifdef DEBUG
    for (NSDictionary *dic in [self getServerSettingData:kSettingPageChatServerURL]) {
        if (dic && [[dic objectForKey:@"status"] boolValue]) {
            return [dic objectForKey:@"name"];
        }
    }
#endif
    return kRenRenChatHostName;
}

- (NSInteger)getTalkServerPort
{
#ifdef DEBUG
    for (NSDictionary *dic in [self getServerSettingData:kSettingPageChatServerPort]) {
        if (dic && [[dic objectForKey:@"status"] boolValue]) {
            return [[dic objectForKey:@"name"] integerValue];
        }
    }
#endif
    return kRenRenChatHostPort;
}
#pragma mark Push
// 判断系统push开关是否打开以决定打开聊天的push开关
- (NSString *)pushSettingEnable
{
    NSString * retString = @"false";
    
    UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if ( (UIRemoteNotificationTypeBadge & notificationType)
        || (UIRemoteNotificationTypeAlert & notificationType)) {
        retString = @"true";
    }
    
    return  retString;
}

- (void)setIgnoreStrangerChatMessageSwitchState:(BOOL)isIgnore
{
    _ignoreStrangerChatMessageSwitchState = isIgnore;
    [[NSUserDefaults standardUserDefaults] setBool:self.ignoreStrangerChatMessageSwitchState forKey:ignoreStrangerChatMessageSwitchStateKeyInUserDefaults];
}
@end
