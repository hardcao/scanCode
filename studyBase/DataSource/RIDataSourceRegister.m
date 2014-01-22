//
//  RIDataSourceRegister.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIDataSourceRegister.h"
#import "RIPhoneClientRequest.h"
#import "RIBlogRequests.h"
#import "RIDataSource.h"
#import "RIFeedRequests.h"
#import "RIFriendsRequests.h"
#import "RILoginRequest.h"
#import "RILikeRequests.h"
#import "RIMessageBoardRequests.h"
#import "RIPageRequest.h"
#import "RIPastTodayRequest.h"
#import "RIPhotosRequests.h"
#import "RIPlaceRequests.h"
#import "RIShareRequests.h"
#import "RIStatisticLogRequest.h"
#import "RIStatusRequests.h"
#import "RITalkVoiceUploadBin2Request.h"
#import "RIUserRequests.h"
#import "RIGetMessageListRequest.h"
#import "RIMarkMessageReadByMessageIdRequest.h"
#import "RIRemoveMessagesByMessageIdsRequest.h"
#import "RIPushRequests.h"
#import "RILBSGroupGetGroupsForUserRequest.h"
#import "MError.h"
#import "RIPhoneClientActiveClientRequest.h"
#import "RIPhoneClientEventLogRequest.h"
#import "RILBSGroupRequests.h"

@implementation RIDataSourceRegister

+ (void) registerRequestAndResponseToDataSource:(RIDataSource*)dataSource
{
    // Request registrations
    [dataSource registerRequestAndResponse:RIAtGetRecentAtFriendsRequest.class];
    [dataSource registerRequestAndResponse:RIBlogAddRequest.class];
    [dataSource registerRequestAndResponse:RIBlogAddCommentRequest.class];
    [dataSource registerRequestAndResponse:RIBlogDeleteRequest.class];
    [dataSource registerRequestAndResponse:RIBlogDeleteCommentRequest.class];
    [dataSource registerRequestAndResponse:RIBlogGetCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIBlogGetRequest.class];
    [dataSource registerRequestAndResponse:RIBlogGetsRequest.class];
    [dataSource registerRequestAndResponse:RIDefaultEmotionRequest.class];
    [dataSource registerRequestAndResponse:RIFeedBanFriendRequest.class];
    [dataSource registerRequestAndResponse:RIFeedDeleteRequest.class];
    [dataSource registerRequestAndResponse:RIFeedGetByIDsRequest.class];
    [dataSource registerRequestAndResponse:RIFeedGetRequest.class];
    [dataSource registerRequestAndResponse:RIFeedGetsRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsApplyListRequst.class];
    [dataSource registerRequestAndResponse:RIFriendsAcceptRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsAddFriendRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsDenyRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsDenyAllRequest.class];
    [dataSource registerRequestAndResponse:RIFriendDeleteFocusFriendRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsGetBanFriendsRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsGetFriendsRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsRecommendRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsRemoveFriendRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsSearchRequst.class];
    [dataSource registerRequestAndResponse:RIFriendsUnBanfriendRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsSearchFriendsRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsSearchWithConditionRequest.class];
    [dataSource registerRequestAndResponse:RIFriendsGetSharedFriendsRequest.class];
    [dataSource registerRequestAndResponse:RIFriendAddFocusFriendRequest.class];
    [dataSource registerRequestAndResponse:RIGetFriendBirthdayListRequest.class];
    [dataSource registerRequestAndResponse:RIGetMessageListRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupCreateGroupRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupCreatePrivateGroupRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupHandleJoinGroupRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetGroupsForUserRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetGroupByLocationRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetGroupsByKeywordRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetGroupProfileRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetRecommendGroupsRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetMembersRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupGetCoverRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupJoinGroupRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupLeaveGroupRequest.class];
    [dataSource registerRequestAndResponse:RILBSGroupSetGroupMessageNotifyRequest.class];
    [dataSource registerRequestAndResponse:RILoginAutoLoginRequest.class];
    [dataSource registerRequestAndResponse:RILoginRequest.class];
    [dataSource registerRequestAndResponse:RILoginInfoRequest.class];
    [dataSource registerRequestAndResponse:RILogoutRequest.class];
    [dataSource registerRequestAndResponse:RILikeAddRequest.class];
    [dataSource registerRequestAndResponse:RILikeCancelRequest.class];
    [dataSource registerRequestAndResponse:RILikeGetUsersByGidRequest.class];
    [dataSource registerRequestAndResponse:RIMarkMessageReadByMessageIdRequest.class];
    [dataSource registerRequestAndResponse:RIMessageBoardDeleteRequest.class];
    [dataSource registerRequestAndResponse:RIMessageBoardGetsRequest.class];
    [dataSource registerRequestAndResponse:RIMessageBoardPostRequest.class];
    [dataSource registerRequestAndResponse:RIPastTodayRequest.class];
    [dataSource registerRequestAndResponse:RIPageUserListRequest.class];
    [dataSource registerRequestAndResponse:RIPageIsPageRequest.class];
    [dataSource registerRequestAndResponse:RIPageIsFanRequest.class];
    [dataSource registerRequestAndResponse:RIPageBecomeFanRequest.class];
    [dataSource registerRequestAndResponse:RIPageGetInfoRequest.class];
    [dataSource registerRequestAndResponse:RIPageGetFansListRequest.class];
    [dataSource registerRequestAndResponse:RIPageRecommendRequest.class];
    [dataSource registerRequestAndResponse:RIPageQuitFanRequest.class];
    [dataSource registerRequestAndResponse:RIPageSearchRequest.class];
    [dataSource registerRequestAndResponse:RIPhoneClientActiveClientRequest.class];
    [dataSource registerRequestAndResponse:RIPhoneClientGetUpdateInfoRequest.class];
    [dataSource registerRequestAndResponse:RIPhoneClientEventLogRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosAddCommentRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosAddPhotosViewCountRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosCreateAlbumRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosDeleteRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosDeleteCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetAlbumsRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetAroundRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetCoverRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetPhotosWithChildIdRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosGetRequest.class];
    [dataSource registerRequestAndResponse:RIPhotoSendFeedRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosUploadBinRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosUploadCoverRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosUploadHeadRequest.class];
    [dataSource registerRequestAndResponse:RIPhotosUploadOnlyRequest.class];
    [dataSource registerRequestAndResponse:RIPlacePOICollectionFlowRequest.class];
    [dataSource registerRequestAndResponse:RIPlacePOIListRequest.class];
    [dataSource registerRequestAndResponse:RIPlacePreLocateRequest.class];
    [dataSource registerRequestAndResponse:RIPlaceGetCheckinCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIPlaceGetEvaluationCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIPlaceGetNearbyUserRequest.class];
    [dataSource registerRequestAndResponse:RIPlaceRemoveLocateInfoRequest.class];
    [dataSource registerRequestAndResponse:RIPushAddTokenRequest.class];
    [dataSource registerRequestAndResponse:RIPushAddTokenNoRegRequest.class];
    [dataSource registerRequestAndResponse:RIPushGetStateRequest.class];
    [dataSource registerRequestAndResponse:RIPushSetStateRequest.class];
    [dataSource registerRequestAndResponse:RIPushSetUndisturbedTimeRequest.class];
    [dataSource registerRequestAndResponse:RIProfileGetInfoRequest.class];
    [dataSource registerRequestAndResponse:RIRemoveMessagesByMessageIdsRequest.class];
    [dataSource registerRequestAndResponse:RIShareAddCommentRequest.class];
    [dataSource registerRequestAndResponse:RIShareDeleteRequest.class];
    [dataSource registerRequestAndResponse:RIShareGetCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIShareGetHotsRequest.class];
    [dataSource registerRequestAndResponse:RIShareGetRequest.class];
    [dataSource registerRequestAndResponse:RIShareGetsRequest.class];
    [dataSource registerRequestAndResponse:RISharePublishRequest.class];
    [dataSource registerRequestAndResponse:RIStatisticLogRequest.class];
    [dataSource registerRequestAndResponse:RIStatusAddCommentRequest.class];
    [dataSource registerRequestAndResponse:RIStatusGetVoiceCommentsListRequest.class];
    [dataSource registerRequestAndResponse:RIVoiceCommentRequest.class];
    [dataSource registerRequestAndResponse:RIStatusForwardRequest.class];
    [dataSource registerRequestAndResponse:RIStatusGetCommentsRequest.class];
    [dataSource registerRequestAndResponse:RIStatusGetRequest.class];
    [dataSource registerRequestAndResponse:RIStatusGetsRequest.class];
    [dataSource registerRequestAndResponse:RIStatusGetVoiceByIdRequest.class];
    [dataSource registerRequestAndResponse:RIStatusRemoveRequest.class];
    [dataSource registerRequestAndResponse:RIStatusRemoveCommentRequest.class];
    [dataSource registerRequestAndResponse:RIStatusSetRequest.class];
    [dataSource registerRequestAndResponse:RITalkVoiceUploadBin2Request.class];
    [dataSource registerRequestAndResponse:RIUserGetInfoRequest.class];
    [dataSource registerRequestAndResponse:RIUserGetInfoForPrivateRequest.class];
    [dataSource registerRequestAndResponse:RIUserGetVisitorsRequest.class];
    [dataSource registerRequestAndResponse:RIUserPasswordChangeRequest.class];
    // error registration
    // 这里使用了RestKit的一个known tricks：对于nil和@""的keyPath，RestKit将之当作两个不同的路径，并会用后注册
    // 该keyPath的mapping对象覆盖之前注册的对象。
    // 因此工程将人为规定：只有MError的keyPath可以注册到@""上，其它response mapping对象的keyPath只能注册到nil。
    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[MError dataMapping]
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:@""
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager]addResponseDescriptor:errorDescriptor];
}

@end
