//
//  CDProgressView.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/25/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroView.h"
@class CDProgressDraw, CDSliderThumb;
@interface CDProgressView : CDMetroView {
    CDSliderThumb *_thumb;
    float _progress;
}
@property(nonatomic, strong)CDSliderThumb *thumb;
@property(nonatomic, assign)float progress;
- (CDProgressDraw *)progressView;
@end

@interface CDProgressDraw : CDMetroDraw{
    UIColor *_rangeColor;
    
    float _progress;
    CDFloatRange _range;
}
@property(nonatomic, copy)UIColor *rangeColor;
@property(nonatomic, assign)float progress;
@property(nonatomic, assign)CDFloatRange range;
- (void)cleanRange;
@end

#define kThumbHeight 25.0f
#define kThumbWidth kThumbHeight
@interface CDSliderThumb : UIControl{
    BOOL _thumbOn;                              // track the current touch state of the slider
    UIImageView* _thumbImageView;               // the slide knob
}
@property(nonatomic, assign)float value;               // default 0.0. this value will be pinned to min/max
@property(nonatomic, assign)BOOL thumbOn;
@end
