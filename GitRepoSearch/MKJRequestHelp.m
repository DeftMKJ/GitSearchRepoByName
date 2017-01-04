//
//  MKJRequestHelp.m
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJRequestHelp.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import "CommonDefine.h"
#import "GitSearchModel.h"

@implementation MKJRequestHelp

static id _requestHelp;

+ (instancetype)shareRequestHelp
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [[self alloc] init];
    });
    return _requestHelp;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [super allocWithZone:zone];
    });
    return _requestHelp;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _requestHelp;
}

- (void)requestGitSearchListsWithKeywords:(NSString *)keywords page:(NSInteger)currentPage count:(NSInteger)count completio:(completeBlock)completionBlock
{
    NSString *apiURL = [NSString stringWithFormat:@"%@/users/%@/repos",BASE_URL,keywords];
    NSDictionary *patameters = @{@"page":@(currentPage)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    NSURLSessionDataTask *task = [manager GET:apiURL parameters:patameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        if (res.statusCode == 200) {
            [self setUpModelMap];
            NSArray *lists = [GitRepoModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (completionBlock) {
                completionBlock(lists,nil);
            }
        }
        else
        {
            NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errMessage":@"数据有误"}];
            if (completionBlock) {
                completionBlock(nil,err);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) {
            completionBlock(nil,error);
        }
    }];
    [self.searchKeywordTasks addObject:task];
}

- (NSMutableArray *)searchKeywordTasks
{
    if (_searchKeywordTasks == nil) {
        _searchKeywordTasks = [[NSMutableArray alloc] init];
    }
    return _searchKeywordTasks;
}

- (void)setUpModelMap
{
    [GitRepoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"repoShotName":@"name",
                 @"repoFullName":@"full_name",
                 @"owner":@"owner",
                 @"repoLink":@"html_url",
                 @"repoDesc":@"description"
                 };
    }];
    
    [GitRepoOwner mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ownerAvatar":@"avatar_url",
                 @"ownerName":@"login"
                 };
    }];
}

- (void)requestRepoDetailWithRepoFullName:(NSString *)fullName completion:(completeBlock)completionBlock
{
    NSString *apiURL = [NSString stringWithFormat:@"%@/repos/%@",BASE_URL,fullName];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager GET:apiURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        if (res.statusCode == 200) {
            [self setUpModelMap];
            GitRepoModel *modelDetail = [GitRepoModel mj_objectWithKeyValues:responseObject];
            if (completionBlock) {
                completionBlock(modelDetail,nil);
            }
        }
        else
        {
            NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errMessage":@"数据有误"}];
            if (completionBlock) {
                completionBlock(nil,err);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) {
            completionBlock(nil,error);
        }
    }];

}

- (void)configAddressInfo:(completeBlock)complete
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"];
//    NSString *addString = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
//    NSDictionary *rootDic = [addString mj_JSONObject];
//    [AddressData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"allFriends":@"friends"};
//    }];
//    
//    [AllFriendData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"allFriendsArr":@"row"};
//    }];
//    [AllFriendData mj_setupObjectClassInArray:^NSDictionary *{
//        
//        return @{@"allFriendsArr":@"FriendInfo"};
//    }];
//    AddressData *addressData = [AddressData mj_objectWithKeyValues:rootDic];
//    if (complete)
//    {
//        complete(addressData,nil);
//    }
}


- (void)configFriendListsInfo:(completeBlock)complete
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
//    NSString *friendString = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
//    NSDictionary *rootDict = [friendString mj_JSONObject];
//    
//     [FriendActivityData mj_setupObjectClassInArray:^NSDictionary *{
//         return @{@"rows":@"FriendIssueInfo"};
//     }];
//
//    [FriendIssueInfo mj_setupObjectClassInArray:^NSDictionary *{
//        return @{@"messageBigPics":@"NSString",@"messageSmallPics":@"NSString",@"commentMessages":@"FriendCommentDetail"};
//    }];
//    
//    FriendResultData *data = [FriendResultData mj_objectWithKeyValues:rootDict];
//    if (complete) {
//        complete(data,nil);
//    }
}

@end





























