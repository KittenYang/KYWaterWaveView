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
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    CAShapeLayer  *waveLayer;
    UIBezierPath *waveBoundaryPath;
    CAShapeLayer *waveBoundaryLayer;
    
    UIView *fish;
    UIDynamicAnimator *animator;
    UIPushBehavior *push;
    UIGravityBehavior * grav;
    UICollisionBehavior *coll;
    
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = frame.size.height / 2;
        waterWaveWidth  = frame.size.width;

    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = self.frame.size.height / 2;
        waterWaveWidth  = self.frame.size.width;

    }
    return self;
}

-(void) wave{
    waveBoundaryPath = [UIBezierPath bezierPath];
    waveBoundaryLayer = [CAShapeLayer layer];

    waveBoundaryLayer.strokeColor = [UIColor orangeColor].CGColor;
    waveBoundaryLayer.fillColor   = [UIColor clearColor].CGColor;
    waveBoundaryLayer.lineWidth = 2.0f;
    [self.layer addSublayer:waveBoundaryLayer];
    
    waveLayer = [CAShapeLayer layer];
    waveLayer.fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
    [self.layer addSublayer:waveLayer];
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
    fish = [[UIView alloc]initWithFrame:CGRectMake(0, waterWaveHeight, 30, 30)];
    fish.backgroundColor = [UIColor redColor];
    [self addSubview:fish];
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath moveToPoint:CGPointMake(0, waterWaveHeight)];
    [trackPath addQuadCurveToPoint:CGPointMake(waterWaveWidth, waterWaveHeight) controlPoint:CGPointMake(waterWaveWidth / 2, waterWaveHeight / 2 + 10)];
    
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = trackPath.CGPath;
    trackLayer.strokeColor = [UIColor blueColor].CGColor;
    trackLayer.fillColor   = [UIColor clearColor].CGColor;
    trackLayer.lineWidth = 2.0f;
    [self.layer addSublayer:trackLayer];
    
    
    CAKeyframeAnimation *fishAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    fishAnim.path = trackPath.CGPath;
    fishAnim.autoreverses = YES;
    fishAnim.repeatCount = HUGE_VALF;
    fishAnim.rotationMode = kCAAnimationRotateAutoReverse;
    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.3 :0.9:0.7];
    fishAnim.duration = 1;
    [fish.layer addAnimation:fishAnim forKey:@"fish"];
    
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    NSArray *items = @[fish];
//    push= [[UIPushBehavior alloc]initWithItems:items mode:UIPushBehaviorModeInstantaneous];
//    push.pushDirection = CGVectorMake(0.5, -0.5);
//    
//    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:items];
//    item.resistance = 1;
//    item.density = 1000;
//    grav = [[UIGravityBehavior alloc]initWithItems:items];
//    [animator addBehavior:push];
//    [animator addBehavior:grav];
    
    coll = [[UICollisionBehavior alloc]initWithItems:items];
    [animator addBehavior:coll];
    

}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    [coll removeAllBoundaries];
    offsetX += self.waveSpeed;
    waveLayer.path = [self getgetCurrentWavePath];
    waveBoundaryPath.CGPath = waveLayer.path;
    
    [coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
    waveBoundaryLayer.path = waveBoundaryPath.CGPath;
}

-(CGPathRef)getgetCurrentWavePath{

    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, waterWaveHeight);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        y = self.waveAmplitude* sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    
    return path;
}

-(void) stop{
    [waveDisplaylink invalidate];
    waveDisplaylink = nil;
}


@end
