//
//  GitSearchDetailViewController.m
//  GitRepoSearch
//
//  Created by 宓珂璟 on 2017/1/4.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "GitSearchDetailViewController.h"
#import "MKJRequestHelp.h"
#import "GitSearchModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+ActivityIndicator.h"
@interface GitSearchDetailViewController ()<UITextViewDelegate>
@property (nonatomic,strong) GitRepoModel *detailModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation GitSearchDetailViewController

- (void)dealloc
{
    NSLog(@"dealloc--->%s",object_getClassName(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDetailData];
}

- (void)loadDetailData
{
    __weak typeof(self)weakSelf = self;
    [self.view showActivityIndicator];
    sleep(2.0);
    [[MKJRequestHelp shareRequestHelp] requestRepoDetailWithRepoFullName:self.fullRepoName completion:^(id obj, NSError *err) {
        [weakSelf.view hideActivityIndicator];
        weakSelf.detailModel = (GitRepoModel *)obj;
        [weakSelf updateUI:weakSelf.detailModel];
    }];
}

- (void)updateUI:(GitRepoModel *)detailModel
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:detailModel.owner.ownerAvatar] placeholderImage:nil completed:nil];
    self.ownerLabel.text = detailModel.owner.ownerName;
    self.repoNameLabel.text = detailModel.repoFullName;
    self.desc.text = detailModel.repoDesc;
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.editable = NO;
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    NSString *str = @"touch me skip to github";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:detailModel.repoLink] range:[str rangeOfString:@"skip to github"]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, str.length)];
    self.textView.attributedText = attrStr;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    NSLog(@"点击链接跳转到我这里");
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
