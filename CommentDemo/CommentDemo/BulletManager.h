//
//  BulletManager.h
//  CommentDemo
//
//  Created by hznucai on 16/8/11.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@class BulletView;
@interface BulletManager : NSObject

//回调
@property(nonatomic,copy)void(^generateViewBlock)(BulletView *view);
//弹幕开始执行
-(void)start;
//弹幕停止执行
-(void)stop;
@end
