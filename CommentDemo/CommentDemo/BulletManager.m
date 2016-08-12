//
//  BulletManager.m
//  CommentDemo
//
//  Created by hznucai on 16/8/11.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager()
//弹幕的数据来源
@property(nonatomic,strong)NSMutableArray *dataSource;
//弹幕生成过程中的数组变量
@property(nonatomic,strong)NSMutableArray *bulletComments;
//存储过程中创建的view
@property(nonatomic,strong)NSMutableArray *bulletViews;
@property BOOL bStopAnimation;
@end
@implementation BulletManager

-(instancetype)init{
    if(self = [super init]){
        _bStopAnimation = true;
    }
    return  self;
}
-(void)start{
    //填充数据
    if(!self.bStopAnimation){
        return;
    }
    _bStopAnimation = false;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}
-(void)stop{
    if(self.bStopAnimation){
        return;
    }
    self.bStopAnimation= true;
    //遍历bulletView
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}
//初始化弹幕 随机分配弹幕轨迹
-(void)initBulletComment{
    NSMutableArray *tranjectorys = [[NSMutableArray alloc]initWithArray:@[@0,@1,@2]];
    for(int i = 0; i < 3; i++){
        //判断
        if(self.bulletComments.count > 0){
        //通过随机数取出弹幕的轨迹
        NSInteger index = arc4random() % tranjectorys.count;
    //取出单道
        int tranjectory = [[tranjectorys objectAtIndex:index]intValue];
        [tranjectorys removeObjectAtIndex:index];
        
    
    //从弹幕数组中注意的取出弹幕数据
    NSString *comment = [self.bulletComments firstObject];
    [self.bulletComments removeObjectAtIndex:0];
    //创建弹幕
    [self createBulletView:comment tranjetory:tranjectory];
}
    }
}
//创建弹幕
-(void)createBulletView:(NSString *)comment tranjetory:(int)tranjetory{
    if(self.bStopAnimation){
        return;
    }
    
    
    
    BulletView *view = [[BulletView alloc]initWithComment:comment];
    view.tranjectory = tranjetory;
    __weak typeof (view) weakView =  view;
    __weak typeof (self) myself = self;
    [self.bulletViews addObject:view];
    view.moveStatusBlock = ^(MoveStatus status){
        if(self.bStopAnimation){
            return ;
        }
        switch (status){
            case Start:
                //弹幕开始进入屏幕,将view加入到弹幕管理的bulletView中
                [myself.bulletViews addObject:weakView];
                break;
            case Enter:{
                //弹幕完全进入屏幕 判断是否还有其他弹幕，如果有则在该弹幕轨迹中再添加一个弹幕
                NSString *comment = [myself nextComment];
                if(comment){
                    [myself createBulletView:comment tranjetory:tranjetory];
                }
                break;
            }
            case End:{
                
            //弹幕完全飞出屏幕后 从bulletViews中删除 释放资源
                if([myself.bulletViews containsObject:weakView]){
                    [weakView stopAnimation];
                    [myself.bulletViews removeObject:weakView];
                }
                //实现循环
                if(myself.bulletViews.count == 0){
                    self.bStopAnimation = true;
                    //说明屏幕上已经没有弹幕了 开始循环滚动
                    [myself start];
                }
                break;
            }
            default:
                break;
                
        }
//        //移除屏幕后销毁资源和弹幕
//        [weakView stopAnimation];
//        [myself.bulletViews removeObject:weakView];
        
    };
    if(self.generateViewBlock){
        self.generateViewBlock(view);
    
    
    }
}
//取出下一道弹幕
-(NSString *)nextComment{
    if(self.bulletComments.count == 0){
        return  nil;
    }
    
    NSString *comment = [self.bulletComments firstObject];
    if(comment){
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}
-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc]initWithArray:@[@"弹幕1~~~~~~~~~",@"弹幕2~~~~~~~~~",@"弹幕3~~~",@"弹幕4~~~~~~~~~",@"弹幕5~~~~~~~~~",@"弹幕6~~~",
                                                             @"弹幕7~~~~~~~~~",@"弹幕8~~~~~~~~~",@"弹幕9~~~",
                                                             @"弹幕10~~~~~~~~~",@"弹幕11~~~~~~~~~",@"弹幕12~~~"]];
    }
    return _dataSource;
}
-(NSMutableArray *)bulletComments{
    if(!_bulletComments){
        _bulletComments = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)bulletViews{
    if(!_bulletViews){
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
