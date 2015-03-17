//
//  KYWaterWaveView.m
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define pathPadding 30

#import "KYWaterWaveView.h"



@interface KYWaterWaveView()<UICollisionBehaviorDelegate>


@end

@implementation KYWaterWaveView{
    CALayer *l;
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    CAShapeLayer  *waveLayer;
    UIBezierPath *waveBoundaryPath;
    CAShapeLayer *waveBoundaryLayer;
    
    UIView *fish;
    UIView *boot;
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
    
    
    fish = [[UIView alloc]initWithFrame:CGRectMake(waterWaveWidth - pathPadding - 30,waterWaveHeight - 50, 30, 30)];
    fish.tag = 101;
    fish.backgroundColor = [UIColor redColor];
    [self addSubview:fish];
    
    boot = [[UIView alloc]initWithFrame:CGRectMake(25,5 ,20,20 )];
    boot.tag = 100;
    boot.backgroundColor = [UIColor purpleColor];
    [self addSubview:boot];
    
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(pathPadding+fish.frame.size.width / 2, fish.center.y);
    [trackPath moveToPoint:startP];
    [trackPath addQuadCurveToPoint:fish.center controlPoint:CGPointMake((fish.center.x - startP.x) / 2 + startP.x, fish.center.y -30)];
    
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = trackPath.CGPath;
    trackLayer.strokeColor = [UIColor blueColor].CGColor;
    trackLayer.fillColor   = [UIColor clearColor].CGColor;
    trackLayer.lineWidth = 2.0f;
    [self.layer addSublayer:trackLayer];
    
    
    CAKeyframeAnimation *fishAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    fishAnim.path = trackPath.CGPath;
//    fishAnim.repeatCount = HUGE_VALF;
    fishAnim.rotationMode = kCAAnimationRotateAutoReverse;
//    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.7 :0.7 :0.3];
    fishAnim.duration = 1;
    fishAnim.delegate = self;
    [fish.layer addAnimation:fishAnim forKey:@"fishAnim"];
    
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    NSArray *bootItem = @[boot];

    grav = [[UIGravityBehavior alloc]initWithItems:bootItem];
    [animator addBehavior:grav];
    
    coll = [[UICollisionBehavior alloc]initWithItems:bootItem];
    coll.collisionDelegate = self;
    [animator addBehavior:coll];
    
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    [coll removeAllBoundaries];
    offsetX += self.waveSpeed;
    waveLayer.path = [self getgetCurrentWavePath];
    waveBoundaryPath.CGPath = waveLayer.path;
    
    waveBoundaryLayer.path = waveBoundaryPath.CGPath;
    [coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
    
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

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [fish.layer removeAllAnimations];
    [coll addItem:fish];
    [grav addItem:fish];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p{
   
    UIView *view = (UIView *)item;
    if (view.tag == 101) {
        view.backgroundColor = [UIColor yellowColor];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor redColor];
        }];
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p{
    
    if ([item isEqual:fish] && (p.x > waterWaveWidth *2/ 3 )){
        fish.backgroundColor = [UIColor redColor];
    }
}

@end
