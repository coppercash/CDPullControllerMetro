//
//  CDPullBorromBarCell.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroCell.h"
#import "CDMasterButton.h"


@implementation CDMetroCell
@synthesize darken = _darken;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _darken = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(CDMetroCellStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        _darken = YES;
        
        switch (_style = style) {
            case CDMetroCellStyleBackward:
                _contentClass = [CDBackwardDraw class];
                break;
            case CDMetroCellStyleForward:
                _contentClass = [CDForwardDraw class];
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //DLog(@"Began");
    
    if (_darken) {
        _shade = [[CALayer alloc] init];
        _shade.frame = self.bounds;
        _shade.backgroundColor = [[UIColor alloc] initWithWhite:0.0f alpha:0.5f].CGColor;
        [self.layer addSublayer:_shade];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(touchBeganInCell:)]) {
        [_delegate touchBeganInCell:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    //DLog(@"End");
    if (_darken) {
        [_shade removeFromSuperlayer];
        SafeMemberRelease(_shade);
    }

    if (_delegate && [_delegate respondsToSelector:@selector(touchEndInCell:)]) {
        [_delegate touchEndInCell:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if (_darken) {
        [_shade removeFromSuperlayer];
        SafeMemberRelease(_shade);
    }
    
    //DLog(@"Cancel");
}

@end

void drawForwardButton(UIBezierPath *path, CGRect rect){
    CGFloat h = 0.6 * CGRectGetWidth(rect);   //height;
    rect.origin.y += 0.5 * (CGRectGetHeight(rect) - h);
    rect.size.height = h;
    
    CGRect lF = rect, rF = rect;    //left frame, right frame
    lF.size.width = 0.5 * CGRectGetWidth(rect);
    rF.origin.x = CGRectGetMaxX(lF);
    rF.size.width = 0.5 * CGRectGetWidth(rect);
    
    drawTriangleBoundsInRect(path, lF);
    drawTriangleBoundsInRect(path, rF);
}

@implementation CDBackwardDraw
- (void)drawRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext() ;    //context
    CGRect sF = stageFrame(rect, _shorterInset); //stage frame
    
    UIBezierPath *p = [[UIBezierPath alloc] init];   //path
    drawForwardButton(p, sF);
    CGAffineTransform transform = CGAffineTransformMake(-1, 0, 0, 1, CGRectGetWidth(rect), 0);
    [p applyTransform:transform];
    CGContextAddPath(c, p.CGPath);
    [_drawColor setFill];
    CGContextDrawPath(c, kCGPathFill);
}
@end

@implementation CDForwardDraw
- (void)drawRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext() ;    //context
    CGRect sF = stageFrame(rect, _shorterInset); //stage frame
    
    UIBezierPath *p = [[UIBezierPath alloc] init];   //path
    drawForwardButton(p, sF);
    CGContextAddPath(c, p.CGPath);
    [_drawColor setFill];
    CGContextDrawPath(c, kCGPathFill);
}
@end