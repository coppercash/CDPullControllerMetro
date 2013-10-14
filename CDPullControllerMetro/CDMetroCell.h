//
//  CDPullBorromBarCell.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroView.h"

typedef enum {
    CDMetroCellStyleNone,
    CDMetroCellStyleBackward,
    CDMetroCellStyleForward
}CDMetroCellStyle;

@protocol CDMetroCellDelegate;
@interface CDMetroCell : CDMetroView {
    BOOL _darken;
    CALayer *_shade;
    
    CDMetroCellStyle _style;
    
    __weak id<CDMetroCellDelegate> _delegate;
}
@property(nonatomic, assign)BOOL darken;
@property(nonatomic, weak)id<CDMetroCellDelegate> delegate;
- (id)initWithFrame:(CGRect)frame style:(CDMetroCellStyle)style;
@end

@protocol CDMetroCellDelegate <NSObject>
@optional
- (void)touchBeganInCell:(CDMetroCell *)cell;
- (void)touchEndInCell:(CDMetroCell *)cell;
@end

@interface CDBackwardDraw : CDMetroDraw
@end

@interface CDForwardDraw : CDMetroDraw
@end

void drawForwardButton(UIBezierPath *path, CGRect rect);