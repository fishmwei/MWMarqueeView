//
//  MWMarqueeView.m
//  MWMarqueeDemo
//
//  Created by huangmingwei on 16/1/25.
//  Copyright © 2016年 huangmingwei. All rights reserved.
//

#import "MWMarqueeView.h"

@implementation MWMarqueeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitUI];
    }
    
    return self;
}


-(void)setupInitUI
{
    _marqueeStyle = MWMarqueeViewStyleCloseBtn;
    self.autoScrollLabel = [[AutoScrollLabel alloc] initWithFrame:self.bounds];
    [self addSubview:self.autoScrollLabel];
    self.autoScrollLabel.backgroundColor = [UIColor clearColor];
    self.autoScrollLabel.x = 10;
    self.autoScrollLabel.width = self.width - 50;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollLabelTap)];
    tapGesture.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    UIImage *image = [UIImage imageNamed:@"btn_normal"];
    CGFloat imageWidth = image.size.width;
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-20-imageWidth, 0, imageWidth+20, self.height)];
    [self.closeButton setImage:image forState:UIControlStateNormal];
    //    [self.closeButton setImage:[UIImage imageNamed:@"login_delete_clicked"] forState:UIControlStateHighlighted];
    self.closeButton.exclusiveTouch = YES;
    
    [self addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.exclusiveTouch = YES;
}

-(void)closeButtonPressed
{
    if ([self.marqueeViewDelegate respondsToSelector:@selector(MWMarqueeViewClicked)]) {
        [self.marqueeViewDelegate MWMarqueeViewClicked];
    }
}

-(void)autoScrollLabelTap
{
    //    if ([self.marqueeViewDelegate respondsToSelector:@selector(NDMarqueeViewTapped)]) {
    //        [self.marqueeViewDelegate NDMarqueeViewTapped];
    //    }
}


- (void) setText: (NSString *) text textColor:(UIColor *)color
{
    [self.autoScrollLabel setText:text];
    [self.autoScrollLabel setTextColor:color];
}

- (void) setFont:(UIFont *)font
{
    [self.autoScrollLabel setFont:font];
}


- (void)setHidden:(BOOL)hidden
{
    if (!hidden) {
        [self.superview bringSubviewToFront:self];
    }
    else
    {
        if (self.marqueeViewDelegate && [self.marqueeViewDelegate respondsToSelector:@selector(MWMarqueeViewDisappear)]) {
            [self.marqueeViewDelegate MWMarqueeViewDisappear];
        }
    }
    
    [super setHidden:hidden];
}

- (void)setMarqueeStyle:(MWMarqueeViewStyle)marqueeStyle
{
    _marqueeStyle = marqueeStyle;
    if (marqueeStyle == MWMarqueeViewStyleCloseBtn) {
        self.closeButton.hidden = NO;
        self.autoScrollLabel.width = self.width - 50;
    }
    else
    {
        self.closeButton.hidden = YES;
        self.autoScrollLabel.width = self.width - 20;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
