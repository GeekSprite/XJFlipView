//
//  XJFlipView.m
//  XJFlipViewDemo
//
//  Created by liuxj on 2018/11/20.
//  Copyright © 2018 lxj. All rights reserved.
//

#import "XJFlipView.h"

static NSString *const kFrontUpperAnimation = @"kFrontUpperAnimation";
static NSString *const kBackUpperAnimation  = @"kBackUpperAnimation";
static NSString *const kBackBottomAnimation = @"kBackBottomAnimation";

static CGFloat         kAnimationDuration   = 1.1;

@interface XJFlipView() <CAAnimationDelegate>

{
    NSInteger _index;
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) CALayer *frontUpperLayer;
@property (nonatomic, strong) CALayer *frontBottomLayer;
@property (nonatomic, strong) CALayer *backUpperLayer;
@property (nonatomic, strong) CALayer *backBottomLayer;

@end

@implementation XJFlipView

- (instancetype)initWithImages:(NSArray *)images {
    if (self = [super initWithFrame:CGRectZero]) {
        _index = 0;
        _images = images;
        _isAnimating = NO;
        
        self.backUpperLayer = [[CALayer alloc] init];
        self.backUpperLayer.anchorPoint = CGPointMake(0.5, 1.0);
        self.backUpperLayer.contentsRect = CGRectMake(0, 0.0, 1.0, 0.5);
        self.backUpperLayer.masksToBounds = YES;
        self.backUpperLayer.zPosition = 1;
        [self.layer addSublayer:self.backUpperLayer];
        
        self.backBottomLayer = [[CALayer alloc] init];
        self.backBottomLayer.anchorPoint = CGPointMake(0.5, 0.0);
        self.backBottomLayer.contentsRect = CGRectMake(0, 0.5, 1.0, 0.5);
        self.backBottomLayer.masksToBounds = YES;
        self.backBottomLayer.zPosition = 2;
        [self.layer addSublayer:self.backBottomLayer];
        
        self.frontBottomLayer = [[CALayer alloc] init];
        self.frontBottomLayer.anchorPoint = CGPointMake(0.5, 0.0);
        self.frontBottomLayer.contentsRect = CGRectMake(0, 0.5, 1.0, 0.5);
        self.frontBottomLayer.masksToBounds = YES;
        self.frontBottomLayer.zPosition = 3;
        [self.layer addSublayer:self.frontBottomLayer];
        
        self.frontUpperLayer = [[CALayer alloc] init];
        self.frontUpperLayer.anchorPoint = CGPointMake(0.5, 1.0);
        self.frontUpperLayer.contentsRect = CGRectMake(0, 0, 1.0, 0.5);
        self.frontUpperLayer.masksToBounds = YES;
        self.frontUpperLayer.zPosition = 4;
        [self.layer addSublayer:self.frontUpperLayer];
        
        CATransform3D initializedState = CATransform3DIdentity;
        initializedState.m34 = -1.0 / 500;
        
        self.frontUpperLayer.transform = initializedState;
        
        self.backUpperLayer.transform = CATransform3DRotate(initializedState, M_PI_2, 1.0, 0.0, 0.0);
        
        self.backBottomLayer.transform = CATransform3DRotate(initializedState, M_PI_2, 1.0, 0.0, 0.0);
        
        [self changeImageWithIndex:_index];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reLayoutSubViews];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimation];
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self clean];
}

- (void)changeImageWithIndex:(NSInteger)index {
    UIImage *img = self.images[index];
    NSInteger nextIndex = (index + 1) == self.images.count ? 0 : index + 1;
    UIImage *nextImg = self.images[nextIndex];
    self.frontUpperLayer.contents = (id)img.CGImage;
    self.frontBottomLayer.contents = (id)img.CGImage;
    self.backUpperLayer.contents = (id)nextImg.CGImage;
    self.backBottomLayer.contents = (id)nextImg.CGImage;
}

- (void)reLayoutSubViews {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect halfFrame = CGRectMake(0, 0, width, height /2.0);
    CGPoint center = CGPointMake(width / 2.0, height / 2.0);
    self.backUpperLayer.bounds = halfFrame;
    self.backUpperLayer.position = center;
    
    self.backBottomLayer.bounds = halfFrame;
    self.backBottomLayer.position = center;
    
    self.frontBottomLayer.bounds = halfFrame;
    self.frontBottomLayer.position = center;
    
    self.frontUpperLayer.bounds = halfFrame;
    self.frontUpperLayer.position = center;
    
}

- (void)startAnimation {
    if (!self.isAnimating) {
        self.isAnimating = YES;
        [self performAnimation];
    }
}

- (void)stopAnimation {
    if (self.isAnimating) {
        self.isAnimating = NO;
    }
}

- (void)performAnimation {
    
    CATransform3D frontUpperBegin = self.frontUpperLayer.transform;
    CATransform3D frontUpperMiddle = CATransform3DRotate(self.frontUpperLayer.transform, -M_PI_2/2.0, 1.0, 0, 0);
    CATransform3D frontUpperEnd = CATransform3DRotate(self.frontUpperLayer.transform, -M_PI_2, 1.0, 0, 0);
    
    //控制翻转方向
    CATransform3D backUpperBegin = self.backUpperLayer.transform;
    CATransform3D backUpperMiddle = CATransform3DRotate(self.backUpperLayer.transform, -M_PI_2/2.0, 1.0, 0, 0);
    CATransform3D backUpperEnd = CATransform3DRotate(self.backUpperLayer.transform, -M_PI_2, 1.0, 0, 0);
    
    CATransform3D backBottomBegin = self.backBottomLayer.transform;
    CATransform3D backBottomMiddle = CATransform3DRotate(self.backBottomLayer.transform, -M_PI_2/2.0, 1.0, 0, 0);
    CATransform3D backBottomEnd = CATransform3DRotate(self.backBottomLayer.transform, -M_PI_2, 1.0, 0, 0);
    
    CAKeyframeAnimation *frontUpperAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    frontUpperAnimation.values = @[[NSValue valueWithCATransform3D:frontUpperBegin],
                                   [NSValue valueWithCATransform3D:frontUpperMiddle],
                                   [NSValue valueWithCATransform3D:frontUpperEnd]];
    frontUpperAnimation.keyTimes = @[@(0.0),@(0.25),@(0.5)];
    [frontUpperAnimation setDuration:kAnimationDuration];
    frontUpperAnimation.removedOnCompletion = NO;
    frontUpperAnimation.fillMode = kCAFillModeForwards;
    [frontUpperAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    frontUpperAnimation.delegate = self;
    
    CAKeyframeAnimation *backUpperAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    backUpperAnimation.values = @[[NSValue valueWithCATransform3D:backUpperBegin],
                                  [NSValue valueWithCATransform3D:backUpperMiddle],
                                  [NSValue valueWithCATransform3D:backUpperEnd]];
    backUpperAnimation.keyTimes = @[@(0.0),@(0.5),@(1.0)];
    [backUpperAnimation setDuration:kAnimationDuration];
    backUpperAnimation.removedOnCompletion = NO;
    backUpperAnimation.fillMode = kCAFillModeForwards;
    [backUpperAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    CAKeyframeAnimation *backBottomAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    backBottomAnimation.values = @[[NSValue valueWithCATransform3D:backBottomBegin],
                                   [NSValue valueWithCATransform3D:backBottomMiddle],
                                   [NSValue valueWithCATransform3D:backBottomEnd]];
    backBottomAnimation.keyTimes = @[@(0.5),@(0.75),@(1.0)];
    [backBottomAnimation setDuration:kAnimationDuration];
    backBottomAnimation.removedOnCompletion = NO;
    backBottomAnimation.fillMode = kCAFillModeForwards;
    [backBottomAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.frontUpperLayer addAnimation:frontUpperAnimation forKey:kFrontUpperAnimation];
    [self.backUpperLayer addAnimation:backUpperAnimation forKey:kBackUpperAnimation];
    [self.backBottomLayer addAnimation:backBottomAnimation forKey:kBackBottomAnimation];
}

- (void)animationDidStart:(CAAnimation *)anim {
    CGFloat temZ = self.frontBottomLayer.zPosition;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.frontBottomLayer.zPosition = self.backBottomLayer.zPosition;
    self.backBottomLayer.zPosition = temZ;
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    _index ++;
    _index = _index == self.images.count ? 0 : _index;
    
    CGFloat temZ = self.frontBottomLayer.zPosition;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        if (self.isAnimating) {
            [self performAnimation];
        }
    }];
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    self.frontBottomLayer.zPosition = self.backBottomLayer.zPosition;
    self.backBottomLayer.zPosition = temZ;
    [self changeImageWithIndex:_index];
    [CATransaction commit];
}

- (void)clean {
    [self stopAnimation];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
}

@end

