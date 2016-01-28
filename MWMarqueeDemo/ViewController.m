//
//  ViewController.m
//  MWMarqueeDemo
//
//  Created by huangmingwei on 16/1/25.
//  Copyright © 2016年 huangmingwei. All rights reserved.
//

#import "ViewController.h"

#import "MWMarqueeView.h"

//#define IOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )


#define ColorWithHexValue(hexValue, a) [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0f alpha:a]
#define SCREEN_WIDTH (IOS8_OR_LATER ? [UIScreen mainScreen].bounds.size.width : (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height: [UIScreen mainScreen].bounds.size.width))
#define SCREEN_HEIGHT (IOS8_OR_LATER ? [UIScreen mainScreen].bounds.size.height : (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width: [UIScreen mainScreen].bounds.size.height))
#define TOP_MSG_HEIGHT  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20.0f : 0.0f)           //顶部消息栏（信号等）的高度
#define NAV_VIEW_HEIGHT (IOS7_OR_LATER ? 64.0f : 44.0f)           //顶部导航栏视图的高(baseview)

@interface ViewController () <MWMarqueeViewDelegate>
@property (nonatomic, retain) MWMarqueeView *systemNoticeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    if (IOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO; //viewController只有一个ScrollView, 自动留白
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupView
{
    self.systemNoticeView = [[MWMarqueeView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    self.systemNoticeView.backgroundColor = ColorWithHexValue(0xfff8ca, 0.94f);
    [self.view addSubview:self.systemNoticeView];
    
    self.systemNoticeView.autoScrollLabel.alwaysScroll = NO;
    self.systemNoticeView.autoScrollLabel.scrollSpeed = 30;
    self.systemNoticeView.marqueeViewDelegate = self;
    
    [self.systemNoticeView setFont:[UIFont systemFontOfSize:14]];
    self.systemNoticeView.autoScrollLabel.textColor = ColorWithHexValue(0xff3333, 1.0f);
    
    //    self.systemNoticeView.hidden = YES;
    
    self.systemNoticeView.autoScrollLabel.text = @"Hello, every body! This is a marquee Demo, Just to use it. It's my pleasure! The animation will stop when you drag the view, resume when you drag end";
}

-(void)MWMarqueeViewClicked
{
    UIAlertView *al = [[UIAlertView alloc ] initWithTitle:nil message:@"Close" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    
    
}


@end
