
//
//  AutoScrollLabel.m
//  MWMarqueeDemo
//
//  Created by huangmingwei on 16/1/25.
//  Copyright © 2016年 huangmingwei. All rights reserved.
//

#import "AutoScrollLabel.h"

#define LABEL_BUFFER_SPACE 30   // pixel buffer space between scrolling label
#define DEFAULT_PIXELS_PER_SECOND 80
#define DEFAULT_PAUSE_TIME 0.01f

@interface AutoScrollLabel()
{
    BOOL shouldScroll;
    CGRect beginDragBounds;
    CGRect endDragBounds;
    CGFloat scrollOffset;
    
    UserScrollResumeStyle resumeType;
}

@end

@implementation AutoScrollLabel

@synthesize scrollStyle, scrollDirection, scrollSpeed;
@synthesize pauseInterval;
@synthesize bufferSpaceBetweenLabels;

- (void) commonInit
{
	for (int i=0; i< NUM_LABELS; ++i) {
		label[i] = [[UILabel alloc] init];
		label[i].textColor = [UIColor whiteColor];
		label[i].backgroundColor = [UIColor clearColor];
        label[i].textAlignment = NSTextAlignmentCenter;
		[self addSubview:label[i]];
	}
	
    resumeType = UserScrollResumeToDragBegin;
    
    shouldScroll = NO;
    scrollStyle = AutoScrollStyleLoop;
	scrollDirection = AUTOSCROLL_SCROLL_LEFT;
	scrollSpeed = DEFAULT_PIXELS_PER_SECOND;
	pauseInterval = DEFAULT_PAUSE_TIME;
	bufferSpaceBetweenLabels = LABEL_BUFFER_SPACE;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    _alwaysScroll = NO;
    
    
    self.delegate = self;
}



-(id) init
{
	if (self = [super init]){
        // Initialization code
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Initialization code
		[self commonInit];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self commonInit];
    }
    return self;
}



- (void) scroll
{
	// Prevent multiple calls
	if (isScrolling){
		return;
	}
    
	isScrolling = YES;
	
    scrollOffset = label[0].frame.size.width+bufferSpaceBetweenLabels*2;
    if (scrollStyle == AutoScrollStyleSwing) {
        scrollOffset -= self.frame.size.width;
    }
    else
    {
        scrollOffset = label[0].frame.size.width+bufferSpaceBetweenLabels;
    }
    
    CGFloat offsetStart = label[0].frame.size.width+bufferSpaceBetweenLabels;
    
    if (scrollDirection == AUTOSCROLL_SCROLL_LEFT){
        self.contentOffset = CGPointMake(offsetStart,0);
    }else{
        self.contentOffset = CGPointMake(offsetStart + scrollOffset,0);
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction |  UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState;
    
    if (scrollStyle != AutoScrollStyleSwing) {
        options |= UIViewAnimationOptionRepeat;
    }
    
    [UIView animateWithDuration:scrollOffset/(float)scrollSpeed
                          delay:0
                        options:options
                     animations:^{
                         if (scrollDirection == AUTOSCROLL_SCROLL_LEFT){
                             self.contentOffset = CGPointMake(offsetStart + scrollOffset,0);
                         }else{
                             self.contentOffset = CGPointMake(offsetStart,0);
                         }
                     }
                     completion:^(BOOL finished)
     {
         isScrolling = NO;
         
         //change scroll direction
         if (scrollStyle == AutoScrollStyleSwing) {
             if (scrollDirection == AUTOSCROLL_SCROLL_RIGHT) {
                 scrollDirection = AUTOSCROLL_SCROLL_LEFT;
             }
             else
             {
                 scrollDirection = AUTOSCROLL_SCROLL_RIGHT;
             }
         }
         
         if (shouldScroll) {
             if (finished ) {
                 [NSTimer scheduledTimerWithTimeInterval:pauseInterval target:self selector:@selector(scroll) userInfo:nil repeats:NO];
             }
             else
             {
                 //变慢点
                 [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scroll) userInfo:nil repeats:NO];
             }
             
         }
     }];
    
}

- (void) readjustLabels
{
	float offset = bufferSpaceBetweenLabels;
	
	for (int i = 0; i < NUM_LABELS; ++i){
		[label[i] sizeToFit];
		
        if (label[i].width < self.width) {
            label[i].width = self.width;
        }
        
		// Recenter label vertically within the scroll view
		CGPoint center;
		center = label[i].center;
		center.y = self.center.y - self.frame.origin.y;
		label[i].center = center;
		
		CGRect frame;
		frame = label[i].frame;
		frame.origin.x = offset;
		label[i].frame = frame;
		
		offset += label[i].frame.size.width + bufferSpaceBetweenLabels;
	}
	
    if (_alwaysScroll || label[0].width > self.width) {
        shouldScroll = YES;
    }
    else
    {
        shouldScroll = NO;
    }
    
	CGSize size;
	size.width = label[0].frame.size.width * NUM_LABELS + bufferSpaceBetweenLabels*(NUM_LABELS + 1);
	size.height = self.frame.size.height;
	self.contentSize = size;

	
	
	// If the label is bigger than the space allocated, then it should scroll
	if (shouldScroll){
        [self setContentOffset:CGPointMake(label[NUM_LABELS/2].frame.size.width+bufferSpaceBetweenLabels,0) animated:NO];
        self.scrollEnabled = YES;
		for (int i = 0; i < NUM_LABELS; ++i){
			label[i].hidden = NO;
		}
        
		[self scroll];
	}else{
        [self setContentOffset:CGPointMake(bufferSpaceBetweenLabels,0) animated:NO];
        self.scrollEnabled = NO;
        for (int i = 0; i < NUM_LABELS; ++i){
            label[i].hidden = NO;
        }
        
	}

}


- (void) setText: (NSString *) text
{
	// If the text is identical, don't reset it, otherwise it causes scrolling jitter
	if ([text isEqualToString:label[0].text]){
		// But if it isn't scrolling, make it scroll
		// If the label is bigger than the space allocated, then it should scroll
		if (shouldScroll){
			[self scroll];
		}
		return;
	}
	
	for (int i=0; i<NUM_LABELS; ++i){
		label[i].text = text;
	}
	[self readjustLabels];
}	
- (NSString *) text
{
	return label[0].text;
}


- (void) setTextColor:(UIColor *)color
{
	for (int i=0; i<NUM_LABELS; ++i){
		label[i].textColor = color;
	}
}

- (UIColor *) textColor
{
	return label[0].textColor;
}


- (void) setFont:(UIFont *)font
{
	for (int i=0; i<NUM_LABELS; ++i){
		label[i].font = font;
	}
	[self readjustLabels];
}

- (UIFont *) font
{
	return label[0].font;
}


- (void) setScrollSpeed: (float)speed
{
	scrollSpeed = speed;
	[self readjustLabels];
}

- (float) scrollSpeed
{
	return scrollSpeed;
}

- (void) setScrollDirection: (enum AutoScrollDirection)direction
{
	scrollDirection = direction;
	[self readjustLabels];
}

- (enum AutoScrollDirection) scrollDirection
{
	return scrollDirection;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginDragBounds = self.bounds;
    [self pauseLayer:self.layer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        self.decelerationRate = 0.0f;
    }
    else
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (resumeType == UserScrollResumeToDragBegin)
    {
        self.bounds = beginDragBounds;
        [self resumeLayer:self.layer];
    }
    else if (resumeType == UserScrollResumeToAnimateBegin)
    {
        CGRect x = self.bounds;
        x.origin.x = 0;
        self.bounds = x;
        self.layer.speed = 1.0f;
        [self.layer removeAllAnimations];
    }
    else
    {
        
    }
}


//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime ;
    layer.beginTime = timeSincePause;
}

- (void)resumeLayer:(CALayer*)layer moreTime:(CGFloat)moreTime
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = MIN( 1.999, MAX( 0.0, pausedTime - moreTime) ) ;
//    [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime + moreTime;
    layer.timeOffset = timeSincePause;
}

@end
