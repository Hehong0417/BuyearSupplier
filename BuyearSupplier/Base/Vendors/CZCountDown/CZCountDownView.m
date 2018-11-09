//
//  CZCountDownView.m
//  countDownDemo
//
//  Created by 孔凡列 on 15/12/9.
//  Copyright © 2015年 czebd. All rights reserved.
//

#import "CZCountDownView.h"
// label数量
//#define labelCount 3
//#define separateLabelCount 2
//#define padding 5

@interface CZCountDownView ()

@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;


@end

@implementation CZCountDownView
// 创建单例
+ (instancetype)shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CZCountDownView alloc] init];
    });
    return instance;
}

+ (instancetype)countDown{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
//      [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
    }
    return self;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
//    [self bringSubviewToFront:imageView];
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    
    [self getDetailTimeWithTimestamp:timestamp];
    
    _timestamp = timestamp;
    if (_timestamp != 0) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
}

-(void)timer:(NSTimer*)timerr{
    
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    
    if (_timestamp == 0) {
        [_timer invalidate];
        _timer = nil;
        [self getDetailTimeWithTimestamp:0];
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//    NSLog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    
//    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    
//    self.minuesLabel.text = [NSString stringWithFormat:@"%zd",minute];
//    self.secondsLabel.text = [NSString stringWithFormat:@"%zd",second];
    
    self.hourLabel.text = [NSString stringWithFormat:@"%@%zd",hour<10?@"0":@"",hour];
    self.minuesLabel.text = [NSString stringWithFormat:@"%@%zd",minute<10?@"0":@"",minute];
    self.secondsLabel.text = [NSString stringWithFormat:@"%@%zd",second<10?@"0":@"",second];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 获得view的宽、高
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    // 单个label的宽高
    CGFloat labelW = viewW / self.labelCount;
    CGFloat labelH = viewH;
//    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
    if (self.labelCount == 3) {
        self.hourLabel.hidden = NO;
        self.hourLabel.frame = CGRectMake(0, 0, labelW, labelH);
        self.hourLabel.textColor = self.timeColor;
        self.hourLabel.font = self.timeFont;

        self.minuesLabel.frame = CGRectMake(labelW , 0, labelW, labelH);
        self.minuesLabel.textColor = self.timeColor;
        self.minuesLabel.font = self.timeFont;
        
        self.secondsLabel.frame = CGRectMake(labelW*2, 0, labelW, labelH);
        self.secondsLabel.textColor = self.timeColor;
        self.secondsLabel.font = self.timeFont;
    }else{
        self.hourLabel.hidden = YES;
        self.minuesLabel.frame = CGRectMake(0 , 0, labelW, labelH);
        self.minuesLabel.textColor = self.timeColor;
        self.minuesLabel.font = self.timeFont;
        self.secondsLabel.frame = CGRectMake(labelW, 0, labelW, labelH);
        self.secondsLabel.textColor = self.timeColor;
        self.secondsLabel.font = self.timeFont;
    }
    
    for (NSInteger index = 0; index < self.separateLabelCount; index ++) {
        UILabel *separateLabel = [[UILabel alloc] init];
        separateLabel.text = @":";
        separateLabel.textAlignment = NSTextAlignmentCenter;
        separateLabel.textColor = self.timeColor;
        separateLabel.font = self.timeFont;
        separateLabel.frame = CGRectMake((labelW - 1) * (index + 1), 0, 5, labelH-5);
        [self addSubview:separateLabel];
    }

}
#pragma mark - setter & getter

- (NSMutableArray *)timeLabelArrM{
    if (_timeLabelArrM == nil) {
        _timeLabelArrM = [[NSMutableArray alloc] init];
    }
    return _timeLabelArrM;
}

- (NSMutableArray *)separateLabelArrM{
    if (_separateLabelArrM == nil) {
        _separateLabelArrM = [[NSMutableArray alloc] init];
    }
    return _separateLabelArrM;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
//        _dayLabel.backgroundColor = [UIColor grayColor];
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
//        _hourLabel.backgroundColor = [UIColor redColor];
    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
//        _minuesLabel.backgroundColor = [UIColor orangeColor];
    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
//        _secondsLabel.backgroundColor = [UIColor yellowColor];
    }
    return _secondsLabel;
}


@end
