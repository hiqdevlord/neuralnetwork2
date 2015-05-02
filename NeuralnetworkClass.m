//
//  NeuralnetworkClass.m
//  Neuralnetwork
//
//  Created by 遠藤 豪 on 2014/02/17.
//  Copyright (c) 2014年 endo.neural. All rights reserved.
//

#import "NeuralnetworkClass.h"
#import "NeuronView.h"

//#define FLAG_LOG

#define REINFORCEMENT_LEARNING

#define ETA 0.5
#define WidthFrame 320
#define HeightFrame 480


@implementation NeuralnetworkClass

//NSMutableArray *arrInput, *arrHidden, *arrOutput;
//NSMutableArray *arrWeightIH, *arrWeightHO;
@synthesize arrInput;
@synthesize arrHidden;
@synthesize arrOutput;
@synthesize arrStatusOfHidden;//内部状態：前の層からの結合加重を通って渡される値そのもの
@synthesize arrStatusOfOutput;
@synthesize arrWeightIH;
@synthesize arrWeightHO;
@synthesize arrDeltaWeightIH;
@synthesize arrDeltaWeightHO;
@synthesize arrSupervisor;

@synthesize arrError;//教師信号に対する誤差
@synthesize arrHiddenDelta;//中間層ニューロンデルタ
@synthesize arrOutputDelta;//出力層ニューロンデルタ


//neuronView;
@synthesize arrNeuronInput;
@synthesize arrNeuronHidden;
@synthesize arrNeuronOutput;

const int diameter_neuron = 40;
const int y_input = 300;
const int y_hidden = 200;
const int y_output = 100;
int interval_input;
int interval_hidden;
int interval_output;

-(id)initWithInput:(int)_numOfInput
        withHidden:(int)_numOfHidden
        withOutput:(int)_numOfOutput{
    
    self = [super init];
    
    interval_input = (WidthFrame - diameter_neuron * _numOfInput) / (_numOfInput + 1);
    interval_hidden = (WidthFrame - diameter_neuron * _numOfHidden) / (_numOfHidden + 1);
    interval_output = (WidthFrame - diameter_neuron * _numOfOutput) / (_numOfOutput + 1);
    
    NSLog(@"interval : input=%d, hidden=%d, output=%d",
          interval_input, interval_hidden, interval_output);
    
    if(self){
        
        //入力層初期化
        self.arrInput = [NSMutableArray array];
        self.arrNeuronInput = [NSMutableArray array];
        for(int i = 0;i < _numOfInput;i++){
            [self.arrInput addObject:[NSNumber numberWithDouble:0]];
            
            [self.arrNeuronInput addObject:
             [[NeuronView alloc]
              initWithFrame:
              CGRectMake(i*(interval_input + diameter_neuron) + interval_input,
                         y_input,
                         diameter_neuron, diameter_neuron)]];
        }
        
        
        //中間層初期化
        self.arrHidden = [NSMutableArray array];
        self.arrHiddenDelta = [NSMutableArray array];
        self.arrNeuronHidden = [NSMutableArray array];
        for(int h = 0;h < _numOfHidden;h++){
            [self.arrHidden addObject:[NSNumber numberWithDouble:0]];
            [self.arrStatusOfHidden addObject:[NSNumber numberWithDouble:0]];
            
            [self.arrHiddenDelta addObject:[NSNumber numberWithDouble:0]];
            
            [self.arrNeuronHidden addObject:
             [[NeuronView alloc]
              initWithFrame:
              CGRectMake(h*(interval_hidden + diameter_neuron) + interval_hidden,
                         y_hidden, diameter_neuron, diameter_neuron)]];
             
        }
        
        //出力層初期化
        self.arrOutput = [NSMutableArray array];
        self.arrNeuronOutput = [NSMutableArray array];
        for(int k = 0;k < _numOfOutput;k++){
            [self.arrOutput addObject:[NSNumber numberWithDouble:0]];
            [self.arrStatusOfOutput addObject:[NSNumber numberWithDouble:0]];
            
            [self.arrNeuronOutput addObject:
             [[NeuronView alloc]
              initWithFrame:
              CGRectMake(k*(interval_output + diameter_neuron) + interval_output,
                         y_output, diameter_neuron, diameter_neuron)]];
        }
        
        //結合加重：入力層(縦方向)ー中間層(横方向)
        arrWeightIH = [NSMutableArray array];
        NSMutableArray *arrWeightTmp = nil;
        for(int i = 0;i < _numOfInput;i++){
            arrWeightTmp = [NSMutableArray array];
            for(int h = 0;h < _numOfHidden;h++){
                [arrWeightTmp addObject:[NSNumber numberWithDouble:0]];
//                NSLog(@"weight=%f", [[arrWeightTmp lastObject] doubleValue]);
            }
            [arrWeightIH addObject:arrWeightTmp];
        }
        
        //結合加重：中間層(縦方向)ー出力層(横方向)
        arrWeightHO = [NSMutableArray array];
        for(int h =0;h < _numOfHidden;h++){
            arrWeightTmp = [NSMutableArray array];
            for(int k = 0;k < _numOfOutput;k++){
                [arrWeightTmp addObject:[NSNumber numberWithDouble:0]];
//                NSLog(@"weight=%f", [[arrWeightTmp lastObject] doubleValue]);
            }
            [arrWeightHO addObject:arrWeightTmp];
        }
    }
    
    
    //test:確認
    for(int i = 0;i < _numOfOutput;i++){
        for(int j = 0;j < _numOfHidden;j++){
            arrWeightIH[i][j] = [NSNumber numberWithDouble:(float)(arc4random() % 100)/100.0f];
            NSLog(@"arrWeightIH[%d][%d]=%f",
                  i,j,[arrWeightIH[i][j] doubleValue]);
        }
    }
    
    for(int j = 0;j < _numOfHidden;j++){
        for(int k = 0;k < _numOfOutput;k++){
            arrWeightHO[j][k] = [NSNumber numberWithDouble:(float)(arc4random() % 100)/100.0f];
            NSLog(@"arrWeightHO[%d][%d]=%f",
                  j,k,[arrWeightHO[j][k] doubleValue]);
        }
    }
    
    NSLog(@"complete initializing");
    
    return self;
}

-(BOOL)forwardWithInput:(NSMutableArray *)_arrInputValue{
    if([self.arrInput count] != [_arrInputValue count]){
//        NSLog(@"inputNeuron : number of neuron error");
        return false;
    }
    
    
#ifdef FLAG_LOG
    NSLog(@"入力層の指定");
#endif
    //入力値の指定
    for(int i = 0;i < [_arrInputValue count];i++){
        self.arrInput[i] =
        [NSNumber numberWithDouble:
         [_arrInputValue[i] doubleValue]];
        
        //可視状態
        [(NeuronView *)(self.arrNeuronInput[i])
         setOutputValue:[_arrInputValue[i] doubleValue]];
    }
    
#ifdef FLAG_LOG
    NSLog(@"中間層の指定");
#endif
    //中間層の計算
    self.arrStatusOfHidden = [NSMutableArray array];
    double _statusOfNeuron = 0;
    for(int j = 0;j < [self.arrHidden count];j++){
        //中間層の内部状態の計算
        _statusOfNeuron = 0;
        
#ifdef FLAG_LOG
        NSLog(@"接続ニューロンからの信号和%d,%d, %d", [self.arrInput count],
              [self.arrWeightIH count], [self.arrWeightIH[0] count]);
#endif
        for(int i = 0;i < [self.arrInput count];i++){
            _statusOfNeuron +=
            [self.arrInput[i] doubleValue] *
            [self.arrWeightIH[i][j] doubleValue];
        }
        
#ifdef FLAG_LOG
        NSLog(@"内部状態格納");
#endif
        //念のため格納
        [self.arrStatusOfHidden addObject:
         [NSNumber numberWithDouble:_statusOfNeuron]];
        
        
#ifdef FLAG_LOG
        NSLog(@"出力値の計算");
#endif
        //中間層出力値の計算
        arrHidden[j] =
        [NSNumber numberWithDouble:
         [self getSigmoidHidden:_statusOfNeuron]];
        
//        NSLog(@"output of hidden %d is %f",
//              j, [self getSigmoidHidden:_statusOfNeuron]);
        
        //可視状態
        [(NeuronView *)(self.arrNeuronHidden[j])
         setOutputValue:[arrHidden[j] doubleValue]];
    }
    
    
#ifdef FLAG_LOG
    NSLog(@"出力層の指定");
#endif
    //出力層の指定
    self.arrStatusOfOutput = [NSMutableArray array];
    for(int k = 0;k < [self.arrOutput count];k++){
        //出力層の内部状態の計算
        _statusOfNeuron = 0;
        for(int j = 0;j < [self.arrHidden count];j++){
            _statusOfNeuron +=
            [self.arrHidden[j] doubleValue] *
            [self.arrWeightHO[j][k] doubleValue];
        }
        
        //念のため格納(出力層内部状態)
        [self.arrStatusOfOutput addObject:
         [NSNumber numberWithDouble:_statusOfNeuron]];
        
        //出力層出力値の計算
        arrOutput[k] =
        [NSNumber numberWithDouble:
         [self getSigmoidOutput:_statusOfNeuron]];
        
        //可視状態
        [(NeuronView *)(self.arrNeuronOutput[k])
         setOutputValue:[arrOutput[k] doubleValue]];
        
        
        //test:出力値
#ifdef FLAG_LOG
        NSLog(@"output%d is %f", k, [arrOutput[k] doubleValue]);
#endif
        
    }
#ifdef FLAG_LOG
    NSLog(@"complete forward");
#endif
    return true;
}


-(BOOL)backPropagation{
//    NSLog(@"start backpropagate");
    if([self.arrSupervisor count] != [self.arrOutput count]){
        NSLog(@"arrSupervisor count=%d, arrOutput count=%d",
              (int)[self.arrSupervisor count], (int)[self.arrOutput count]);
        return false;
    }
    
    double _error = 0;
    double _supervisor = 0;
    double _output = 0;
    self.arrError = [NSMutableArray array];
    self.arrOutputDelta = [NSMutableArray array];
    for(int o = 0;o < [self.arrOutput count];o++){
        _supervisor = [self.arrSupervisor[o] doubleValue];
        _output = [self.arrOutput[o] doubleValue];
        _error = _supervisor - _output;
        //http://www.fer.unizg.hr/_download/repository/BP_chapter3_-_bp.pdf
//        _error =
//        [self.arrOutput[o] doubleValue] * (1- [self.arrOutput[o] doubleValue]) *
//        ([self.arrOutput[o] doubleValue]  -
//         [self.arrSupervisor[o] doubleValue]);
        
        [arrError addObject:[NSNumber numberWithDouble:_error]];
#ifdef FLAG_LOG
        NSLog(@"error %d = %f", o, [[arrError lastObject] doubleValue]);
#endif
        
        
#ifdef REINFORCEMENT_LEARNING
        //強化学習の場合
        BOOL isFavor = (_supervisor > _output)?1:0;//reward or punishment
        float learningRate = .1f;
        
        //焼きなまし法：
        learningRate = fabsf((float)_supervisor - (float)_output);
        
        //個別パラメータについては調整済
        //10回に一度探索ノイズを与える:本当は学習状況におうじて小さくしないと発散してしまう
        if(arc4random() % 10 == 0){
            learningRate += ((float)(arc4random() % 100)) / 1000.f;
        }
        [arrOutputDelta addObject:
         [NSNumber numberWithDouble:
          _output * (1 - _output) * isFavor*learningRate]];
        
#else
        //教師信号による学習（教師あり学習）
        [arrOutputDelta addObject:
         [NSNumber numberWithDouble:
          _output * (1 - _output) * (_supervisor - _output)]];
#endif
#ifdef FLAG_LOG
        NSLog(@"delta_output%d is %f", o, _output * (1 - _output) * (_supervisor - _output));
#endif
    }
    
    
    //中間層j-出力層k間の結合加重の修正量
    //deltaWkj = eta * delta_k * Hj(j番目中間層出力値)
    //ただし、delta_k=(supervisor_k - output_k) * output_k * (1 - output_k)
    self.arrDeltaWeightHO = [NSMutableArray array];
    NSMutableArray *arrDeltaWeightHOTmp = nil;
    
    for(int j = 0;j < [arrHidden count];j++){
        arrDeltaWeightHOTmp = [NSMutableArray array];
        for(int k = 0;k < [arrOutput count];k++){
            [arrDeltaWeightHOTmp addObject:
            [NSNumber numberWithDouble:
             ETA * [arrOutputDelta[k] doubleValue] * [arrHidden[j] doubleValue]
             ]];
        }
        [arrDeltaWeightHO addObject:arrDeltaWeightHOTmp];
    }
    
//    NSLog(@"complete arrDeletaWeightHO");
    
    //入力層i-中間層j間の結合加重の修正量
    //deltaWji = eta * Hj * (1 - Hj) * Σ(wkj * delta_k)
    //delta_k=(supervisor_k - output_k) * output_k * (1 - output_k)
    self.arrDeltaWeightIH = [NSMutableArray array];
    self.arrHiddenDelta = [NSMutableArray array];
    NSMutableArray *arrDeltaWeightIHTmp = nil;
    for(int j = 0;j < [arrHidden count];j++){
        
        double h_j = [arrHidden[j] doubleValue];
        
        double summation_j = 0;
        for(int k = 0;k < [arrOutput count];k++){
            summation_j += ([arrWeightHO[j][k] doubleValue] *
                          [arrOutputDelta[k] doubleValue]);
        }
        
        [arrHiddenDelta addObject:
         [NSNumber numberWithDouble:
          h_j * (1 - h_j) * summation_j]];
        
        
    }
    for(int i = 0;i < [arrInput count];i++){
        arrDeltaWeightIHTmp = [NSMutableArray array];
        for(int j =0;j < [arrHidden count];j++){
            [arrDeltaWeightIHTmp addObject:
             [NSNumber numberWithDouble:
              ETA * [arrHiddenDelta[j] doubleValue] * [arrInput[i] doubleValue]
              ]];
        }
        [arrDeltaWeightIH addObject:arrDeltaWeightIHTmp];
    }
    
//    NSLog(@"complete arrDeltaWeightIH");
    
    
    //arrDeltaWeightIHとHOを使って更新する
    double _weight = 0;
    for(int i = 0;i < [arrInput count];i++){
        for(int j = 0;j < [arrHidden count];j++){
            _weight = [arrWeightIH[i][j] doubleValue];
            _weight += [arrDeltaWeightIH[i][j] doubleValue];
            arrWeightIH[i][j] = [NSNumber numberWithDouble:_weight];
        }
    }
    
    for(int j = 0;j < [arrHidden count];j++){
        for(int k = 0;k < [arrOutput count];k++){
            
            _weight = [arrWeightHO[j][k] doubleValue];
//            NSLog(@"更新前:arrWeightHO[%d][%d] is %f",
//                  j,k,_weight);
            _weight += [arrDeltaWeightHO[j][k] doubleValue];
//            NSLog(@"更新前:arrWeightHO[%d][%d] is %f",
//                  j,k,[arrWeightHO[j][k] doubleValue]);
            arrWeightHO[j][k] = [NSNumber numberWithDouble:_weight];
//            NSLog(@"更新後:arrWeightHO[%d][%d] is %f",
//                  j,k,[arrWeightHO[j][k] doubleValue]);
        }
    }
    
    
    return true;
}



-(double)getSigmoidHidden:(double)_status{
    double parameter = 1.0f;
    double denominator = 1.0f + exp(-parameter * _status + 0.5f);
    return 1.0f/denominator;
}

-(double)getSigmoidOutput:(double)_status{
    double parameter = 1.0f;
    double denominator = 1.0f + exp(-parameter * _status + 0.5f);
    return 1.0f/denominator;
}


@end
