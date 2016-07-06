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

@property (nonatomic, strong) UIImageView *fish;

@end

@implementation KYWaterWaveView{
    CALayer *l;
    
    BOOL fishFirstColl;
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    CAShapeLayer  *waveLayer;
    UIBezierPath *waveBoundaryPath;
    
    UIView *dropView;;
    UIView *dropView2;
    UIView *dropView3;
    UIImageView *boot;
    UIDynamicAnimator *animator;
    UIPushBehavior *push;
    UIGravityBehavior * grav;
    UICollisionBehavior *coll;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = frame.size.height / 2;
        waterWaveWidth  = frame.size.width;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = self.frame.size.height / 2;
        waterWaveWidth  = self.frame.size.width;

    }
    return self;
}

#pragma mark - public
- (void)wave {
    waveBoundaryPath = [UIBezierPath bezierPath];
    
    waveLayer = [CAShapeLayer layer];
    waveLayer.fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
    [self.layer addSublayer:waveLayer];
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    boot = [[UIImageView alloc]initWithFrame:CGRectMake(20,12 ,20,20 )];
    boot.tag = 100;
    boot.backgroundColor = [UIColor clearColor];
    boot.image = [UIImage imageNamed:@"ship"];
    [self addSubview:boot];
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    NSArray *items = @[boot];
    grav = [[UIGravityBehavior alloc]initWithItems:items];
    [animator addBehavior:grav];
    
    coll = [[UICollisionBehavior alloc]initWithItems:items];
    coll.collisionDelegate = self;
    [animator addBehavior:coll];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(fishJump) userInfo:nil repeats:YES];
}

- (void)stop {
    [waveDisplaylink invalidate];
    waveDisplaylink = nil;
}

#pragma mark - helper
- (void)getCurrentWave:(CADisplayLink *)displayLink {
    [coll removeAllBoundaries];
    offsetX += self.waveSpeed;
    waveBoundaryPath = [self getgetCurrentWavePath];
    waveLayer.path = waveBoundaryPath.CGPath;
    
    [coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
}

- (UIBezierPath *)getgetCurrentWavePath {
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
    CGPathRelease(path);
    return p;
}

- (void)fishJump {
    self.fish.hidden = NO;
    fishFirstColl = NO;
    if (self.fish == nil) {
        _fish = [[UIImageView alloc]initWithFrame:CGRectZero];
        _fish.image = [UIImage imageNamed:@"fish"];
        _fish.tag = 101;
        _fish.backgroundColor = [UIColor clearColor];
        [self addSubview:_fish];
    }
    
    self.fish.frame = CGRectMake(waterWaveWidth - pathPadding - 30,waterWaveHeight - 15, 30, 30);
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(pathPadding+_fish.frame.size.width / 2, _fish.center.y);
    [trackPath moveToPoint:startP];
    [trackPath addQuadCurveToPoint:_fish.center controlPoint:CGPointMake((_fish.center.x - startP.x) / 2 + startP.x, _fish.center.y -60)];
    
    CAKeyframeAnimation *fishAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    fishAnim.path = trackPath.CGPath;
    fishAnim.rotationMode = kCAAnimationRotateAuto;
    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
    fishAnim.delegate = self;
    fishAnim.duration = 1;
    fishAnim.removedOnCompletion = NO;
    fishAnim.fillMode = kCAFillModeForwards;
    [_fish.layer addAnimation:fishAnim forKey:@"fishAnim"];
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    NSArray *items = @[boot];
    grav = [[UIGravityBehavior alloc]initWithItems:items];
    [animator addBehavior:grav];
    
    coll = [[UICollisionBehavior alloc]initWithItems:items];
    coll.collisionDelegate = self;
    [animator addBehavior:coll];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [dropView.layer animationForKey:@"dropAnim"]) {
        [dropView.layer removeAllAnimations];
        [dropView2.layer removeAllAnimations];
        [dropView3.layer removeAllAnimations];
        [grav addItem:dropView];
        [grav addItem:dropView2];
        [grav addItem:dropView3];
    }else if (anim == [_fish.layer animationForKey:@"fishAnim"]){
        [_fish.layer removeAllAnimations];
        [grav addItem:_fish];
        [coll addItem:_fish];
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p {
   
    UIView *view = (UIView *)item;
    if (view.tag == 101 && !fishFirstColl) {
        self.fish.hidden = YES;
        fishFirstColl = YES;
        
        //第一个水滴
        if (dropView == nil) {
            dropView = [[UIView alloc]initWithFrame:CGRectZero];
            [self addSubview:dropView];
            dropView.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
        }
        dropView.center = CGPointMake(p.x - 40, p.y);
        dropView.bounds = CGRectMake(0, 0, 5, 5);
        dropView.layer.cornerRadius = dropView.frame.size.width / 2;
        
        UIBezierPath *dropPath = [UIBezierPath bezierPath];
        [dropPath moveToPoint:p];
        [dropPath addQuadCurveToPoint:dropView.center controlPoint:CGPointMake((p.x - dropView.center.x) / 2 + dropView.center.x, p.y - 30)];
        
        CAKeyframeAnimation *dropAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        dropAnim.path = dropPath.CGPath;
        dropAnim.duration = 0.5f;
        dropAnim.timingFunction =  [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
        dropAnim.delegate = self;
        dropAnim.removedOnCompletion = NO;
        dropAnim.fillMode = kCAFillModeForwards;
        [dropView.layer addAnimation:dropAnim forKey:@"dropAnim"];
        
        
        //第二个水滴
        if (dropView2 == nil) {
            dropView2 = [[UIView alloc]initWithFrame:CGRectZero];
            dropView2.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:dropView2];
        }
        dropView2.center = CGPointMake(p.x - 50, p.y);
        dropView2.bounds = CGRectMake(0, 0, 5, 5);
        dropView2.layer.cornerRadius = dropView2.frame.size.width / 2;
        
        UIBezierPath *dropPath2 = [UIBezierPath bezierPath];
        [dropPath2 moveToPoint:p];
        [dropPath2 addQuadCurveToPoint:dropView2.center controlPoint:CGPointMake((p.x - dropView2.center.x) / 2 + dropView2.center.x, p.y - 20)];
        
        CAKeyframeAnimation *dropAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        dropAnim2.path = dropPath2.CGPath;
        dropAnim2.duration = 0.5f;
        dropAnim2.timingFunction =  [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
        dropAnim2.delegate = self;
        dropAnim2.removedOnCompletion = NO;
        dropAnim2.fillMode = kCAFillModeForwards;
        [dropView2.layer addAnimation:dropAnim2 forKey:@"dropAnim2"];
        
        
        //第三个水滴
        if (dropView3 == nil) {
            dropView3 = [[UIView alloc]initWithFrame:CGRectZero];
            dropView3.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:dropView3];
        }
        dropView3.center = CGPointMake(p.x + 50, p.y);
        dropView3.bounds = CGRectMake(0, 0, 5, 5);
        dropView3.layer.cornerRadius = dropView3.frame.size.width / 2;
        
        UIBezierPath *dropPath3 = [UIBezierPath bezierPath];
        [dropPath3 moveToPoint:p];
        [dropPath3 addQuadCurveToPoint:dropView3.center controlPoint:CGPointMake((dropView3.center.x - p.x) / 2 + p.x, p.y - 20)];
        
        CAKeyframeAnimation *dropAnim3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        dropAnim3.path = dropPath3.CGPath;
        dropAnim3.duration = 0.5f;
        dropAnim3.timingFunction =  [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
        dropAnim3.delegate = self;
        dropAnim3.removedOnCompletion = NO;
        dropAnim3.fillMode = kCAFillModeForwards;
        [dropView3.layer addAnimation:dropAnim3 forKey:@"dropAnim3"];

    }
    
}

@end
