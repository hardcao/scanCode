//
//  RIDataRequest.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIDataRequest.h"

#import "MError.h"
#import "RIDataSource.h"
#import "RISettings.h"
#import "RIModelAdjustBeforeUsingProtocol.h"
#import "RILoginManager.h"
#import "RIRegisteredRequest.h"

@interface RIDataRequest ()

@property (nonatomic, strong) NSMutableDictionary *additionalParameters;
@property (nonatomic, strong) RKObjectRequestOperation *requestOperation;

@end

@implementation RIDataRequest

+ (RKRequestDescriptor*) requestDescriptor
{
    NSAssert([self.class conformsToProtocol:@protocol(RIDataProtocol)],
             @"class '%@' should conforms to protocol 'RIDataProtocol'.",[self.class description]);
    return [RKRequestDescriptor requestDescriptorWithMapping:[self.class requestMapping]
                                                 objectClass:self.class
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodPOST];
}

+ (RKResponseDescriptor *)responseDescriptor
{
    NSAssert([self.class conformsToProtocol:@protocol(RIDataProtocol)],
             @"class '%@' should conforms to protocol 'RIDataProtocol'.",[self.class description]);
    return [RKResponseDescriptor responseDescriptorWithMapping:[self.class responseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self.class requestPath]
                                                       keyPath:[self.class responseKeyPath]
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (void) postRequest
{
    NSAssert([self conformsToProtocol:@protocol(RIDataProtocol)], @"Class:%@ should conforms to protocol RIDataProtocol.", self.class);
    if ([self isKindOfClass:[RIRegisteredRequest class]] && ![RILoginManager sharedInstance].hasLoggedIn) {
        RICallBlockSafely(self.failedBlock, @"用户登录信息已失效");
        return;
    }
    RKObjectRequestOperation *operation = [self requestOperation];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager enqueueObjectRequestOperation:operation];
}

- (NSDictionary*) defaultParameters
{
    RISettings *settings = [RISettings globalSettings];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:settings.apiKey forKey:@"api_key"];
    [parameters setObject:settings.udid forKey:@"uniq_id"];
    [parameters setObject:@"1.0" forKey:@"v"];
    [parameters setObject:@"json" forKey:@"format"];
    [parameters setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"call_id"];
    [parameters setObject:settings.clientInfo forKey:@"client_info"];
    
    return parameters;
}

- (NSString *)secretKey
{
    return [RISettings globalSettings].appSecretKey;
}

- (NSDictionary *)additionalAndDefaultParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[RKObjectParameterization parametersWithObject:self requestDescriptor:[self.class requestDescriptor] error:nil]];
    NSMutableDictionary *finalAdditionalParemeters = [NSMutableDictionary dictionary];
    [finalAdditionalParemeters setValuesForKeysWithDictionary:[self defaultParameters]];
    [finalAdditionalParemeters setValuesForKeysWithDictionary:self.additionalParameters];
    [parameters setValuesForKeysWithDictionary:finalAdditionalParemeters];
    NSString *secretKey = [self secretKey];
    NSString *sig = [RIUtility signature:parameters secretKey:secretKey];
    finalAdditionalParemeters[@"sig"] = sig;
    return finalAdditionalParemeters;
}

- (void)appendAdditionalParameters:(NSDictionary *)parameters
{
    if (!self.additionalParameters) {
        self.additionalParameters = [NSMutableDictionary dictionary];
    }
    [self.additionalParameters setValuesForKeysWithDictionary:parameters];
}

- (RKObjectRequestOperation *)generatePureRequestOperation
{
    RKObjectRequestOperation *operation =
    [[RKObjectManager sharedManager]appropriateObjectRequestOperationWithObject:self
                                                                         method:RKRequestMethodPOST
                                                                           path:[self.class requestPath]
                                                                     parameters:[self additionalAndDefaultParameters]];
    return operation;
}

- (RKObjectRequestOperation *)requestOperation
{
    if (!_requestOperation) {
        RKObjectRequestOperation *operation = [self generatePureRequestOperation];
        [self setCompleteAndFailedBlocksForRequestOperation:operation];
        [operation setWillMapDeserializedResponseBlock:self.willMapDeserializedResponseBlock];
        _requestOperation = operation;
    }
    return _requestOperation;
}

- (void)setCompleteAndFailedBlocksForRequestOperation:(RKObjectRequestOperation *)requestOperation
{
    DataRequestSucceededBlock successed = self.succeededBlock;
    DataRequestFailedBlock failed = self.failedBlock;
    [requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSArray *objects = result.array;
        if (objects.count == 0) {
            NSString *errorMessage = [MError descriptionForError:nil];
            RICallBlockSafely(failed, errorMessage);
            return;
        }
        for (id object in objects) {
            if ([object isKindOfClass:MError.class]) {
                MError *error = object;
                RILogError(LogAspectDataRequest, @"Response error accoured, errorCode:%@, errorMessage:%@", error.MCSErrorCode, error.MCSErrorMessage);
                // TODO: maybe we need an real error object than passing the nil.
                NSString *errorMessage = [MError descriptionForError:error];
                RICallBlockSafely(failed, errorMessage);
                return;
            }
        }
        for (id object in objects) {
            if ([object conformsToProtocol:@protocol(RIModelAdjustBeforeUsingProtocol)]) {
                [object adjust];
            }
        }
        [RIUtility saveToPersistence];
        RICallBlockSafely(successed, objects);
    } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
        NSString *errorMessage = [MError descriptionForError:error];
        RICallBlockSafely(failed, errorMessage);
    }];
}

@end