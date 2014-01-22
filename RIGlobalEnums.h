//
//  RIGlobalEnums.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#ifndef RenrenOfficial_iOS_Base_RIGlobalEnums_h
#define RenrenOfficial_iOS_Base_RIGlobalEnums_h

#pragma mark - 日志记录级别
typedef NS_ENUM (NSInteger, RILogLevel) {
    LogLevelOff = LOG_LEVEL_OFF,
    LogLevelError = LOG_LEVEL_ERROR,
    LogLevelWarn = LOG_LEVEL_WARN,
    LogLevelInfo = LOG_LEVEL_INFO,
    LogLevelVerbose = LOG_LEVEL_VERBOSE,
};

extern RILogLevel ddLogLevel;

#pragma mark - 日志记录类别
typedef NS_ENUM (NSInteger, RILogAspect) {
    LogAspectGeneral = 0,
    LogAspectDataRequest = 1,
    LogAspectCoreData = 2,
    LogAspectLogin = 3,
    LogAspectPhoto = 4,
    LogAspectLocation = 5,
    LogAspectTalk = 6,
    LogAspectUtility = 7,
    LogAspectMessageCenter = 8,
};

#pragma mark - 分享列别编码
typedef NS_ENUM (NSInteger, ShareTypeCodeEnum) {
    ShareBlogCode = 1 << 0,
    SharePhotoCode = 1 << 1,
    ShareLinkCode = 1 << 2,
    ShareAlbumCode = 1 << 3,
    ShareVideoCode = 1 << 4,
    SharePageBlogCode = 1 << 5,
    SharePageLinkCode = 1 << 6,
    SharePagePhotoCode = 1 << 7,
    SharePageVideoCode = 1 << 8,
    SharePageAlbumCode = 1 << 9,
    ShareDefault = ShareBlogCode \
    | SharePhotoCode\
    | ShareLinkCode \
    | ShareAlbumCode \
    | ShareVideoCode \
    | SharePagePhotoCode \
    | SharePageVideoCode \
    | SharePageAlbumCode \
    | SharePageBlogCode \
    | SharePageLinkCode,
};

#pragma mark - 分享类别
typedef NS_ENUM (NSInteger, ShareTypeEnum) {
    ShareBlog = 1,
    SharePhoto = 2,
    ShareLink = 6,
    ShareAlbum = 8,
    ShareVideo = 10,
    SharePageBlog = 20,
    SharePageLink = 21,
    SharePagePhoto = 22,
    SharePageVideo = 23,
    SharePageAlbum = 136,
};


#pragma mark - 操作类型
typedef NS_ENUM (NSInteger, ShareOperationTypeEnum) {
    ShareOperation = 0,
    CollectOperation = 1,
};

#pragma mark - 评论排序
typedef NS_ENUM (NSInteger, CommentsSortTypeEnum) {
    OrderByTimeDescending = 0,
    OrderByTimeAscending = 1,
};

#pragma mark - 新鲜事获取类别
typedef NS_ENUM (NSInteger, FeedGetTypeEnum)
{
    FeedGetAll = 1,
    FeedGetFocused,
    FeedGetStatus,
    FeedGetPhoto,
    FeedGetPosition,
    FeedGetShare,
    FeedGetBlog,
    FeedGetOriginal,
    FeedGetCollection,
    FeedGetFriend,
};

static NSString* typeStringForFeedGetType(FeedGetTypeEnum type)
{
    NSString *typeString;
    switch (type) {
        case FeedGetAll:
            typeString = @"102,103,104,107,110,501,502,504,601,701,709,2003,2004,2005,2006,2008,2009,2012,2013,2002,2038";
            break;
        case FeedGetFocused:
            typeString = @"102,103,104,107,110,501,502,504,601,701,709,1101,1104,1105,2003,2004,2005,2006,2008,2009,2012,2013,2015,2002,8905,8906,105";
            break;
        case FeedGetStatus:
            typeString = @"502,2008";
            break;
        case FeedGetPhoto:
            typeString = @"701,709,2013";
            break;
        case FeedGetPosition:
            typeString = @"1101,1104,1105";
            break;
        case FeedGetShare:
            typeString = @"102,103,104,107,110,2003,2004,2005,2006,2009";
            break;
        case FeedGetBlog:
            typeString = @"601,2012";
            break;
        case FeedGetOriginal:
            typeString = @"501,502,504,601,701,709,2008,2012,2013,2002";
            break;
        case FeedGetCollection:
            typeString = @"207";
            break;
        case FeedGetFriend:
            typeString = @"501,502,504,601,701,709";
            break;
        default:
            break;
    }
    return typeString;
}

#pragma mark - 新鲜事类型
typedef NS_ENUM (NSInteger, MNewsFeedType) {
    MNewsFeedTypeShareBlog = 102,
    MNewsFeedTypeSharePhoto = 103,
    MNewsFeedTypeShareAlbum = 104,
    MNewsFeedTypeShareLink = 107,
    MNewsFeedTypeShareVideo = 110,
    MNewsFeedTypeShareVoicePhoto = 111,
    MNewsFeedTypeHeadUpdate = 501,
    MNewsFeedTypeStatus = 502,
    MNewsFeedTypeVoiceStatus = 580,
    MNewsFeedTypeShareStatus = 504,
    MNewsFeedTypeBlog = 601,
    MNewsFeedTypeOnePhoto = 701,
    MNewsFeedTypeTagPhoto = 702,
    MNewsFeedTypeMultiPhoto = 709,
    MNewsFeedTypeAlbum = 65529,
    MNewsFeedTypeVoicePhoto = 710,
    MNewsFeedTypeGiftGive = 801,
    MNewsFeedTypeLBSSignIn = 1101,
    MNewsFeedTypeLBSEvaluation = 1104,
    MNewsFeedTypeLBSWantGo = 1105,
    MNewsFeedTypeAddFriendNote = 1201,
    MNewsFeedTypeSocialGraphicUser = 1209,
    MNewsFeedTypeSocialGraphicHot = 1213,
    MNewsFeedTypeForcusFriend = 1215,
    MNewsFeedTypeGroupFeedGroupAlbumOnePhoto = 1621,
    MNewsFeedTypeGroupFeedGroupAlbumMultiPhoto = 1622,
    MNewsFeedTypeJoinPageNote = 2002,
    MNewsFeedTypeSharePageBlog = 2003,
    MNewsFeedTypeSharePagePhoto = 2004,
    MNewsFeedTypeSharePageLink = 2005,
    MNewsFeedTypeSharePageVideo = 2006,
    MNewsFeedTypePageStatus = 2008,
    MNewsFeedTypeSharePageStatus = 2109,
    MNewsFeedTypeSharePageAlbum = 2009,
    MNewsFeedTypePageBlog = 2012,
    MNewsFeedTypePagePhoto = 2013,
    MNewsFeedTypePageOnePhoto = 2038,
    MNewsFeedTypePageHeadUpdate = 2015,
    MNewsFeedTypeMiniSiteShareBlog = 3801,
    MNewsFeedTypeMiniSiteShareVideo = 3802,
    MNewsFeedTypeMiniSiteSharePhoto = 3803,
    MNewsFeedTypeMiniSiteShareLink = 3804,
    MNewsFeedTypeEDMText = 8001,
    MNewsFeedTypeEDMPhoto = 8002,
    MNewsFeedTypeEDMVideo = 8003,
    MNewsFeedTypeEDMFlash = 8004,
    MNewsFeedTypeEDM8015 = 8015,
    MNewsFeedTypeCheWenPhoto = 8905,
    MNewsFeedTypeCheWenNews = 8906,
    MNewsFeedTypeAdvert = 65530,
    MNewsUserHomeCollectionType = 65531
};

static NSString* prefixForLikeGIDByNewsFeedType(MNewsFeedType feedType)
{
    NSString *feedTypeString = @"";
    switch (feedType) {
        case MNewsFeedTypeStatus:
        case MNewsFeedTypePageStatus:
        {
            feedTypeString = @"status";
            break;
        }
        case MNewsFeedTypeBlog:
        case MNewsFeedTypePageBlog:
        {
            feedTypeString = @"blog";
            break;
        }
        case MNewsFeedTypeOnePhoto:
        case MNewsFeedTypeMultiPhoto:
        case MNewsFeedTypePagePhoto:
        case MNewsFeedTypePageOnePhoto:
        {
            feedTypeString = @"photo";
            break;
        }
        case MNewsFeedTypeShareStatus:
        case MNewsFeedTypeShareBlog:
        case MNewsFeedTypeSharePageBlog:
        case MNewsFeedTypeSharePhoto:
        case MNewsFeedTypeSharePagePhoto:
        case MNewsFeedTypeShareAlbum:
        case MNewsFeedTypeSharePageAlbum:
        case MNewsFeedTypeShareVideo:
        case MNewsFeedTypeSharePageVideo:
        case MNewsFeedTypeShareLink:
        case MNewsFeedTypeSharePageLink:
        {
            feedTypeString = @"share";
            break;
        }
        default:
            break;
    }
    return feedTypeString;
}

static NSString *shareTypeEnumChargeToShareTypeString(ShareTypeCodeEnum shareType)
{
    NSArray *shareTypeArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"6",@"8",@"10",@"20",@"21",@"22",@"23",@"136",nil];
    NSString *shareTypeString = @"";
    NSInteger index = 0;
    BOOL enterOnceFlag = NO;
    for (index = 0; index < shareTypeArray.count; index++) {
        if(shareType & (1 << index)) {
            if (enterOnceFlag) {
                shareTypeString = [shareTypeString stringByAppendingString:@","];
            }
            shareTypeString = [shareTypeString stringByAppendingString:shareTypeArray[index]];
            enterOnceFlag = YES;
        }
    }
    return shareTypeString;
}

typedef NS_ENUM(NSInteger, FeedListReturnTypeEnum)
{
    FeedListReturnNormal = 0,
    FeedListReturnNoFeeds = 1,
    FeedListReturnNoFocusFriendFeeds = 2,
};

typedef NS_ENUM(NSInteger, FeedSavestrategyTypeEnum)
{
    FeedSavestrategySave,
    FeedSavestrategyNotSave,
};

typedef NS_ENUM (NSInteger, FeedLoadingSceneEnum)
{
    FeedLoadingSceneNone = 0,
    FeedLoadingSceneUserFeed = 1 << 0,
    FeedLoadingSceneAllFeed = 1 << 1,
    FeedLoadingSceneAllFriendFeed = 1 << 2,
    FeedLoadIngSceneFocused = 1 << 3,
};

#pragma mark -- pushType
typedef NS_ENUM (NSInteger,PushTypeEnum) {
    IPHONE_RENREN = 1,
    IPAD_RENREN = 3,
};

#pragma mark - 隐私权限设置
typedef NS_ENUM (NSInteger, VisiblePermissionEnum) {
    VisiblePermissionSelfOnly = -1,
    VisiblePermissionFriendsOnly = 1,
    VisiblePermissionPasswordNeeded = 4,
    VisiblePermissionPublic = 99,
};

#pragma mark - 相册上传方式
typedef NS_ENUM (NSInteger, PhotoUploadModeEnum) {
    HomePagePhotoUpload = 1,
    HomePageAlbumUpload = 2,
    POIPagePhotoUpload = 3,
    POIPageAlbumUpload = 4,
    OpenPlatformUpload = 5,
};

#pragma mark - 默认相册选择
typedef NS_ENUM (NSInteger, DefaultAlbumEnum) {
    PhoneAlbum = 0,
    FastUploadAlbum = 1,
    VoiceAlbum = 2,
    PadAlbum = 4,
};

#pragma mark - 表情使用场景
typedef NS_ENUM (NSInteger, EmotionUsingSceneEnum) {
    EmotionUsingSceneUnknown,
    EmotionUsingSceneStatus,
    EmotionUsingSceneChat,
};

#pragma mark - 搜索条件
typedef NS_ENUM (NSInteger, searchConditonTypeEnum)
{
    searchConditonTypeStage = 101,
    searchConditonTypeWorkPlace = 1,
    searchConditonTypeSchool = 2,
    searchConditonTypePerson = 4,
    searchConditonTypeFull = 102,
};

#pragma mark - field
typedef NS_ENUM (NSInteger, pageGetInfoFieldTypeEnum)
{
    pageGetInfoFieldStatus = 1 << 0,
    pageGetInfoFieldIntroduce = 1 << 1,
    pageGetInfoFieldAblumCount = 1 << 2,
    pageGetInfoFieldFansCount = 1 << 3,
    pageGetInfoFieldContactInfo = 1 << 4,
    pageGetInfoFieldBaseInfo = 1 << 5,
    pageGetInfoFieldBlogsCount = 1 << 6,
    pageGetInfoFieldDetailInfo = 1 << 7,
    pageGetInfoFieldUGCCount = 1 << 8,
    pageGetInfoFieldDefault =  pageGetInfoFieldStatus\
    | pageGetInfoFieldIntroduce\
    | pageGetInfoFieldAblumCount\
    | pageGetInfoFieldFansCount\
    | pageGetInfoFieldContactInfo\
    | pageGetInfoFieldBaseInfo\
    | pageGetInfoFieldBlogsCount\
    | pageGetInfoFieldDetailInfo\
    | pageGetInfoFieldUGCCount,
};

#pragma mark -blog
typedef NS_ENUM(NSInteger, CommentReplyType)
{
    CommentReplyPublic = 0,
    CommentReplyPrivate = 1,
};

#pragma mark -gender
typedef NS_ENUM(NSInteger, GenderType)
{
    GenderFemale = 0,
    GenderMale = 1,
    GenderDefault = 2
};

#pragma mark -uploadPhoto
typedef NS_ENUM(NSInteger, UploadPhotoType)
{
    UploadPhotoFromHomePagePhotograph = 1,
    UploadPhotoFromHomePageAlbum = 2,
    UploadPhotoFromPhotographWithGeoInfo = 3,
    UploadPhotoFromGeographyAlbum = 4,
    UploadPhotoFromOpenPlatformPhoto = 5
};

#pragma mark -extendInfo
typedef NS_ENUM(NSInteger, ExtendInfoType)
{
    extendInfoLargeURL = 0,
    extendInfoMainURL = 1,
};

#pragma mark -extendInfo
typedef NS_ENUM(NSInteger, PushServerIDType)
{
    IPHONEServerOfficialClientID = 1,
    IPHONEServerPrivateLetterClientID = 2,
    IPADServerOfficialClientID = 3,
    NOKIAServerOfficialClientID = 4,
    WINDOWS7ServerOfficialClientID = 5,
    WINDOWS7ServerPrivateLetterClientID = 6,
    WINDOWS8ServerPrivateLetterClientID = 7
};
#pragma mark --userInfoType
typedef NS_ENUM(NSInteger, GetUserInfoType)
{
    UserInfoGender = 0x1,
    UserInfoBirth = 0x2,
    UserInfoHometown = 0x4,
    UserInfoPersonal = 0x8,
    UserInfoUniversityList = 0x10,
    UserInfoWorkplaceList = 0x40,
    UserInfoIsOnline = 0x80,
    UserInfoisFillStage = 0x100,
    UserInfoUserStatus = 0x200,
    UserInfoIsFocuseFriend = 0x400,
    UserInfoHeadUrl = 0x800,
    UserInfoMainUrl = 0x1000,
    UserInfoLargerUrl = 0x2000,
    UserInfoPrefixUrl = 0x4000,
    UserInfoHighSchoolList = 0x8000,
    UserInfoCollegeList = 0x10000,
    UserInfoJuniorHighSchool = 0x20000,
    UserInfoElementarySchoolList = 0x40000,
    UserInfoAstrology = 0x80000,
    UserInfoBindedMobile = 0x100000,
    UserInfoRegionInfo = 0x200000,
    UserInfoDefault = 0xFFFFFF
};

typedef enum {
    dataArrayAscendingOrder = 0,
    dataArrayReverseOrder
} dataArraySortEnum;

///push状态查询类别
typedef NS_ENUM(NSInteger, RIPushTypeEnum) {
    RIPushTypeSpecialFriends = 1,
    RIPushTypeChat = 2,
    RIPushTypePublicAccount = 3
};

#pragma mark -- LBSGroupType
typedef NS_ENUM(NSInteger, RILBSGroupTypeEnum) {
    RILBSGroupFreshman = 0,
    RILBSGroupInterest = 1,
    RILBSGroupPage = 2,
    RILBSGroupPrivate = 3
};

typedef NS_ENUM(NSInteger, RIGroupMessageType) {
    RIGroupMessageTypeUnknown = 0,
    RIGroupMessageTypeApplicationAgreed = 2,
    RIGroupMessageTypeApplicationRejected = 3,
    RIGroupMessageTypeInvitation = 8,
};

typedef NS_ENUM(NSInteger, RIGroupMessageHandledType) {
    RIGroupMessageHandledTypeUnHandled = 0,
    RIGroupMessageHandledTypehandled = 1,
    RIGroupMessageHandledTypeAccepted = 2,
    RIGroupMessageHandledTypeRejected = 3,
};

#pragma mark -- LBSGroupMessageNotifyType
typedef NS_ENUM(NSInteger, RIGroupMessageNotifyType) {
    RIGroupMessageHandledTypeNotify = 1,
    RIGroupMessageHandledTypeUnNotify = 2,
};

#pragma mark -- LBSGroupMemberType
typedef NS_ENUM(NSInteger, RILBSGroupMemberType) {
    RILBSGroupOwner= 1,
    RILBSGroupAdmin = 2,
    RILBSGroupMember = 3,
    RILBSGroupVisitor = 4,
};

#pragma mark - 默认相册类型
typedef NS_ENUM (NSInteger, AlbumTypeEnum) {
    DefaultAlbumType = 0,
    PhoneAlbumType = 1,
    FastUploadAlbumType = 2,
    HeadCoverAlbumType = 3,
};

#endif

