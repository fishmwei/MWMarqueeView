
//
//  AutoScrollLabel.h
//  MWMarqueeDemo
//
//  Created by huangmingwei on 16/1/25.
//  Copyright © 2016年 huangmingwei. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIView+Metrics.h"

#define NUM_LABELS 3

enum AutoScrollDirection {
	AUTOSCROLL_SCROLL_RIGHT,
	AUTOSCROLL_SCROLL_LEFT,
};

enum AutoScrollStyle {
    AutoScrollStyleLoop, //一直向左，或者一直向右  默认
    AutoScrollStyleSwing //左右晃动
};


typedef NS_ENUM (NSInteger, UserScrollResumeStyle)
{
    UserScrollResumeToDragBegin,
    UserScrollResumeToAnimateBegin
};



@interface AutoScrollLabel : UIScrollView <UIScrollViewDelegate>{
	UILabel *label[NUM_LABELS];
	bool isScrolling;
    UIButton *clickBtn;
}

@property(nonatomic, assign) enum AutoScrollDirection scrollDirection; // 首次方向
@property (nonatomic, assign) enum AutoScrollStyle scrollStyle;
@property(nonatomic, assign) float scrollSpeed;
@property(nonatomic, assign) NSTimeInterval pauseInterval;
@property(nonatomic, assign) int bufferSpaceBetweenLabels;

// normal UILabel properties
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic, retain) UIFont *font;
@property (nonatomic, assign) BOOL alwaysScroll; //default NO

- (void) readjustLabels;
- (void) setText: (NSString *) text;
- (NSString *) text;
- (void)scroll;




@end
