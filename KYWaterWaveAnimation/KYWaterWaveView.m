//
//  KYWaterWaveView.m
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define pathPadding 10

#import "KYWaterWaveView.h"



@interface KYWaterWaveView()<UICollisionBehaviorDelegate>

@property (nonatomic,strong)    UIImageView *fish;

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
    CAShapeLayer *waveBoundaryLayer;
    
    UIView *dropView;;
    UIView *dropView2;
    UIView *dropView3;
    UIImageView *boot;
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
    
//    [self performSelector:@selector(fishJump) withObject:nil afterDelay:2.0f];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(fishJump) userInfo:nil repeats:YES];
    
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

-(void)fishJump{
    
    fishFirstColl = NO;
    _fish = [[UIImageView alloc]initWithFrame:CGRectMake(waterWaveWidth - pathPadding - 30,waterWaveHeight - 20, 30, 30)];
    _fish.image = [UIImage imageNamed:@"fish"];
    _fish.tag = 101;
    _fish.backgroundColor = [UIColor clearColor];
    [self addSubview:_fish];
    
    boot = [[UIImageView alloc]initWithFrame:CGRectMake(25,5 ,20,20 )];
    boot.tag = 100;
    boot.backgroundColor = [UIColor clearColor];
    [self addSubview:boot];
    
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(pathPadding+_fish.frame.size.width / 2, _fish.center.y);
    [trackPath moveToPoint:startP];
    [trackPath addQuadCurveToPoint:_fish.center controlPoint:CGPointMake((_fish.center.x - startP.x) / 2 + startP.x, _fish.center.y -60)];
    
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = trackPath.CGPath;
    trackLayer.strokeColor = [UIColor blueColor].CGColor;
    trackLayer.fillColor   = [UIColor clearColor].CGColor;
    trackLayer.lineWidth = 2.0f;
    //    [self.layer addSublayer:trackLayer];
    
    
    CAKeyframeAnimation *fishAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    fishAnim.path = trackPath.CGPath;
    //    fishAnim.repeatCount = HUGE_VALF;
    fishAnim.rotationMode = kCAAnimationRotateAuto;
    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :0.9:0.6];
    fishAnim.delegate = self;
    fishAnim.duration = 1;
    fishAnim.removedOnCompletion = NO;
    fishAnim.fillMode = kCAFillModeForwards;
    [_fish.layer addAnimation:fishAnim forKey:@"fishAnim"];
    
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    NSArray *bootItem = @[boot];
    
    grav = [[UIGravityBehavior alloc]initWithItems:bootItem];
    [animator addBehavior:grav];
    
    coll = [[UICollisionBehavior alloc]initWithItems:bootItem];
    coll.collisionDelegate = self;
    [animator addBehavior:coll];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (anim == [dropView.layer animationForKey:@"dropAnim"]) {
        [dropView.layer removeAllAnimations];
        [dropView2.layer removeAllAnimations];
        [grav addItem:dropView];
        [grav addItem:dropView2];
        [grav addItem:dropView3];
    }else if (anim == [_fish.layer animationForKey:@"fishAnim"]){
        [_fish.layer removeAllAnimations];
        [grav addItem:_fish];
        [coll addItem:_fish];
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p{
   
    UIView *view = (UIView *)item;
    if (view.tag == 101 && !fishFirstColl) {

        self.fish.hidden = YES;
        fishFirstColl = YES;
        
        //第一个水滴
        if (dropView == nil) {
            dropView= [[UIView alloc]initWithFrame:CGRectZero];
            [self addSubview:dropView];
            dropView.layer.cornerRadius = dropView.frame.size.width / 2;
            dropView.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
        }
        dropView.center = CGPointMake(p.x - 40, p.y);
        dropView.bounds = CGRectMake(0, 0, 5, 5);
        
        UIBezierPath *dropPath = [UIBezierPath bezierPath];
        [dropPath moveToPoint:p];
        [dropPath addQuadCurveToPoint:dropView.center controlPoint:CGPointMake((p.x - dropView.center.x) / 2 + dropView.center.x, p.y - 30)];
        
//        CAShapeLayer *dropTrackLayer = [CAShapeLayer layer];
//        dropTrackLayer.path = dropPath.CGPath;
//        dropTrackLayer.strokeColor = [UIColor blueColor].CGColor;
//        dropTrackLayer.fillColor   = [UIColor clearColor].CGColor;
//        dropTrackLayer.lineWidth = 2.0f;
//        [self.layer addSublayer:dropTrackLayer];
        
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
            dropView2.layer.cornerRadius = dropView2.frame.size.width / 2;
            dropView2.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:dropView2];
        }
        dropView2.center = CGPointMake(p.x - 50, p.y);
        dropView2.bounds = CGRectMake(0, 0, 5, 5);
        
        UIBezierPath *dropPath2 = [UIBezierPath bezierPath];
        [dropPath2 moveToPoint:p];
        [dropPath2 addQuadCurveToPoint:dropView2.center controlPoint:CGPointMake((p.x - dropView2.center.x) / 2 + dropView2.center.x, p.y - 20)];
        
//        CAShapeLayer *dropTrackLayer2 = [CAShapeLayer layer];
//        dropTrackLayer2.path = dropPath2.CGPath;
//        dropTrackLayer2.strokeColor = [UIColor blueColor].CGColor;
//        dropTrackLayer2.fillColor   = [UIColor clearColor].CGColor;
//        dropTrackLayer2.lineWidth = 2.0f;
//        [self.layer addSublayer:dropTrackLayer2];
        
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
            dropView3.layer.cornerRadius = dropView3.frame.size.width / 2;
            dropView3.backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:dropView3];
        }
        dropView3.center = CGPointMake(p.x + 50, p.y);
        dropView3.bounds = CGRectMake(0, 0, 5, 5);
        
        UIBezierPath *dropPath3 = [UIBezierPath bezierPath];
        [dropPath3 moveToPoint:p];
        [dropPath3 addQuadCurveToPoint:dropView3.center controlPoint:CGPointMake((dropView3.center.x - p.x) / 2 + p.x, p.y - 20)];
        
//        CAShapeLayer *dropTrackLayer3 = [CAShapeLayer layer];
//        dropTrackLayer3.path = dropPath3.CGPath;
//        dropTrackLayer3.strokeColor = [UIColor blueColor].CGColor;
//        dropTrackLayer3.fillColor   = [UIColor clearColor].CGColor;
//        dropTrackLayer3.lineWidth = 2.0f;
//        [self.layer addSublayer:dropTrackLayer3];
        
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
