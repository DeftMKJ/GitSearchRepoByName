//
//  UIView+ActivityIndicator.h
//  taowaitao
//
//  Created by eXperienced on 14/11/21.
//  Copyright (c) 2014年 taowaitao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ActivityIndicator)

- (void)showActivityIndicator;
- (void)showActivityIndicatorWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)indicatorSize;

- (void)showActivityIndicatorTouchToStop;
- (void)showActivityIndicatorTouchToStopWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)indicatorSize;
- (void)hideActivityIndicator;
+ (UIView*)activityIndicator;
+ (UIView*)activityIndicatorWithColor:(UIColor *)color width:(CGFloat)lineWidth size:(CGSize)size;
@end
