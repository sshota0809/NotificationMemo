//
//  AppDelegate.h
//  通知メモ
//
//  Created by sshota0809 on 2013/04/07.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController; 

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    //画面移動の時にテキストを保存するための変数
    NSString *memoText;
    //画面移動の時のセルの番号を記憶するための変数
   //S int memoListNum;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *memoText;

@property int memoListNum;

@end
