//
//  MWMarqueeView.h
//  MWMarqueeDemo
//
//  Created by huangmingwei on 16/1/25.
//  Copyright © 2016年 huangmingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Metrics.h"
#import "AutoScrollLabel.h"

typedef NS_ENUM (NSInteger, MWMarqueeViewStyle)
{
    MWMarqueeViewStyleCloseBtn,
    MWMarqueeViewStyleLabelOnly
};

@protocol MWMarqueeViewDelegate <NSObject>

@optional
-(void)MWMarqueeViewClicked;
-(void)MWMarqueeViewDisappear;
-(void)MWMarqueeViewTapped;

@end


@interface MWMarqueeView : UIView

@property (nonatomic, weak) id <MWMarqueeViewDelegate> marqueeViewDelegate;
@property (nonatomic, retain) AutoScrollLabel *autoScrollLabel;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, assign) MWMarqueeViewStyle marqueeStyle;

@property (nonatomic, retain) id saveData;

- (void) setText: (NSString *) text textColor:(UIColor *)color;
- (void) setFont:(UIFont *)font;

@end
