//
//  UIView+ActivityIndicator.m
//  taowaitao
//
//  Created by eXperienced on 14/11/21.
//  Copyright (c) 2014年 taowaitao.com. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
#import "CommonDefine.h"

#define TAG_LOADING_VIEW (6575)
#define TAG_TOUCH_VIEW (9579)
#define VIEW_SIZE 50

@implementation UIView (ActivityIndicator)

-(void)dismiss:(NSTimer*)timer
{
    [self hideActivityIndicator];
}
- (void)showActivityIndicator
{
    [self showActivityIndicatorWithColor:RGBA(24, 180, 237, 1) width:0.5f size:CGSizeMake(30, 30)];
}
- (void)showActivityIndicatorWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)indicatorSize
{
    if (self == nil)
    {
        return;
    }
    
    UIActivityIndicatorView* activatior =(UIActivityIndicatorView*)[self viewWithTag:TAG_LOADING_VIEW];
    if (activatior)
    {
        return;
    }

    CGSize activityIndicatorSize = CGSizeMake(30, 30);
    if (indicatorSize.width>0 && indicatorSize.height >0)
    {
        activityIndicatorSize.width = indicatorSize.width;
        activityIndicatorSize.height =indicatorSize.height;
    }

    activatior = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, activityIndicatorSize.width, activityIndicatorSize.height)];
    activatior.tag = TAG_LOADING_VIEW;
    
    if (color)
    {
        activatior.tintColor = color;
    }
    else
    {
        activatior.tintColor = RGBA(34, 34, 34, 1);
    }
    
    CGSize size = self.bounds.size;
    activatior.center = CGPointMake(size.width / 2, size.height/2);
    
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* scroll_view = (UIScrollView*)self;
        CGPoint offset = scroll_view.contentOffset;
        activatior.frame = CGRectOffset(activatior.frame, offset.x, offset.y);
    }
    [self addSubview:activatior];
    [activatior startAnimating];
    self.userInteractionEnabled = NO;
    return;
}
- (void)showActivityIndicatorTouchToStop
{
    [self showActivityIndicator];
    UIView *touchView = [[UIView alloc]initWithFrame:self.bounds];
    touchView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActivityIndicator)];
    [touchView addGestureRecognizer:touchGesture];
    touchView.tag = TAG_TOUCH_VIEW;
    [self addSubview:touchView];
    self.userInteractionEnabled = YES;
  
    return;
}
- (void)showActivityIndicatorTouchToStopWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)indicatorSize
{
    [self showActivityIndicatorWithColor:color width:lineWidth size:indicatorSize];
    UIView *touchView = [[UIView alloc]initWithFrame:self.bounds];
    touchView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActivityIndicator)];
    [touchView addGestureRecognizer:touchGesture];
    touchView.tag = TAG_TOUCH_VIEW;
    [self addSubview:touchView];
    self.userInteractionEnabled = YES;
    return;
}
-(void)removeActivityIndicator
{
    UIView * maskView = [self viewWithTag:TAG_TOUCH_VIEW];
    [maskView removeFromSuperview];
    [self hideActivityIndicator];
}
- (void)hideActivityIndicator
{
    if (self == nil)
    {
        return ;
    }
    
    self.userInteractionEnabled = YES;
    
    UIView *touchView = [self viewWithTag:TAG_TOUCH_VIEW];
    if (touchView != nil) {
        [touchView removeFromSuperview];
        touchView = nil;
    }
    
    UIActivityIndicatorView *activatior = (UIActivityIndicatorView*)[self viewWithTag:TAG_LOADING_VIEW];
    
    if (activatior != nil)
    {
        [activatior stopAnimating];
        [activatior removeFromSuperview];
    }
    return;
}
+ (UIView*)activityIndicator
{
    return [self activityIndicatorWithColor:RGBA(24, 180, 237, 1) width:0.5f size:CGSizeMake(30, 30)];
}
+ (UIView*)activityIndicatorWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)size
{
    CGSize activityIndicatorSize = CGSizeMake(30, 30);
    if (size.width>=0 && size.height >=0)
    {
        activityIndicatorSize.width = size.width;
        activityIndicatorSize.height =size.height;
    }
    UIActivityIndicatorView *activatior = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, activityIndicatorSize.width, activityIndicatorSize.height)];    
    if (color)
    {
        activatior.tintColor = color;
    }
    else
    {
        activatior.tintColor = RGBA(24, 180, 237, 1);
    }
    [activatior startAnimating];
    return activatior;
}
@end
