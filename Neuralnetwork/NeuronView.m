//
//  NeuronView.m
//  Neuralnetwork
//
//  Created by EndoTsuyoshi on 2014/07/08.
//  Copyright (c) 2014年 endo.neural. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NeuronView.h"

const float learnIntervalSec = 0.1f;
@implementation NeuronView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSLog(@"frame = %@", NSStringFromCGRect(frame));
        
        self.alpha = 0.5;
        self.layer.cornerRadius = frame.size.width/2;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setOutputValue:(double)neuronValue {
    
    double inputValue = MIN(neuronValue, 1);
    
//    if(arc4random() % 2 == 0){
//        NSLog(@"inputValue = %f", inputValue);
//    }
    [UIView
     animateWithDuration:learnIntervalSec
     animations:^{
         self.backgroundColor =
         [UIColor colorWithRed:inputValue green:0 blue:1.f-inputValue alpha:0.5f];
     }];

}

//-(void) drawRect: (CGRect) rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
//    
//    CGContextSetFillColorWithColor(context, redColor.CGColor);
//    CGContextFillRect(context, self.bounds);
//}

@end
