//
//  BulletView.h
//  CommentDemo
//
//  Created by hznucai on 16/8/11.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义一个枚举 来表明弹幕的三种状态 飞入 在屏幕中 和飞出屏幕
typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,
    Enter,
    End
};
@interface BulletView : UIView

//弹道
@property(nonatomic,assign)int tranjectory;
//记录状态 用回调
@property(nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);
//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment;
//开始动画
-(void)startAnimation;
//结束动画
-(void)stopAnimation;
@end
