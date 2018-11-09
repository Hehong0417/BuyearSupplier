//
//  JDTabBarController.m
//  jdmobile
//
//  Created by SYETC02 on 15/6/12.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//
#import "HJTabBarController.h"
#import "HJNavigationController.h"
#import "HJStoryBoardItem.h"
#import "HXTabBar.h"
#import "HHLoginVC.h"


@interface HJTabBarController () <UITabBarControllerDelegate,HXTabBarDelegate>

@property (nonatomic,strong) NSArray *tabBarItemTitles;
@property (nonatomic,strong) NSArray *tabBarItemNormalImages;
@property (nonatomic,strong) NSArray *tabBarItemSelectedImages;
@property (nonatomic,strong) NSArray *tabBarStoryBoardItems;
@property (strong, nonatomic) NSDate *lastDate;

@end

@implementation HJTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //1.添加所有的自控制器
    [self addAllChildVcs];
    
    
    self.delegate = self;
    self.tabBar.tintColor=APP_COMMON_COLOR;
    
//    HXTabBar *tabBar = [[HXTabBar alloc] init];
//    tabBar.customDelegate = self;
//    /** KVC */
//    [self setValue:tabBar forKey:@"tabBar"];
    
}

- (void)addAllChildVcs
{
    
    for (int i=0; i < self.tabBarStoryBoardItems.count; i++) {
        
        UIViewController *childVC = [self viewControllerWithStoryBoardItem:self.tabBarStoryBoardItems[i]];
        
        [self addOneChildVc:childVC title:self.tabBarItemTitles[i] imageName:self.tabBarItemNormalImages[i] selectedImageName:self.tabBarItemSelectedImages[i]];
    }
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    self.Index = self.selectedIndex;

//    if (self.selectedIndex == 3) {
//
//        //判断是否登录
//        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
//        vc.tabBarVC = (HJTabBarController *)tabBarController;
//        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//
//    }

}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
        UIViewController *vc = tabBarController.selectedViewController;
   
        NSDate *date = [[NSDate alloc] init];
       if ([vc isEqual:viewController]) {
              // 处理双击事件
             if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 < 0.5) {
                 
                 POST_NOTIFY(kNOTIFY_TABBAR_DOUBLE_CLICK, nil);
                 
                   }
              _lastDate = date;
        
                return NO;
            }
       return YES;
}
- (UIViewController *)viewControllerWithStoryBoardItem:(HJStoryBoardItem *)storyBoardItem {
    
    UIViewController *controller = nil;
    
    if (storyBoardItem.viewControllerNonExist) {
        
        controller = (UIViewController *)[[NSClassFromString(storyBoardItem.Identifier) alloc]init];
        
        return controller;
    }
    
    controller = [UIViewController createFromStoryboardName:((HJStoryBoardItem *)storyBoardItem).storyBoardName WithIdentifier:((HJStoryBoardItem *)storyBoardItem).Identifier];
    
    return controller;
    
}

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    //设置标题
    childVc.title = title;
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图标
    childVc.tabBarItem.image = image;
    
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    //设置选中图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        //声明这张图用原图
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //添加导航控制器
    if ([childVc isKindOfClass:[UINavigationController class]]) {
        
        [self addChildViewController:childVc];
        return;
    }
    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

+ (void)initialize
{
    //设置底部tabbar的主题样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(127,67,149), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    //    UITabBar *appearance1 = [UITabBar appearance];
    //    UIImage *navImage = [UIImage imageWithColor:RGB(46, 40, 42)];
    //    [appearance1 setBackgroundImage:navImage];
    //
    
}

#pragma mark - Setter&Getter

- (NSArray *)tabBarItemTitles {
    
    if (!_tabBarItemTitles) {
        
        _tabBarItemTitles = @[ @"商城首页",
                               @"商品分类",
                               @"购物车",
                               @"个人中心"];
    }
    
    return _tabBarItemTitles;
}

- (NSArray *)tabBarItemNormalImages {
    
    if (!_tabBarItemNormalImages) {
        
        _tabBarItemNormalImages = @[@"t1",
                                    @"t2",
                                    @"t3",
                                    @"t4"
                                     ];
    }
    
    return _tabBarItemNormalImages;
}

- (NSArray *)tabBarItemSelectedImages {
    
    if (!_tabBarItemSelectedImages) {
        
        _tabBarItemSelectedImages =  @[@"t1_selected",
                                       @"t2_selected",
                                       @"t3_selected",
                                       @"t4_selected"
                                       ];
        
    }
    
    return _tabBarItemSelectedImages;
}

- (NSArray *)tabBarStoryBoardItems {
    
    if (!_tabBarStoryBoardItems) {
        
        //
        HJStoryBoardItem *item1 = [HJStoryBoardItem itemWithStroyBoardName:@"Home" identifier:@"HHHomePageVC" viewControllerNonExist:YES];
        HJStoryBoardItem *item2 = [HJStoryBoardItem itemWithStroyBoardName:@"Category" identifier:@"HHCategoryVC" viewControllerNonExist:YES];
        
         HJStoryBoardItem *item3 = [HJStoryBoardItem itemWithStroyBoardName:@"Cart" identifier:@"HHCartVC" viewControllerNonExist:YES];
        HJStoryBoardItem *item4 = [HJStoryBoardItem itemWithStroyBoardName:@"Mine" identifier:@"HHPersenCenterVC" viewControllerNonExist:YES];
        
        _tabBarStoryBoardItems = @[ item1,
                                    item2,
                                    item3,
                                    item4
                                    ];
    }
    
    return _tabBarStoryBoardItems;
}

- (void)tabBarDidClickPlusButton:(HXTabBar *)tabBar{
    

    
}

@end
