//
//  CDMetroView.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDMetroView : UIView{
    UIView *_contentView;
    Class _contentClass;
    UIColor *_metroColor;
    
    NSTimeInterval _presentDuration;
    NSTimeInterval _dismissDuration;
}
@property(nonatomic, assign)Class contentClass;
@property(nonatomic, copy)UIColor *metroColor;
@property(nonatomic, assign)NSTimeInterval presentDuration;
@property(nonatomic, assign)NSTimeInterval dismissDuration;
- (BOOL)isPresented;
- (void)present;
- (void)dismiss;
- (void)presentFrom:(CDDirection)direction;    //CDDirectionNone indicates no animation;
- (void)dismissTo:(CDDirection)direction;   //CDDirectionNone indicates no animation;
- (void)presentDelay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion;
- (void)dismissDelay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion;
- (void)presentFrom:(CDDirection)direction delay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion;
- (void)dismissTo:(CDDirection)direction delay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion;
- (void)loadContentView:(UIView *)contentView;
- (void)cleanContentView;
@end

@interface CDMetroDraw : UIView{
    CGSize _inset;
    CGFloat _shorterInset;
    UIColor *_drawColor;
}
@property(nonatomic, assign)CGSize inset;
@property(nonatomic, assign)CGFloat shorterInset;
@property(nonatomic, copy)UIColor *drawColor;
@end

@interface UIView (AnimateControl)
- (void)setIsAnimating:(BOOL)isAnimating;
- (BOOL)isAnimating;
@end

CDDirection randomDirection();