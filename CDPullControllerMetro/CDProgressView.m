//
//  CDProgressView.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDProgressView.h"
#import "CDFunctions.h"
#import "CDMetroView.h"
#import "CDPullBottomBar.h"

#define kXOffset 20.0f

@implementation CDProgressView
@synthesize progress = _progress, thumb = _thumb;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentClass = [CDProgressDraw class];
    }
    return self;
}

- (CDProgressDraw *)progressView{
    return (CDProgressDraw *)_contentView;
}

- (void)loadContentView:(UIView *)contentView{
    ((CDProgressDraw*)contentView).progress = _progress;
    
    _thumb = [[CDSliderThumb alloc] initWithFrame:CGRectInset(contentView.bounds, kThumbWidth / 2, 0.0f)];
    _thumb.autoresizingMask = CDViewAutoresizingNoMaigin;
    UIView *delegate = (CDPullBottomBar *)self.superview;
    [_thumb addTarget:delegate action:@selector(sliderThumbChangedTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_thumb addTarget:delegate action:@selector(sliderThumbTouchUpInside:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_thumb addTarget:delegate action:@selector(sliderThumbChangedValue:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:_thumb];
}

- (void)cleanContentView{
    [_thumb removeFromSuperview];
    SafeMemberRelease(_thumb);
}

- (void)presentFrom:(CDDirection)direction delay:(NSTimeInterval)interval completion:(void (^)(BOOL))completion{
    [super presentFrom:direction delay:interval completion:completion];
}

- (void)setProgress:(float)progress{
    _progress = progress;
    ((CDProgressDraw*)_contentView).progress = progress;
    _thumb.value = progress;
}

@end

@implementation CDProgressDraw
@synthesize rangeColor = _rangeColor, progress = _progress, range = _range;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _progress = 0.0f;
        [self cleanRange];
        _inset = CGSizeMake(0.05 * CGRectGetWidth(frame), 0.2 * CGRectGetHeight(frame));
        _rangeColor = [UIColor lightGrayColor];
     }
    return self;
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect{
    //
    //                    c
    //  b ________________|________________ d
    //      |    /                   \    |
    //      |   /                     \  h / 2
    //  a --|--|                       |--|- e
    //      |   \                     /   |
    //  h __|____\___________________/____|_ f
    //                    |
    //                    g
    //

    CGContextRef c = UIGraphicsGetCurrentContext() ;    //context
    void (^drawRoundEndPath)(CGRect) = ^(CGRect rect){
        if (CGRectGetWidth(rect) < CGRectGetHeight(rect)) rect.size.width = rect.size.height;
        
        CGFloat radius = 0.5 * CGRectGetHeight(rect);
        CGContextBeginPath(c);
        
        CGContextMoveToPoint(c, CGRectGetMinX(rect), CGRectGetMidY(rect));          //a
        
        CGContextAddArcToPoint(c,CGRectGetMinX(rect), CGRectGetMinY(rect),          //b
                               CGRectGetMidX(rect), CGRectGetMinY(rect),radius);    //c
        
        CGContextAddArcToPoint(c, CGRectGetMaxX(rect), CGRectGetMinY(rect),         //d
                               CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);   //e
        
        CGContextAddArcToPoint(c, CGRectGetMaxX(rect), CGRectGetMaxY(rect),         //f
                               CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);   //g
        
        CGContextAddArcToPoint(c, CGRectGetMinX(rect), CGRectGetMaxY(rect),         //h
                               CGRectGetMinX(rect), CGRectGetMidY(rect), radius);   //a
        
        CGContextClosePath(c);
    };
    
    CGRect sF = CGRectInset(rect, _inset.width, _inset.height); //stage frame
    
    CGFloat trackThick = CGRectGetHeight(sF) * 0.07;
    CGContextSetLineWidth(c, trackThick);
    [_drawColor setStroke];
    drawRoundEndPath(sF);
    CGContextDrawPath(c, kCGPathStroke);
    
    CGFloat iI = (1 - 0.8) * CGRectGetHeight(sF);    //inner inset
    CGRect iF = CGRectInset(sF, iI, iI);   //inner frame
    
    CGRect pF = iF;    //range frame, progress frame
    CGFloat iW = CGRectGetWidth(iF);    //innner width
    pF.size.width = iW * _progress;
    if (!CDEqualFloatRanges(_range, CDMakeFloatRange(0.0f, 1.0f))) {   //need draw range
        CGRect rF = iF;
        rF.origin.x += iW * _range.location;
        rF.size.width = iW * _range.length;
        [_rangeColor setFill];
        drawRoundEndPath(rF);
        CGContextDrawPath(c, kCGPathFill);
        
        pF.origin.x += iW * _range.location;
        pF.size.width -= iW * _range.location;
        if (CGRectGetWidth(pF) > CGRectGetWidth(rF)) pF.size.width = CGRectGetWidth(rF);
    }
    
    [_drawColor setFill];
    drawRoundEndPath(pF);
    CGContextDrawPath(c, kCGPathFill);
}

#pragma mark - Progress
- (void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark - Range
- (void)cleanRange{
    _range.location = 0.0f;
    _range.length = 1.0f;
}

- (void)setRange:(CDFloatRange)range{
    _range.location = limitedFloat(range.location, 0.0f, 1.0f);
    _range.length = limitedFloat(range.length, 0.0f, 1.0f);
    if (_range.location + _range.length > 1) return;
    [self setNeedsDisplay];
}

@end

@interface CDSliderThumb ()
- (void)updateThumbLocationWithValue:(float)value;
- (void)endOrCancelTracking;
@end

@implementation CDSliderThumb
@synthesize thumbOn = _thumbOn;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect f = self.bounds;
        f.origin.y += (CGRectGetHeight(self.bounds) - kThumbHeight) / 2;
        f.size.width = kThumbWidth;
        f.size.height = kThumbHeight;
        _thumbImageView = [[UIImageView alloc] initWithFrame:f];
        _thumbImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_thumbImageView];
    }
    return self;
}

#pragma mark - Value Change
- (void)setValue:(float)value{
    _value = limitedFloat(value, 0, 1);
    [self updateThumbLocationWithValue:_value];
}

- (void)updateThumbLocationWithValue:(float)value{
    CGFloat destination = (self.bounds.size.width - kThumbWidth) * value + kThumbWidth / 2;
    CGPoint destinationPoint = CGPointMake(destination, _thumbImageView.center.y);
    _thumbImageView.center = destinationPoint;
}

#pragma mark - Touch events handling
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_thumbImageView.frame, touchPoint)){
        _thumbOn = YES;
    }else {
        _thumbOn = NO;
    }
    return _thumbOn;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    float newValue = (touchPoint.x - kThumbWidth / 2) / (self.bounds.size.width - kThumbWidth);
    self.value = newValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    float newValue = (touchPoint.x - kThumbWidth / 2) / (self.bounds.size.width - kThumbWidth);
    self.value = newValue;
    [self endOrCancelTracking]; //Must do this before next command
    [self sendActionsForControlEvents:UIControlEventValueChanged];  //Only when thumbOn is NO the value of slider can be sent to instance outside.
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [self endOrCancelTracking];
}

- (void)endOrCancelTracking {
    _thumbOn = NO;
}


@end
