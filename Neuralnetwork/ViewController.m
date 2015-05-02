//
//  ViewController.m
//  Neuralnetwork
//
//  Created by 遠藤 豪 on 2014/02/17.
//  Copyright (c) 2014年 endo.neural. All rights reserved.
//

#import "ViewController.h"
#import "NeuralnetworkClass.h"


#import "NeuronView.h"

/*
 2015-02-20 17:21:05.312 Neuralnetwork[14133:652809] 2628回目誤差 = (
 "-0.002181878594851971",
 "0.03630845045809783",
 "0.0001966360205311046"
 ),
 教師信号 = (
 "0.5",
 1,
 "0.300000011920929"
 )
 2015-02-20 17:21:05.412 Neuralnetwork[14133:652809] 2629回目誤差 = (
 "0.02817811970051287",
 "-0.004484038121101874",
 "-0.0001540178438400597"
 ),
 教師信号 = (
 1,
 "0.800000011920929",
 "0.300000011920929"
 )

 */

@interface ViewController ()

@end

@implementation ViewController{
//    NeuronView *neuron;
    
//    NSMutableArray *arrNeuron;
    NeuralnetworkClass *nn;
    NSMutableArray *arrMySupervisor;
    NSMutableArray *arrMyInput;
    
    NSTimer *tm;
    int learnCount;
    
    //全てのエラー値を格納する配列を取得する
    NSMutableArray *arrAllError;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    arrAllError = [NSMutableArray array];
    learnCount = 0;
    
//    neuron =
//    [[NeuronView alloc]//init];
//     initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self.view addSubview:neuron];
//    
//    neuron.center = CGPointMake(self.view.bounds.size.width/2,
//                                self.view.bounds.size.height/2);
    
//    arrNeuron = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    int numOfInput = 3;
    int numOfHidden = 4;
    int numOfOutput = 3;
    
    NSLog(@"frame = %@", NSStringFromCGRect(self.view.frame));
    
    nn =
    [[NeuralnetworkClass alloc]
     initWithInput:numOfInput
     withHidden:numOfHidden
     withOutput:numOfOutput];
    
//    //各層のニューロンを格納
//    arrNeuron =
//    [NSMutableArray arrayWithObjects:
//     [NSNumber numberWithInteger:numOfInput],
//     [NSNumber numberWithInteger:numOfHidden],
//     [NSNumber numberWithInteger:numOfOutput],
//     nil];
    
    
    //ニューロンの描画
    for(int i = 0;i < nn.arrNeuronInput.count;i++){
        [self.view addSubview:nn.arrNeuronInput[i]];
    }
    for(int h = 0;h < nn.arrNeuronHidden.count;h++){
        [self.view addSubview:nn.arrNeuronHidden[h]];
    }
    for(int o = 0;o < nn.arrNeuronOutput.count;o++){
        [self.view addSubview:nn.arrNeuronOutput[o]];
    }
    
    
    //2patter of input:
    arrMyInput =
    [NSMutableArray arrayWithObjects:
     
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithDouble:1.0f],
      [NSNumber numberWithDouble:0.0f],
      [NSNumber numberWithDouble:1.0f],
//      [NSNumber numberWithDouble:0.0f],
      nil],
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithDouble:1.0f],
      [NSNumber numberWithDouble:1.0f],
      [NSNumber numberWithDouble:0.0f],
//      [NSNumber numberWithDouble:1.0f],
      nil],
     nil];
    
    
    //教師信号
    arrMySupervisor =
    [NSMutableArray arrayWithObjects:
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithDouble:0.5f],
      [NSNumber numberWithDouble:1.0f],
      [NSNumber numberWithDouble:0.3f],
      nil],
     [NSMutableArray arrayWithObjects:
      [NSNumber numberWithDouble:1.0f],
      [NSNumber numberWithDouble:0.8f],
      [NSNumber numberWithDouble:0.3f],
      nil],
     nil];
    
//    nn.arrSupervisor =
//    [NSMutableArray arrayWithObjects:
//     [NSNumber numberWithDouble:0.5f],
//     [NSNumber numberWithDouble:1.0f],
//     [NSNumber numberWithDouble:0.3f],
//     nil];
    
    
    
//    [neuron setInputValue:(double)0.5f];
    int widthBtn = 100;
    UIButton *button =
    [[UIButton alloc]initWithFrame:CGRectMake(10, 30, widthBtn, 50)];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:0.8f]];
    [button setTitle:@"learn" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(startLearning)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *btnPresentView =
    [[UIButton alloc]initWithFrame:CGRectMake(0, 0, widthBtn, 50)];
    btnPresentView.center =
    CGPointMake(button.center.x + button.bounds.size.width/2 + btnPresentView.bounds.size.width/2,
                button.center.y);
    [btnPresentView setBackgroundColor:[UIColor colorWithRed:.8f green:0 blue:.8f alpha:.8f]];
    [btnPresentView setTitle:@"pingPong" forState:UIControlStateNormal];
    [btnPresentView addTarget:self
                       action:@selector(presentPingPong:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPresentView];
    
    
}

-(void)presentPingPong:(id)sender{
    NSLog(@"%s", __func__);
    
    PingPongViewController *vc = [[PingPongViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"transfered");
    }];
    
}

-(void)learningUnit{
    
    learnCount++;
    
    //フォワード計算
//    BOOL isCompleteFF =
    [nn forwardWithInput:arrMyInput[learnCount%2]];
//         [NSMutableArray arrayWithObjects:
//          [NSNumber numberWithDouble:1.5f],
//          [NSNumber numberWithDouble:1.0f],
//          [NSNumber numberWithDouble:0.5f],
//          [NSNumber numberWithDouble:1.0f],
//          nil]];
    nn.arrSupervisor = arrMySupervisor[learnCount%2];
    
    
    //バックプロパゲーション
//    BOOL isCompleteBP =
    [nn backPropagation];
    
//        NSLog(@"ff=%@, bp=%@",
//              isCompleteFF?@"成功":@"失敗",
//              isCompleteBP?@"成功":@"失敗");
    
    //エラー格納
    [arrAllError addObject:nn.arrError];
    
    //errorを出力する
    NSLog(@"%d回目誤差 = %@, \n教師信号 = %@",learnCount , [arrAllError lastObject], arrMySupervisor[learnCount%2]);
    
    //errorを描画する
    [self drawError:(int)learnCount value:[arrAllError lastObject]];
    
}

-(void)drawError:(int)domain value:(NSArray *)value{
    int init_x = 10;
    int init_y = self.view.bounds.size.height-30;
    //出力ニューロンの各誤差値の自乗和を計算する
    float sumOfError = 0;
    for(int i = 0;i < value.count;i++){
        sumOfError += powf([value[i] doubleValue], 2);
    }
    
        
        
        
        
    UIView *plotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 2)];
    plotView.center = CGPointMake(domain + init_x,
                                  init_y - sumOfError * 1000);
    plotView.backgroundColor = [UIColor colorWithRed:sumOfError*100 green:0 blue:1-sumOfError*100 alpha:0.5f];
//                                  init_y - [value[i] doubleValue]*100);
//    if(i % 3 == 0){
//        plotView.backgroundColor = [UIColor blueColor];
//    }else if(i % 2 == 0){
//        plotView.backgroundColor = [UIColor greenColor];
//    }else if(i % 1 == 0){
//        plotView.backgroundColor = [UIColor redColor];
//    }else{
//        plotView.backgroundColor = [UIColor blackColor];
//    }
    [self.view addSubview:plotView];
    
    
//    NSLog(@"plot %d: %f",i,  init_y - [value[i] doubleValue]*100);
    
}

//ボタン押下時
-(void)startLearning{
    
    //
    if(learnCount == 0){
        tm =
        [NSTimer
         scheduledTimerWithTimeInterval:learnIntervalSec
         target:self
         selector:@selector(learningUnit)
         userInfo:nil
         repeats:YES];
    }
    
    
    return;
    
    for(int t = 0;t < 10000;t++){
        
        //フォワード計算
        BOOL isCompleteFF =
        [nn forwardWithInput:arrMyInput[t%2]];
//         [NSMutableArray arrayWithObjects:
//          [NSNumber numberWithDouble:1.5f],
//          [NSNumber numberWithDouble:1.0f],
//          [NSNumber numberWithDouble:0.5f],
//          [NSNumber numberWithDouble:1.0f],
//          nil]];
        nn.arrSupervisor = arrMySupervisor[t%2];
        
        
        //バックプロパゲーション
        BOOL isCompleteBP = [nn backPropagation];
        
//        NSLog(@"ff=%@, bp=%@",
//              isCompleteFF?@"成功":@"失敗",
//              isCompleteBP?@"成功":@"失敗");
        
        
        //エラー格納
        [arrAllError addObject:nn.arrError];
        
        
        //バグ対応
        if(!(isCompleteFF && isCompleteBP)){
            NSLog(@"error occurring!! at %@",
                  isCompleteFF?@"BP":@"FF");
            break;
        }
    }
    
    NSLog(@"learning complete");
    
    NSMutableArray *_arrOutput1 = nn.arrOutput;
    for(int k = 0;k < [_arrOutput1 count];k++){
        NSLog(@"output%d is %f", k, [_arrOutput1[k] doubleValue]);
    }
    
    
    //test
    [nn forwardWithInput:arrMyInput[0]];
    for(int k = 0;k < [nn.arrOutput count];k++){
        NSLog(@"pattern0:output%d is %f against:%f",
              k, [nn.arrOutput[k] doubleValue],
              [arrMySupervisor[0][k] doubleValue]);
    }
    
    
    [nn forwardWithInput:arrMyInput[1]];
    for(int k = 0;k < [nn.arrOutput count];k++){
        NSLog(@"pattern1:output%d is %f against:%f",
              k, [nn.arrOutput[k] doubleValue],
              [arrMySupervisor[1][k] doubleValue]);
    }
    
    
    for(int t = 0;t < arrAllError.count;t++){
        NSLog(@"error %d = %@", t, arrAllError[t]);
    }
}



@end
