//
//  GitTableViewCell.h
//  GitRepoSearch
//
//  Created by 宓珂璟 on 2017/1/3.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *ownerNamelabel;

@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@end
