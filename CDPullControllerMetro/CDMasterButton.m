//
//  CDMasterButton.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMasterButton.h"
#import "CDProgressView.h"
CGRect stageFrame(CGRect rect, CGFloat shorterInset){
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat longerInset = fabsf(width - height) / 2 + shorterInset;
    CGRect sF;  //stage frame
    if (CGRectGetWidth(rect) > CGRectGetHeight(rect)) {
        sF = CGRectInset(rect, longerInset, shorterInset);
    }else{
        sF = CGRectInset(rect, shorterInset, longerInset);
    }
    return sF;
}
void drawTrackAndButton(UIBezierPath *path, CGRect rect){
    CGFloat tOR = 0.5 * MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)); //track outter radius
    CGFloat tW = tOR * 0.03;    //track width
    CGFloat tIR = tOR - tW; //track innner radius
    CGFloat bR = tIR * 0.7; //button radius
    CGPoint cen = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));    //center
    
    [path moveToPoint:CGPointMake(cen.x + tOR, cen.y)];
    [path addArcWithCenter:cen radius:tOR startAngle:0 endAngle:2 * M_PI clockwise:true];
    
    [path moveToPoint:CGPointMake(cen.x + tIR, cen.y)];
    [path addArcWithCenter:cen radius:tIR startAngle:0 endAngle:2 * M_PI clockwise:true];
    
    [path moveToPoint:CGPointMake(cen.x + bR, cen.y)];
    [path addArcWithCenter:cen radius:bR startAngle:0 endAngle:2 * M_PI clockwise:true];
    
    drawPlusSymol(path, rect, 0.7);
}
void drawPlusSymol(UIBezierPath * path, CGRect rect, CGFloat scale){
    // plus
    //
    //     c-d
    //     | |
    //  a--b e--f
    //  |       |
    //  l--k h--g
    //     | |
    //     j-i
    //
    CGFloat height     = CGRectGetHeight(rect) * scale;
    CGFloat width      = CGRectGetWidth(rect)  * scale;
    CGFloat size       = (height < width ? height : width) * scale;
    CGFloat thick      = size / 3.f;
    CGFloat twiceThick = thick * 2.f;
    
    CGPoint offsetPoint =
    CGPointMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect)  - size) / 2.f,
                CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size) / 2.f);
    
    [path moveToPoint:CGPointWithOffset(CGPointMake(0.f, thick), offsetPoint)];                // a
    [path addLineToPoint:CGPointWithOffset(CGPointMake(thick, thick), offsetPoint)];           // b
    [path addLineToPoint:CGPointWithOffset(CGPointMake(thick, 0.f), offsetPoint)];             // c
    [path addLineToPoint:CGPointWithOffset(CGPointMake(twiceThick, 0.f), offsetPoint)];        // d
    [path addLineToPoint:CGPointWithOffset(CGPointMake(twiceThick, thick), offsetPoint)];      // e
    [path addLineToPoint:CGPointWithOffset(CGPointMake(size, thick), offsetPoint)];            // f
    [path addLineToPoint:CGPointWithOffset(CGPointMake(size, twiceThick), offsetPoint)];       // g
    [path addLineToPoint:CGPointWithOffset(CGPointMake(twiceThick, twiceThick), offsetPoint)]; // h
    [path addLineToPoint:CGPointWithOffset(CGPointMake(twiceThick, size), offsetPoint)];       // i
    [path addLineToPoint:CGPointWithOffset(CGPointMake(thick, size), offsetPoint)];            // j
    [path addLineToPoint:CGPointWithOffset(CGPointMake(thick, twiceThick), offsetPoint)];      // k
    [path addLineToPoint:CGPointWithOffset(CGPointMake(0.f, twiceThick), offsetPoint)];        // l
    [path closePath];
}
void drawPlayButton(UIBezierPath *path, CGRect rect){
    CGFloat r = 0.5 * MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)); //radius
    CGPoint c = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));    //center
    
    [path moveToPoint:CGPointMake(c.x + r, c.y)];
    [path addArcWithCenter:c radius:r startAngle:0 endAngle:2 * M_PI clockwise:true];
    
    float s = 0.25;  //scale
    CGRect tF = CGRectInset(rect, s * CGRectGetWidth(rect), s * CGRectGetHeight(rect)); //triangle frame
    tF.origin.x += 0.125 * CGRectGetWidth(tF);
    drawTriangleBoundsInRect(path, tF);    
}
void drawPauseButton(UIBezierPath *path, CGRect rect){
    CGFloat r = 0.5 * MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)); //radius
    CGPoint c = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));    //center
    
    [path moveToPoint:CGPointMake(c.x + r, c.y)];
    [path addArcWithCenter:c radius:r startAngle:0 endAngle:2 * M_PI clockwise:true];

    float s = 0.3;  //scale
    CGRect bF = CGRectInset(rect, s * CGRectGetWidth(rect), s * CGRectGetHeight(rect)); //button frame

    CGFloat gap = 0.2 * CGRectGetWidth(bF);
    CGRect lR = bF;   //left rect
    lR.size.width = 0.5 * (CGRectGetWidth(bF) - gap);
    CGRect rR = bF;   //right rect
    rR.origin.x += CGRectGetWidth(lR) + gap;
    rR.size.width = CGRectGetWidth(lR);
    
    [path appendPath:[UIBezierPath bezierPathWithRect:lR]];
    [path appendPath:[UIBezierPath bezierPathWithRect:rR]];
}
void drawTriangleBoundsInRect(UIBezierPath *path, CGRect rect){
    /*
     a__|_w_|
        |\  |
        | \ h / 2
        |__\|___b
        |  /
        | /
     c__|/
     */
    
    CGPoint a = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint b = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    CGPoint c = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));

    [path moveToPoint:a];
    [path addLineToPoint:b];
    [path addLineToPoint:c];
    [path closePath];
}

@implementation CDMasterButton
@synthesize isPlaying = _isPlaying;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self presentFrom:CDDirectionNone];
    }
    return self;
}

- (void)loadContentView:(UIView *)contentView{
    _present = [[CDMasterPresentDraw alloc] initWithFrame:contentView.bounds];
    _present.autoresizingMask = CDViewAutoresizingNoMaigin;
    [contentView addSubview:_present];
}

- (void)presentAnimated:(BOOL)animated{
    if (_isPresented == YES) return;
    _isPresented = YES;
    
    if (_player != nil) [_player removeFromSuperview];
    _player = [[CDMasterPlayerDraw alloc] initWithFrame:_contentView.bounds];
    _player.autoresizingMask = CDViewAutoresizingNoMaigin;
    _player.isPlaying = _isPlaying;
    [_contentView addSubview:_player];
    _contentView.frame = self.bounds;   //correct the master's frame after expanding.
    
    if (animated) {
        _player.alpha = 0.0f;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _present.alpha = 0.0f;
            _player.alpha = 1.0f;
        } completion:nil];
    }else{
        _present.alpha = 0.0f;
        _player.alpha = 1.0f;
    }
}

- (void)dismissAnimated:(BOOL)animated{
    if (_isPresented == NO) return;
    _isPresented = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _present.alpha = 1.0f;
            _player.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_player removeFromSuperview];
            SafeMemberRelease(_player);
        }];
    }else{
        _present.alpha = 1.0f;
        [_player removeFromSuperview];
        SafeMemberRelease(_player);
    }
}

- (void)setIsPlaying:(BOOL)isPlaying{
    if (self.isPresented) _player.isPlaying = isPlaying;
    _isPlaying = isPlaying;
}

@end

@implementation CDMasterPresentDraw

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef c =  UIGraphicsGetCurrentContext();    //context
    
    void (^drawSector)(CGRect, float, float, float) = ^(CGRect rect, float radiusScale, float location, float length){
        CGContextBeginPath(c);
        
        CGFloat sR = - 0.25 * 2 * M_PI; //start radians
        sR += location * 2 * M_PI;
        CGFloat eR = sR + length * 2 * M_PI;    //end radians
        
        CGPoint cen = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));    //center
        
        CGFloat oR = 0.5 * MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));   //outter radius
        CGFloat iR = oR * (1 - radiusScale);    //innner radius
        
        CGContextAddArc(c, cen.x, cen.y, oR, sR, eR, false);
        CGContextAddArc(c, cen.x, cen.y, iR, eR, sR, true);
        
        CGContextClosePath(c);
    };
    
    //make a square as stage
    CGRect sF = stageFrame(rect, _shorterInset);
    
    //draw progress and range(if exist)
    CGFloat pR = 0.05 * CGRectGetWidth(sF); //progress radius.Assert width == height
    CGRect pF = CGRectInset(sF, pR, pR); //progress frame
    CGFloat pLo = 0.0f, pLe = _progress;    //progress location, progress length
    float pWS = 0.18;    //progress width scale
    if (!CDEqualFloatRanges(_range, CDMakeFloatRange(0.0f, 1.0f))) {   //need draw range
        drawSector(pF, pWS, _range.location, _range.length);
        [_rangeColor setFill];
        CGContextDrawPath(c, kCGPathFill);
        
        pLo += _range.location;
        pLe = limitedFloat(pLe - _range.location, 0.0f, _range.length);
    }
    drawSector(pF, pWS, pLo, pLe);
    [_drawColor setFill];
    CGContextDrawPath(c, kCGPathFill);
    
    //redraw track and button if nedd
    if (!CGRectEqualToRect(sF, _stageRect)) {
        _stageRect = sF;
        _trackButton = [[UIBezierPath alloc] init];
        drawTrackAndButton(_trackButton, sF);
    }
    CGContextAddPath(c, _trackButton.CGPath);
    CGContextDrawPath(c, kCGPathEOFill);
}

@end

@implementation CDMasterPlayerDraw
@synthesize isPlaying = _isPlaying;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext(); //context
    CGRect sF = stageFrame(rect, _shorterInset);    //stage frame
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (_isPlaying) {
        drawPauseButton(path, sF);
    }else{
        drawPlayButton(path, sF);
    }
    [_drawColor setFill];
    CGContextAddPath(c, path.CGPath);
    CGContextDrawPath(c, kCGPathEOFill);
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    [self setNeedsDisplay];
}

- (void)setShorterInset:(CGFloat)shorterInset{
    _shorterInset = shorterInset;
    [self setNeedsDisplay];
}

- (void)setDrawColor:(UIColor *)color{
    _drawColor = [color copy];
    [self setNeedsDisplay];
}

@end