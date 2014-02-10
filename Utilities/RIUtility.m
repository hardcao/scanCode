//
//  RIUtility.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIUtility.h"

#import <objc/runtime.h>
#import "RIDataSource.h"
#import "JSONModel.h"
#import "NSData+MD5Digest.h"
#import "SDImageCache.h"

void HandleException(NSException *exception);

NSString * const kEmotionPlistName = @"emotions.plist";
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

//TODO:将对象的字段映射到MCS所需的字段
#pragma mark - 上传使用的place info
@interface MUploadPlaceInfo : JSONModel

@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSNumber *place_longitude;
@property (nonatomic, strong) NSNumber *place_latitude;
@property (nonatomic, strong) NSNumber *gps_longitude;
@property (nonatomic, strong) NSNumber *gps_latitude;
@property (nonatomic, strong) NSNumber *d;
@property (nonatomic, strong) NSNumber *locate_type;
@property (nonatomic, strong) NSNumber *source_type;
@property (nonatomic, strong) NSString *place_name;
@property (nonatomic, strong) NSNumber *privacy;

@end

@implementation MUploadPlaceInfo

@end

@implementation RIUtility

+ (NSString *)documentDirectory
{
    static NSString *documentDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectory = paths[0];
    });
    return documentDirectory;
}

+ (NSString *)commonDirectory
{
    static NSString *commonDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonDirectory = [[self documentDirectory]stringByAppendingPathComponent:@"common"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:commonDirectory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:commonDirectory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'common' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'common' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return commonDirectory;
}

+ (NSString *)userDirectoryForUserID:(NSNumber *)userID
{
    NSString *userPath = [[self documentDirectory]stringByAppendingPathComponent:userID.stringValue];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isDirectoryExist = [fileManager fileExistsAtPath:userPath isDirectory:&isDirectory];
    if (!(isDirectoryExist && isDirectory)) {
        if (![fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSAssert(NO, @"Failed to create home directory for user:%@ at path:%@", userID, userPath);
            return userPath;
        }
        RILogInfo(LogAspectLogin, @"Home directory for user:%@ has created at path:%@", userID, userPath);
    }
    return userPath;
}

+ (NSString *)signature:(NSDictionary *)parameters secretKey:(NSString*)secretKey
{
    static const NSUInteger valueTruncatedLimit = 50;
    
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {
        return [((NSString *)obj1)compare : obj2 options : NSLiteralSearch];
    }];
    NSMutableString *buffer = [NSMutableString string];
    
    for (id key in sortedKeys) {
        NSString *value = [NSString stringWithFormat:@"%@", [parameters objectForKey:key]];
        
        if (value.length > valueTruncatedLimit) {
            value = [value substringToIndex:valueTruncatedLimit];
        }
        
        [buffer appendFormat:@"%@=%@", key, value];
    }
    
    [buffer appendString:secretKey];
    return [buffer MD5Digest];
}

+ (NSMutableArray *)mergeArray:(NSArray *)aArray intoArray:(NSArray *)bArray uniqueKeyPath:(NSString *)keyPath
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:bArray];
    NSMutableArray *bPathValues = [array mutableArrayValueForKeyPath:keyPath];
    NSMutableArray *aPathValues = [aArray mutableArrayValueForKeyPath:keyPath];
    for (int i = 0; i< aPathValues.count; ++i) {
        if (![bPathValues containsObject:aPathValues[i]]) {
            [array addObject:aArray[i]];
        }
    }
    return array;
}

+ (void)cleanCacheWithFetchRequest:(NSFetchRequest *)fetchRequest reservedData:(NSArray *)array
{
    __block NSArray *savedArray = nil;
    NSManagedObjectContext *context = [RIDataSource sharedInstance].mainQueueManagedObjectContext;
    [context performBlockAndWait:^{
        savedArray = [context executeFetchRequest:fetchRequest error:nil];
    }];
    dispatch_async([self serialManagedObjectOperateQueue], ^{
        [[RIDataSource sharedInstance].mainQueueManagedObjectContext performBlockAndWait:^{
            for (NSManagedObject *object in savedArray) {
                if (![array containsObject:object]) {
                    [[RIDataSource sharedInstance].mainQueueManagedObjectContext deleteObject:object];
                }
            }
            NSError *error;
            [[RIDataSource sharedInstance].mainQueueManagedObjectContext saveToPersistentStore:&error];
            NSAssert(!error, @"failed to write data. %@",error.userInfo);
        }];
    });
}

+ (void)replaceCacheWithManagedObjectArray:(NSArray *)newArray
{
    if (!newArray || !newArray.count) {
        NSAssert(FALSE, @"'newArray' should not be 'nil'.");
        return;
    }
    NSManagedObject *object = newArray[0];
    NSAssert([object respondsToSelector:@selector(entity)], @"the array must contain managedObject.");
    NSManagedObjectContext *moc = [RIDataSource sharedInstance].mainQueueManagedObjectContext;
    NSAssert(moc, @"moc should be created before calling this method.");
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = object.entity;
    NSError *error;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    NSPredicate *query = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (![newArray containsObject:evaluatedObject])
            return YES;
        else
            return NO;
    }];
    results = [results filteredArrayUsingPredicate:query];
    NSAssert(!error, @"error occurs when performming fetch. %@",error.userInfo);
    if (results.count) {
        for (NSManagedObject *object in results) {
            [moc deleteObject:object];
        }
        [moc saveToPersistentStore:&error];
        NSAssert(!error, @"error occurs when saving moc to persistentStore. %@",error.userInfo);
    }
}

+ (NSString *)requestStringForParametersWithSecretKey:(NSDictionary *)parameters
{
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *secretKey = [theParameters objectForKey:@"secret_key"];
    if (!secretKey) {
        RILogError(LogAspectDataRequest, @"SecretKey hasn't been added with parameters, won't send any valid request data.");
        return nil;
    }
    [theParameters removeObjectForKey:@"secret_key"];
    NSString *string = RKURLEncodedStringFromDictionaryWithEncoding(theParameters, NSUTF8StringEncoding);
    
    string = [NSString stringWithFormat:@"%@&sig=%@", string, [RIUtility signature:theParameters secretKey:secretKey]];
    return string;
}

#pragma mark - 表情
+ (NSBundle *)emotionBundle
{
    static NSBundle *emotionBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emotionBundlePath = [[NSBundle mainBundle]pathForResource:@"RIEmotions" ofType:@"bundle"];
        NSAssert(emotionBundlePath, @"'RIEmotions.bundle' should be included in mainBundle.");
        emotionBundle = [NSBundle bundleWithPath:emotionBundlePath];
    });
    return emotionBundle;
}

+ (NSBundle *)defaultBackgroundImageBundle
{
    static NSBundle *defaultBackgroundImageBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *defaultBackgroundImageBundlePath = [[NSBundle mainBundle]pathForResource:@"RIDefaultBackgroundImages" ofType:@"bundle"];
        NSAssert(defaultBackgroundImageBundlePath, @"'RIDefaultBackgroundImages.bundle' should be included in mainBundle.");
        defaultBackgroundImageBundle = [NSBundle bundleWithPath:defaultBackgroundImageBundlePath];
    });
    return defaultBackgroundImageBundle;
}

+ (NSBundle *)defaultBackgroundThumbnailImageBundle
{
    static NSBundle *defaultBackgroundThumbnailImageBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *defaultBackgroundThumbnailImageBundlePath = [[self defaultBackgroundImageBundle]pathForResource:@"RIDefaultBackgroundThumbnailImages" ofType:@"bundle"];
        NSAssert(defaultBackgroundThumbnailImageBundlePath, @"'RIDefaultBackgroundThumbnailImages.bundle' should be included in mainBundle.");
        defaultBackgroundThumbnailImageBundle = [NSBundle bundleWithPath:defaultBackgroundThumbnailImageBundlePath];
    });
    return defaultBackgroundThumbnailImageBundle;
}

+ (NSBundle *)defaultBackgroundOriginalImageBundle
{
    static NSBundle *defaultBackgroundOriginalImageBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *defaultBackgroundOriginalImageBundlePath = [[self defaultBackgroundImageBundle]pathForResource:@"RIDefaultBackgroundOriginalImages" ofType:@"bundle"];
        NSAssert(defaultBackgroundOriginalImageBundlePath, @"'RIDefaultBackgroundOriginalImages.bundle' should be included in mainBundle.");
        defaultBackgroundOriginalImageBundle = [NSBundle bundleWithPath:defaultBackgroundOriginalImageBundlePath];
    });
    return defaultBackgroundOriginalImageBundle;
}

+ (void)copyEmotionPlistToLocalDiskWhenAppFirstRun
{
    //TODO:检测是否是第一次启动程序,如果是第一次启动需要清掉emotion目录内容,否则不进行覆盖
    NSString *plistPathInDisk = [[self emotionDictory]stringByAppendingPathComponent:kEmotionPlistName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:plistPathInDisk]) {
        RILogInfo(LogAspectGeneral, @"'%@' already exsits. abort copying",kEmotionPlistName);
        return;
    }
    NSString *plistPathInBundle = [[self emotionBundle] pathForResource:@"emotions" ofType:@"plist"];
    NSAssert(plistPathInBundle, @"'%@' should be included in emotionBundle.",kEmotionPlistName);
    NSError *error;
    [[NSFileManager defaultManager]copyItemAtPath:plistPathInBundle toPath:plistPathInDisk error:&error];
    NSAssert(!error, @"failed to copy '%@'. %@", kEmotionPlistName, error.userInfo);
    if (error) {
        RILogError(LogAspectGeneral, @"failed to copy '%@'. %@",kEmotionPlistName, error.userInfo);
        abort();
    }
    return;
}

+ (NSString *)emotionDictory
{
    static NSString *emotionDictory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emotionDictory = [[self commonDirectory]stringByAppendingPathComponent:@"emotions"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:emotionDictory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:emotionDictory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'emotionDictory' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'emotionDictory' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return emotionDictory;
}

+ (NSString *)backgroundImageDictory
{
    static NSString *backgroundImageDictory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundImageDictory = [[self commonDirectory]stringByAppendingPathComponent:@"backgroundImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:backgroundImageDictory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:backgroundImageDictory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'backgroundImageDictory' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'backgroundImageDictory' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return backgroundImageDictory;
}

+ (NSString *)backgroundThumbnailImageDictory
{
    static NSString *backgroundThumbnailImageDictory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundThumbnailImageDictory = [[self backgroundImageDictory]stringByAppendingPathComponent:@"backgroundThumbnailImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:backgroundThumbnailImageDictory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:backgroundThumbnailImageDictory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'backgroundThumbnailImageDictory' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'backgroundThumbnailImageDictory' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return backgroundThumbnailImageDictory;
}

+ (NSString *)backgroundOriginalImageDictory
{
    static NSString *backgroundOriginalImageDictory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundOriginalImageDictory = [[self backgroundImageDictory]stringByAppendingPathComponent:@"backgroundOriginalImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:backgroundOriginalImageDictory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:backgroundOriginalImageDictory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'backgroundOriginalImageDictory' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'backgroundOriginalImageDictory' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return backgroundOriginalImageDictory;
}

+ (NSString *)filterSampleImageDirectory
{
    static NSString *filterSampleImageDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filterSampleImageDirectory = [[self commonDirectory]stringByAppendingPathComponent:@"filterSampleImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filterSampleImageDirectory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:filterSampleImageDirectory withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"failed to create 'filterSampleImageDirectory' directory. %@",error.userInfo);
            if (error) {
                RILogError(LogAspectGeneral, @"failed to create 'filterSampleImageDirectory' directory. %@",error.userInfo);
                abort();
            }
        }
    });
    return filterSampleImageDirectory;
}

+ (NSString *)resourceCacheDirectory
{
    static NSString *resourceCacheDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * appCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        resourceCacheDirectory = [appCacheDir stringByAppendingPathComponent:@"com.renren-inc.com.resource"];
    });
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:resourceCacheDirectory]) {
        NSError *error;
        [fileManager createDirectoryAtPath:resourceCacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(!error, @"failed to create 'filterSampleImageDirectory' directory. %@",error.userInfo);
    }
    return resourceCacheDirectory;
}

+ (NSString *)absolutePathForResourcePath:(NSString *)path
{
    if ([path hasPrefix:@"/"]) {
        return [[self resourceCacheDirectory]stringByAppendingPathComponent:path];
    }
    return path;
}

+ (NSString *)relativePathForResourcePath:(NSString *)path
{
    if ([path hasPrefix:@"/"]) {
        return [path stringByReplacingOccurrencesOfString:[self resourceCacheDirectory] withString:@""];
    }
    return path;
}

+ (NSString *)saveResouceData:(NSData *)data
{
    NSString *name = [data MD5HexDigest];
    NSString *filePath = [[self resourceCacheDirectory]stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:data attributes:nil];
    return filePath;
}

+ (SDImageCache *)chatImageCache
{
    static SDImageCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[SDImageCache alloc]initWithNamespace:@"RenRen.ChatImages"];
    });
    return imageCache;
}

+ (NSString *)headURLByUserID:(NSNumber *)userID
{
    return [@"http://ic.m.renren.com/gn?op=resize&w=40&h=40&p=" stringByAppendingString:userID.stringValue];
}

+ (NSString *)headURLByJabberID:(NSString *)jabberID
{
    NSArray *array = [jabberID componentsSeparatedByString:@"@"];
    NSNumber *userID = @([array[0] longLongValue]);
    return [self headURLByUserID:userID];
}

+ (NSDictionary *)errorDict
{
    static NSDictionary *errorDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *errorFilePath = [[NSBundle mainBundle]pathForResource:@"MError" ofType:@"plist"];
        errorDict = [NSDictionary dictionaryWithContentsOfFile:errorFilePath];
        NSAssert(errorDict, @"MError dictionary read failed.");
    });
    return errorDict;
}

+ (NSString *)errorStringForCode:(NSString *)errorCode
{
    static NSString * const kUserAccoundFreezedErrorCode = @"10003";
    static NSString * const kUserAccoundBannedErrorCode = @"10004";
    static NSString * const kUserAccoundClosedErrorCode = @"10005";
    NSString * const kNotificationUserAccountInvalid = @"kNotificationUserAccountInvalid";
    NSString * const kUserAccountInvalidErrorCodeKey = @"kUserAccountInvalidErrorCodeKey";
    if ([errorCode isEqual:kUserAccoundClosedErrorCode] || [errorCode isEqual:kUserAccoundBannedErrorCode] || [errorCode isEqual:kUserAccoundFreezedErrorCode]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserAccountInvalid object:nil userInfo:@{kUserAccountInvalidErrorCodeKey:errorCode}];
    }
    NSString *errorString = [[self errorDict] valueForKey:errorCode];
    return errorString;
}

+ (NSString *)networkUnreachableString
{
    return [self errorDict][@"-1009"];
}

+ (id)objectFromPlist:(NSString *)pilstName
{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:pilstName ofType:@"plist"];
    if (!plistPath || 0 >= plistPath.length) {
        return nil;
    }
    
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (BOOL)saveToPersistence
{
    NSError *error;
    [[RIDataSource sharedInstance].mainQueueManagedObjectContext saveToPersistentStore:&error];
    NSAssert(!error, @"core data failed in saving. %@",error.userInfo);
    if (error) {
        return NO;
    }
    return YES;
}

+ (id)insertNewObjectForEntityForName:(NSString *)entityName
{
    return [[RIDataSource sharedInstance].mainQueueManagedObjectContext insertNewObjectForEntityForName:entityName];
}

+ (void)constructMucGroupHeadImageWithHeadURLs:(NSArray *)headURLs imageView:(UIImageView *)imageView
{
    if (headURLs.count > 4) {
        headURLs = [NSMutableArray arrayWithArray:[headURLs subarrayWithRange:NSMakeRange(0, 4)]];
    }
    UIImage *placeHolderImage = [UIImage imageNamed:@"defaultUser"];
    CGFloat padding = 2;
    CGFloat headImageWidth = imageView.frame.size.width;
    CGFloat headIamgeHeight = imageView.frame.size.height;
    CGFloat smallImageWidth = (headImageWidth - 3 * padding) / 2;
    CGFloat smallImageHeight = (headIamgeHeight - 3 * padding) / 2;
    for (UIView *subview in imageView.subviews) {
        [subview removeFromSuperview];
    }
    switch (headURLs.count) {
        case 1:
            [imageView setImageWithURL:headURLs[0] placeholderImage:placeHolderImage];
            break;
        case 2:
        {
            UIImageView *imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(padding, (headIamgeHeight - smallImageHeight) / 2 , smallImageWidth, smallImageHeight)];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(padding * 2 + smallImageWidth, (headIamgeHeight - smallImageHeight) / 2 , smallImageWidth, smallImageHeight)];
            [imageView0 setImageWithURL:headURLs[0] placeholderImage:placeHolderImage];
            [imageView1 setImageWithURL:headURLs[1] placeholderImage:placeHolderImage];
            imageView.image = nil;
            [imageView addSubview:imageView0];
            [imageView addSubview:imageView1];
        }
            break;
        case 3:
        {
            UIImageView *imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake((headImageWidth - smallImageWidth) / 2, padding, smallImageWidth, smallImageHeight)];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(padding, 2 * padding + smallImageHeight, smallImageWidth, smallImageHeight)];
            UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(padding * 2 + smallImageWidth, 2 * padding + smallImageHeight, smallImageWidth, smallImageHeight)];
            [imageView0 setImageWithURL:headURLs[0] placeholderImage:placeHolderImage];
            [imageView1 setImageWithURL:headURLs[1] placeholderImage:placeHolderImage];
            [imageView2 setImageWithURL:headURLs[2] placeholderImage:placeHolderImage];
            imageView.image = nil;
            [imageView addSubview:imageView0];
            [imageView addSubview:imageView1];
            [imageView addSubview:imageView2];
        }
            break;
        case 4:
        {
            UIImageView *imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(padding, padding, smallImageWidth, smallImageHeight)];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(padding * 2 + smallImageWidth, padding, smallImageWidth, smallImageHeight)];
            UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(padding, 2 * padding + smallImageHeight, smallImageWidth, smallImageHeight)];
            UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(padding * 2 + smallImageWidth, 2 * padding + smallImageHeight, smallImageWidth, smallImageHeight)];
            [imageView0 setImageWithURL:headURLs[0] placeholderImage:placeHolderImage];
            [imageView1 setImageWithURL:headURLs[1] placeholderImage:placeHolderImage];
            [imageView2 setImageWithURL:headURLs[2] placeholderImage:placeHolderImage];
            [imageView3 setImageWithURL:headURLs[3] placeholderImage:placeHolderImage];
            imageView.image = nil;
            [imageView addSubview:imageView0];
            [imageView addSubview:imageView1];
            [imageView addSubview:imageView2];
            [imageView addSubview:imageView3];
        }
            break;
        default:
            break;
    }
}

+ (dispatch_queue_t)serialManagedObjectOperateQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serialManagedObjectOperateQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    return queue;
}

@end