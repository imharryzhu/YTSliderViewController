//
//  YTSliderViewController.m
//  YTSliderViewController
//
//  Created by 朱辉 on 16/2/20.
//  Copyright © 2016年 朱辉. All rights reserved.
//

#import "YTSliderViewController.h"
#import "YTSliderBar.h"

@interface YTSliderViewController() <UIScrollViewDelegate, YTSliderBarDelegate>

/**
 *  子控制器滑动所在的contentScrollView
 */
@property (nonatomic,weak) UIScrollView* contentScrollView;

@end

@implementation YTSliderViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        [self loadUI];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)loadUI {
    // 加载子contentScrollView
    [self loadContentScrollView];
    
    // 加载滑块
    [self loadSilderBar];
    
    // ios7+ 将导航控制器内的子控制器移动到导航栏的下方
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


/**
 *  创建sliderBar
 */
- (void)loadSilderBar {
    
    CGFloat sliderBarX = 0;
    CGFloat sliderBarY = 0;
    CGFloat sliderBarW = self.view.bounds.size.width;
    CGFloat sliderBarH = 44;
    
    // 创建SliderBar并设置大小 应该使用autolayout
    YTSliderBar* sliderBar = [[YTSliderBar alloc]initWithFrame:CGRectMake(sliderBarX, sliderBarY, sliderBarW, sliderBarH)];
    self.sliderBar = sliderBar;
    self.sliderBar.delegate = self;
    
    [self.view addSubview:sliderBar];
}

/**
 *  创建contentScrollView
 */
- (void)loadContentScrollView {
    // 创建子控制器的scrollView， 和主View重叠
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.contentScrollView = scrollView;
    
    // 代理
    scrollView.delegate = self;
    
    // 边距 0
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 偏移 0
    scrollView.contentOffset = CGPointMake(0, 0);
    
    // 取消弹性效果
    scrollView.bounces = NO;
    
    // 取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 翻页
    scrollView.pagingEnabled = YES;
    
    [self.view addSubview:scrollView];
}

/**
 *  在添加子控制器时，排列新的子控制器
 */
- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    
    [self layoutSubViewController];
}

- (void)layoutSubViewController {
    
    CGFloat maxX = 0;
    
    if(self.childViewControllers.count > 1){
        // 获取倒数第二个控制器
        UIViewController* lastTwoVC = self.childViewControllers[self.childViewControllers.count - 2];
        // 获取该控制器view的最大X
        maxX = CGRectGetMaxX(lastTwoVC.view.frame);
    }
    
    // 获得最新添加的vc
    UIViewController* lastVc = [self.childViewControllers lastObject];
    // 添加到scrollView
    [self.contentScrollView addSubview:lastVc.view];
    
    // 设置位置
    CGRect vcFrame = lastVc.view.frame;
    vcFrame.origin.x = maxX;
    vcFrame.origin.y = 0;
    lastVc.view.frame = vcFrame;
 
    // 更新content的大小
    CGSize contentSize = self.contentScrollView.contentSize;
    contentSize.width = CGRectGetMaxX(lastVc.view.frame);
    self.contentScrollView.contentSize = contentSize;
    
    // slider添加标题
//    [self.sliderBar addItemWithTitle:lastVc.title];
    [self.sliderBar addItemWithTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.childViewControllers.count]];
}


#pragma mark - ScrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.sliderBar sliderMoveToOffsetX:scrollView.contentOffset.x];
}

#pragma mark - YTSliderBar代理

- (void)sliderBar:(YTSliderBar *)sliderBar didSelectedByIndex:(NSInteger)index {
    
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * index;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}


@end
