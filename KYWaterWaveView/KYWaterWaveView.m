//
//  KYWaterWaveView.m
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYWaterWaveView.h"


@interface KYWaterWaveView()


@end

@implementation KYWaterWaveView{
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _offsetX;
    
    CADisplayLink *_waveDisplaylink;
    CAShapeLayer  *_waveLayer;
    
}

- (void)_initWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds  = YES;
    _waterWaveHeight = frame.size.height / 2;
    _waterWaveWidth  = frame.size.width;
    
    self.waveAmplitude = 6;
    self.waveSpeed = 6;
    self.waveColor = [UIColor blueColor];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initWithFrame:frame];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initWithFrame:self.frame];
    }
    
    return self;
}

- (void)wave {
    _waveLayer = [CAShapeLayer layer];
    _waveLayer.fillColor = self.waveColor.CGColor;
    [self.layer addSublayer:_waveLayer];
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)getCurrentWave:(CADisplayLink *)displayLink {
    _offsetX += self.waveSpeed;
    CGPathRef path =[self getgetCurrentWavePath];
    _waveLayer.path = path;
    if (path != NULL) {
        CGPathRelease(path);
        path = NULL;
    }
}

- (CGPathRef)getgetCurrentWavePath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, _waterWaveHeight);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  _waterWaveWidth ; x++) {
        y = self.waveAmplitude* sinf((360/_waterWaveWidth) *(x * M_PI / 180) - _offsetX * M_PI / 180) + _waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    return path;
}

- (void)stop {
    [_waveLayer removeFromSuperlayer];
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
}


@end
