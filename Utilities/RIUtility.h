//
//  RIUtility.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

extern NSString * const kEmotionPlistName;

@class MPlacePOIInfo, NSFetchRequest, SDImageCache;

@interface RIUtility : NSObject

+ (NSString *)documentDirectory;
+ (NSString *)commonDirectory;
+ (NSString *)emotionDictory;
+ (NSString *)backgroundImageDictory;
+ (NSString *)backgroundThumbnailImageDictory;
+ (NSString *)backgroundOriginalImageDictory;
+ (NSString *)filterSampleImageDirectory;
+ (NSString *)absolutePathForResourcePath:(NSString *)path;
+ (NSString *)relativePathForResourcePath:(NSString *)path;
+ (SDImageCache *)chatImageCache;
+ (NSString *)saveResouceData:(NSData *)data;
+ (NSString *)userDirectoryForUserID:(NSNumber *)userID;
+ (NSString *)signature:(NSDictionary *)parameters secretKey:(NSString*)secretKey;
+ (NSMutableArray *)mergeArray:(NSArray *)aArray intoArray:(NSArray *)bArray uniqueKeyPath:(NSString *)keyPath;
+ (void)cleanCacheWithFetchRequest:(NSFetchRequest *)fetchRequest reservedData:(NSArray *)array;
+ (void)replaceCacheWithManagedObjectArray:(NSArray *)newArray;
+ (NSString *)requestStringForParametersWithSecretKey:(NSDictionary *)parameters;
+ (void)copyEmotionPlistToLocalDiskWhenAppFirstRun;
+ (NSBundle *)emotionBundle;
+ (NSBundle *)defaultBackgroundImageBundle;
+ (NSBundle *)defaultBackgroundThumbnailImageBundle;
+ (NSBundle *)defaultBackgroundOriginalImageBundle;
+ (NSString *)errorStringForCode:(NSString *)errorCode;
+ (NSString *)networkUnreachableString;
//根据userid获取头像url,目前主要用于服务器没下发的原作者头像
+ (NSString *)headURLByUserID:(NSNumber *)userID;
+ (NSString *)headURLByJabberID:(NSString *)jabberID;
+ (id)objectFromPlist:(NSString *)pilstName;

//数据持久化
+ (BOOL)saveToPersistence;
+ (id)insertNewObjectForEntityForName:(NSString *)entityName;

//拼装讨论组头像
+ (void)constructMucGroupHeadImageWithHeadURLs:(NSArray *)headURLs imageView:(UIImageView *)imageView;

//单队列操作数据的删除，解析
+ (dispatch_queue_t)serialManagedObjectOperateQueue;

@end
