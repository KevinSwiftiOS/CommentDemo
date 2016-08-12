//
//  BulletView.m
//  CommentDemo
//
//  Created by hznucai on 16/8/11.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import "BulletView.h"
#define padding 10
#define photoHeight 10
@interface BulletView()
//要显示的文字
@property(strong,nonatomic)UILabel *lbComment;
@property(strong,nonatomic)UIImageView *photoImv;

@end
@implementation BulletView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

*/
//初始化弹幕

-(instancetype)initWithComment:(NSString *)comment{
if(self = [super init]){
    //
    self.backgroundColor = [UIColor redColor];
    //libComment 求宽
    self.lbComment.text = comment;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat width = [comment sizeWithAttributes:attr].width;
    self.bounds = CGRectMake(0, 0, width + padding * 2, 30);
    self.lbComment.frame = CGRectMake(padding, 0, width, 30);
}
    return self;
}
//开始动画
-(void)startAnimation{
    //根据弹幕的长度执行动画效果
    //根据v = s/t 时间相同的情况下，距离越长，速度就越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    __block CGRect frame = self.frame;
    
    
//弹幕开始
    if(self.moveStatusBlock){
        self.moveStatusBlock(Start);
    }

    //计算enterDuration
    //t = s/v
    CGFloat speed = wholeWidth / duration;
    //完全飞入屏幕
    CGFloat enterDuraton = CGRectGetWidth(self.bounds) / speed;
    //没有办法中途停止 GCD方法
    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuraton];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuraton * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(self.moveStatusBlock){
//            self.moveStatusBlock(Enter);
//        }
//    });
//

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.moveStatusBlock){
            //回调函数
            self.moveStatusBlock(End);
        }
    }];
    
}

-(void)EnterScreen{
    if(self.moveStatusBlock){
        //回调函数
        self.moveStatusBlock(Enter);
}
}

//结束动画
-(void)stopAnimation{
    //消失 销毁
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //layer上面的动画全部remove掉
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
 }
-(UILabel *)lbComment{
    if(!_lbComment){
        _lbComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
        
        
    }
    return _lbComment;
}
@end
