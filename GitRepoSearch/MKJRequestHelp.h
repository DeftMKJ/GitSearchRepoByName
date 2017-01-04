//
//  MKJRequestHelp.h
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id obj,NSError *err);

@interface MKJRequestHelp : NSObject

@property (nonatomic,strong) NSMutableArray *searchKeywordTasks;

+ (instancetype)shareRequestHelp;

- (void)requestGitSearchListsWithKeywords:(NSString *)keywords page:(NSInteger)currentPage count:(NSInteger)count completio:(completeBlock)completionBlock;

- (void)requestRepoDetailWithRepoFullName:(NSString *)fullName completion:(completeBlock)completionBlock;

@end
