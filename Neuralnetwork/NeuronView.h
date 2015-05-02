//
//  NeuronView.h
//  Neuralnetwork
//
//  Created by EndoTsuyoshi on 2014/07/08.
//  Copyright (c) 2014年 endo.neural. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeuronView : UIView
extern float const learnIntervalSec;


-(void)setOutputValue:(double)neuronValue;
@end
