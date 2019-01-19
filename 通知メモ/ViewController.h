//
//  ViewController.h
//  通知メモ
//
//  Created by sshota0809 on 2013/04/07.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalView.h"
#import "AppDelegate.h"
#import "cellView.h"

@interface ViewController : UIViewController <ModalViewDelegate, CellViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIButton *modalon;
    UILabel *test;
    UIToolbar *menubar;
    UIBarButtonItem * add;
    UIBarButtonItem *edit;
    UITableView *memolist;
    //メモ書き込みよう
    NSMutableArray *memo;
    NSMutableArray *memoUse;
    NSUserDefaults *defaults;
    UILocalNotification *memoNotification;
    
    AppDelegate *appDelegate;
    UITableViewCell *celldesu;
    
    //ここからdetailtextで日時を表示する
    NSMutableArray *memoTime;
    NSMutableArray *memoTimeUse;
    
}


@property(strong, nonatomic) UITableView *memolist;
@property(strong, nonatomic) NSMutableArray *memo;
@property(strong, nonatomic) NSMutableArray *memoUse;

- (void)memoAdd:(NSString *)mozi;
- (void)memoEdit:(NSString *)moziEditAfter;
@end