//
//  RotateButton.m
//  RotateButton
//
//  Created by Warif Akhand Rishi on 7/5/14.
//  Copyright (c) 2014 Warif Akhand Rishi. All rights reserved.
//

#import "RotateButton.h"

@implementation RotateButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addOrientationNotification];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addOrientationNotification];
    }
    return self;
}

- (void)addOrientationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didRotate:(NSNotification *)notification
{
	UIDevice	*device = [notification object];
    CGFloat angleToRotate = 0.0;
    
    switch (device.orientation )
    {
        case UIInterfaceOrientationPortrait:
			angleToRotate = 0.0;
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			angleToRotate = 180.0;
			break;
        case UIInterfaceOrientationLandscapeLeft:
			angleToRotate = -90.0;
			break;
        case UIInterfaceOrientationLandscapeRight:
			angleToRotate = 90.0;
			break;
		default:
			break;
    }
	
	[self doRotateSnapButton:angleToRotate];
}

-(void)doRotateSnapButton:(float)angle
{
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
    [UIView animateWithDuration:0.2f animations:^{
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, rotation);
    }];
}

@end
