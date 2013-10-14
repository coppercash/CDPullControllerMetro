//
//  CDMasterButton.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroCell.h"
@class CDMasterPresentDraw, CDMasterPlayerDraw;
@interface CDMasterButton : CDMetroCell {
    CDMasterPresentDraw *_present;
    CDMasterPlayerDraw *_player;
    BOOL _isPresented;
    BOOL _isPlaying;
    float _progress;
}
@property(nonatomic, assign)BOOL isPlaying;
@property(nonatomic, readonly)CDMasterPresentDraw *present;
//- (BOOL)isPresented;
- (void)presentAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
@end

#import "CDProgressView.h"
@interface CDMasterPresentDraw : CDProgressDraw {
    CGRect _stageRect;
    UIBezierPath *_trackButton;
}
@end

@interface CDMasterPlayerDraw : CDMetroDraw {
    BOOL _isPlaying;
}
@property(nonatomic, assign)BOOL isPlaying;

@end

#define CGPointWithOffset(originPoint, offsetPoint) \
CGPointMake(originPoint.x + offsetPoint.x, originPoint.y + offsetPoint.y)
CGRect stageFrame(CGRect rect, CGFloat shorterInset);
void drawPlusSymol(UIBezierPath * path, CGRect rect, CGFloat scale);
void drawTrackAndButton(UIBezierPath *path, CGRect rect);
void drawPlayButton(UIBezierPath *path, CGRect rect);
void drawPauseButton(UIBezierPath *path, CGRect rect);
void drawTriangleBoundsInRect(UIBezierPath *path, CGRect rect);