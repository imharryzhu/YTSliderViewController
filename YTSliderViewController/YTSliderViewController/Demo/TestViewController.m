//
//  TestViewController.m
//  YTSliderViewController
//
//  Created by 朱辉 on 16/2/20.
//  Copyright © 2016年 朱辉. All rights reserved.
//

#import "TestViewController.h"
#import "YTSliderViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface UIColor (Test)

@end

@implementation UIColor (Test)


+ (instancetype) randomColor{
    
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0  blue:arc4random()%255/255.0  alpha:1.0];
    
}

@end
@interface TestViewController()
@property (nonatomic,strong) YTSliderViewController* vc;
@end

@implementation TestViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"添加一个" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor randomColor]];
    [btn sizeToFit];
    btn.center = CGPointMake(SCREEN_W / 2, SCREEN_W / 2);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* presentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [presentBtn setTitle:@"添加模态窗口" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [presentBtn setBackgroundColor:[UIColor randomColor]];
    [presentBtn sizeToFit];
    presentBtn.center = CGPointMake(SCREEN_W / 2, SCREEN_W / 2 + 50);
    [self.view addSubview:presentBtn];
    
    [presentBtn addTarget:self action:@selector(presentClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭模态窗口" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor randomColor]];
    [closeBtn sizeToFit];
    closeBtn.center = CGPointMake(SCREEN_W / 2, SCREEN_W / 2 + 100);
    [self.view addSubview:closeBtn];
    
    [closeBtn addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel* versionLabel = [[UILabel alloc]init];
    versionLabel.text = @"YTSliderViewController v1.0";
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(SCREEN_W / 2, SCREEN_H / 2 + 100);
    versionLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:versionLabel];
    

}

- (void)btnClick {
    YTSliderViewController* pVc = (YTSliderViewController*)self.parentViewController;
    
    TestViewController* testVc = [[TestViewController alloc]init];
    
    [pVc addChildViewController:testVc];
}

/**
 *  在模态窗口中使用
 */
- (void)presentClick {
    // 创建SliderViewController
    YTSliderViewController* newSliderVc = [[YTSliderViewController alloc]init];
    self.vc = newSliderVc;
    // 创建子控制器
    TestViewController* childVc = [[TestViewController alloc]init];
    // 将子控制器添加到SliderViewController上
    [newSliderVc addChildViewController:childVc];
    // 弹出模态窗口
    [self presentViewController:newSliderVc animated:YES completion:nil];
}


- (void)closeModal {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
