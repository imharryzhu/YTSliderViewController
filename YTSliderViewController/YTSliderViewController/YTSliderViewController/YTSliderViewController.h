//
//  YTSliderViewController.h
//  YTSliderViewController
//
//  Created by 朱辉 on 16/2/20.
//  Copyright © 2016年 朱辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTSliderBar;

@interface YTSliderViewController : UIViewController

/**
 *  导航栏上方的滑块拦
 */
@property (nonatomic, weak) YTSliderBar* sliderBar;

@end
