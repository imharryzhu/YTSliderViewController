//
//  YTSliderBar.m
//  YTSliderViewController
//
//  Created by 朱辉 on 16/2/20.
//  Copyright © 2016年 朱辉. All rights reserved.
//

#import "YTSliderBar.h"

#define YT_ITEMCOLOR_NORMAL [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1]
#define YT_ITEMCOLOR_SELECTED [UIColor colorWithRed:111.0/255 green:68.0/255 blue:28.0/255 alpha:1]
#define YT_SLIDER_COLOR [UIColor colorWithRed:162.0/255 green:219.0/255 blue:246.0/255 alpha:1]
#define YT_ITEMBUTTON_WIDTH 60
#define YT_SLIDER_HEIGHT 5

@interface YTSliderBar()

/**
 *  sliderItems
 */
@property (nonatomic,strong) NSMutableArray* itemButtons;

/**
 *  滑块
 */
@property (nonatomic,weak) CALayer* sliderLayer;

/**
 *  当前所在的控制器的索引
 */
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation YTSliderBar

- (NSMutableArray*)itemButtons{
    if(!_itemButtons) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}

- (CALayer*)sliderLayer{
    if(!_sliderLayer) {
        CALayer* layer = [[CALayer alloc]init];
        [self.layer addSublayer:layer];
        _sliderLayer = layer;
        
        layer.cornerRadius = 4;
        layer.backgroundColor = YT_SLIDER_COLOR.CGColor;
        layer.position = CGPointMake(0, self.bounds.size.height - YT_SLIDER_HEIGHT / 2);
        layer.zPosition = NSIntegerMax;
    }
    return _sliderLayer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
//        self.alpha = 0.0;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if( self.itemButtons.count == 0) return;
    
    NSInteger count = self.itemButtons.count;
    
    CGFloat itemW = 60;
    CGFloat itemH = self.bounds.size.height;
    CGFloat itemY = 0;
    CGFloat itemMargin = (self.bounds.size.width - count * itemW) / (count + 1);
    
    // 遍历已添加到bar上的item，更新其位置
    for (NSInteger i = 0; i < count; i++) {
        UIButton* itemButton = self.itemButtons[i];
        
        CGFloat itemX = itemMargin + i * (itemW + itemMargin);
        
        itemButton.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
    
    // 设置layer的大小
    self.sliderLayer.bounds = CGRectMake(0, 0, itemW, YT_SLIDER_HEIGHT);
    
    // 更新slider的位置
    UIButton* currItem = [self.itemButtons objectAtIndex:self.currentIndex];
    [self sliderMoveToX:currItem.center.x];
}

/**
 *  根据文本，在sliderBar上添加item
 */
- (void)addItemWithTitle:(NSString*)title {
    
    // 创建itemButton
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:YT_ITEMCOLOR_NORMAL forState:UIControlStateNormal];
    [button setTitleColor:YT_ITEMCOLOR_SELECTED forState:UIControlStateSelected];
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    // 设置tag
    button.tag = self.itemButtons.count;
    
    [self.itemButtons addObject:button];
    
    if(self.itemButtons.count == 1) {
        [self didSelectedItem:0];
    }
}

/**
 *  SliderBarItem 点击时
 */
- (void)itemClick:(UIButton*)item {
    
    self.currentIndex = item.tag;
    
    [self sliderMoveToX:item.center.x];
    
    
    // 给代理发送消息
    if([self.delegate respondsToSelector:@selector(sliderBar:didSelectedByIndex:)]){
        [self.delegate sliderBar:self didSelectedByIndex:item.tag];
    }
    
}

/**
 *  计算scrollView在屏幕中的偏移位置相对于sliderBar的宽度所对应的X
 */
- (void)sliderMoveToOffsetX:(CGFloat)x {
    
    // 两个按钮中心点之间的间距
    CGFloat btnOffset = 0;
    
    UIButton* itemButton1 = [self.itemButtons firstObject];
    
    if(self.itemButtons.count > 1){
        UIButton* itemButton2 = [self.itemButtons objectAtIndex:1];
        btnOffset = itemButton2.center.x - itemButton1.center.x;
    }
    
    CGFloat offsetX = x / self.bounds.size.width * btnOffset;
    CGFloat basicX = itemButton1.center.x;
    CGFloat absX = basicX + offsetX;
    
    [self sliderMoveToX:absX];
    
    [self didSelectedItem:offsetX/btnOffset + 0.5];
}

/**
 *  slider在slider中移动到x的位置
 */
- (void)sliderMoveToX:(CGFloat)x {
    // 创建动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    // slider移动到 x
    pathAnimation.toValue = @(x);
    // 动画事件
    pathAnimation.duration = 0.3f;
    // 动画执行玩后 不删除动画
    pathAnimation.removedOnCompletion = NO;
    // 保持动画的最新状态
    pathAnimation.fillMode = kCAFillModeForwards;
    // 动画效果
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 执行动画
    [self.sliderLayer addAnimation:pathAnimation forKey:nil];
}

/**
 *  选中Item
 */
- (void)didSelectedItem:(NSInteger)itemIndex{
    self.currentIndex = itemIndex;
    for (int i = 0; i < self.itemButtons.count; i++) {
        if(i != itemIndex) {
            [self.itemButtons[i] setSelected:NO];
        }else{
            [self.itemButtons[i] setSelected:YES];
        }
    }
}


@end
