//
//  YTSliderBar.h
//  YTSliderViewController
//
//  Created by 朱辉 on 16/2/20.
//  Copyright © 2016年 朱辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTSliderBarDelegate;

@interface YTSliderBar : UIView

/**
 *  根据标题，在sliderBar上添加item
 */
- (void)addItemWithTitle:(NSString*)title;

/**
 *  传入当前controller的偏移位置
 */
- (void)sliderMoveToOffsetX:(CGFloat)x;

/**
 *  YTSliderBarDelegate
 */
@property (nonatomic,weak) id<YTSliderBarDelegate> delegate;

@end


@protocol YTSliderBarDelegate <NSObject>

@optional
- (void)sliderBar:(YTSliderBar*)sliderBar didSelectedByIndex:(NSInteger)index;

@end