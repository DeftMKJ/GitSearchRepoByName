//
//  GitSearchModel.h
//  GitRepoSearch
//
//  Created by 宓珂璟 on 2017/1/3.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitRepoOwner;
@interface GitRepoModel : NSObject

@property (nonatomic,copy) NSString *repoShotName;
@property (nonatomic,copy) NSString *repoFullName;
@property (nonatomic,copy) NSString *repoLink;
@property (nonatomic,copy) NSString *repoDesc;
@property (nonatomic,strong) GitRepoOwner *owner;


@end

@interface GitRepoOwner : NSObject

@property (nonatomic,copy) NSString *ownerAvatar;
@property (nonatomic,copy) NSString *ownerName;

@end
