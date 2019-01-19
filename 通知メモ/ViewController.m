//
//  ViewController.m
//  通知メモ
//
//  Created by sshota0809 on 2013/04/07.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize memolist;
@synthesize memo;
@synthesize memoUse;

//TODO:次はいpほねの画面にあわせてテーブルビューの大きさを変更する

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //初回起動時は NSUserDefault を作成する
    defaults = [NSUserDefaults standardUserDefaults];
    
    memoNotification = [[UILocalNotification alloc] init];
    
    
    
    //テスト用のテキストを表示　書き換えられたらデリゲート成功
    //label表示
    //test = [[UILabel alloc] initWithFrame:self.view.bounds];
    //test.text = @"書き換え前";
    //CGPoint testPoint = self.view.center;
    //testPoint.y +=0;
    //test.center = testPoint;

    
    //modalを表示するためのボタンを作成
    //modalon = [UIButton buttonWithType:UIButtonTypeCustom];
    //[modalon setTitle:@"modalを表示" forState:UIControlStateNormal];
    //[modalon sizeToFit];
    //CGPoint modalonPoint = self.view.center;
    //modalon.center = modalonPoint;
    //[modalon addTarget:self action:@selector(modalonPush) forControlEvents:UIControlEventTouchUpInside];
    
    //UIToolbarを表示するためのコード
    CGRect toolBarFrame = [UIScreen mainScreen].applicationFrame;
    toolBarFrame.size.height = 64;
    toolBarFrame.origin.y -= 20;
    menubar = [[UIToolbar alloc] initWithFrame:toolBarFrame];
    UIImage *barWood = [UIImage imageNamed:@"wood.jpg"];
    [menubar setBackgroundImage:barWood forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    //メモ追加用のボタンを menubar に追加
    add = [[UIBarButtonItem alloc] initWithTitle:@"追加" style:UIBarButtonItemStyleBordered target:self action:@selector(modalonPush)];
    
    //空白のボタンを使う。
    UIBarButtonItem *gap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    add.tintColor = [UIColor brownColor];
    self.editButtonItem.tintColor = [UIColor brownColor];
    
    //最後に二つ追加して表示
    menubar.items = [NSArray arrayWithObjects:self.editButtonItem, gap, add, nil];
    
    //メモ用の配列を初期化する
    memo = [[NSMutableArray alloc] initWithObjects:nil];
    
    //メモの時間表示用の配列を初期化する
    memoTime = [[NSMutableArray alloc] initWithObjects:nil];
    
    //まずはNSUserDefaultがすでにあるかないかチェック　あれば一度は起動した、なければ初回起動
    NSData *check = [defaults objectForKey:@"memoList"];
    if (check) {
        //すでにデータが格納されてるならばそれを使うので何もしないでいい
    }
    else {
        //データが格納されていないならば memo を NSUserDefaults に格納する手順を行う
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:memo];
        [defaults setObject:data forKey:@"memoList"];
        
        //これは日時表示用
        NSData *dataTime = [NSKeyedArchiver archivedDataWithRootObject:memoTime];
        [defaults setObject:dataTime forKey:@"memoListTime"];
    }
    
    //次に配列をもう一つ用意してこの配列を使用してテーブルの作成などを行う。テーブルに関する処理をしたらこの配列を defaults に保存する
    NSData *dataSyuturyoku = [defaults objectForKey:@"memoList"];
    memoUse = [NSKeyedUnarchiver unarchiveObjectWithData:dataSyuturyoku];
    
    //次はメモの時間用の配列
    NSData *datasyuturyokuTime = [defaults objectForKey:@"memoListTime"];
    memoTimeUse = [NSKeyedUnarchiver unarchiveObjectWithData:datasyuturyokuTime];
    
    
    //この時点で一度通知センターの処理を行う
    //ここから通知センター一式開始
    
    //配列の要素数を取り出し
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //一回全部消す
    //あらかじめ通知センター用のオブジェクトを生成しておく
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //アイコンも0にする
    int i = [memoUse count];
    for(int j = 0; j < i; j++) {
        //通知センターに追加された配列の要素を表示する
        memoNotification.timeZone = [NSTimeZone defaultTimeZone];
        memoNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //配列の一番最後の行をやる
        memoNotification.alertBody = [memoUse objectAtIndex:j];
        [[UIApplication sharedApplication] scheduleLocalNotification:memoNotification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    //ここまで通知センサー一式終了
    
    
    //メモを一覧にする TableView を追加
    //画面サイズで分岐
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    if (frame.size.height == 548.0) { //iphone5 (568 -20)
    memolist = [[UITableView alloc] initWithFrame:CGRectMake(0, 62, 320, 530)];
    }
    else { //iphone4S 以前
        memolist = [[UITableView alloc] initWithFrame:CGRectMake(0, 62, 320, 438)];
    }
    //Tableviewの背景を設定する
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corkboard2.jpg"]];
    self.memolist.backgroundView = imageView;
    memolist.rowHeight = 40.0;
    memolist.delegate = self;
    memolist.dataSource = self;
    
    [self.view addSubview:menubar];
    [self.view addSubview:memolist];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//modal表示用のボタンが押されたときの処理
- (void) modalonPush
{
    ModalView *modallll = [[ModalView alloc] init];
    modallll.delegate = self;
    [self presentViewController:modallll animated:YES completion:nil];
    
}

//modal側での処理をこちらで処理　テキストを配列に入れる
- (void)memoAdd:(NSString *)mozi
{
    NSLog(@"aaa");
    [memoUse addObject:mozi];
    
    //時間を取得する
    NSDate *now = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy年MM月dd日 HH時mm分"];
    NSString *dataString = [dataFormatter stringFromDate:now];
    NSLog(@"%@", dataString);
    [memoTimeUse addObject:dataString];
    
    
    //変更された memoUse を defaults に保存する
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:memoUse];
    [defaults setObject:data forKey:@"memoList"];
    
    //次に時間も defaults に保存する
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:memoTimeUse];
    [defaults setObject:data2 forKey:@"memoListTime"];
    
    
    //ここから通知センター一式開始
    //配列の要素数を取り出し
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //一回全部消す
    
    //あらかじめ通知センター用のオブジェクトを生成しておく
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //アイコンも0にする
    int i = [memoUse count];
    for(int j = 0; j < i; j++) {
        
    //通知センターに追加された配列の要素を表示する
    memoNotification.timeZone = [NSTimeZone defaultTimeZone];
    memoNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        
    //配列の一番最後の行をやる
    memoNotification.alertBody = [memoUse objectAtIndex:j];
    [[UIApplication sharedApplication] scheduleLocalNotification:memoNotification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    //ここまで通知センサー一式終了
}

//cellViewのdelegate
- (void)memoEdit:(NSString *)moziEditAfter
{
    //書き換えられた行の文字を編集
    [memoUse replaceObjectAtIndex:appDelegate.memoListNum withObject:moziEditAfter];
    
    //変更された memoUse を defaults に保存する
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:memoUse];
    [defaults setObject:data forKey:@"memoList"];
    
    //ここから通知センター一式開始
    //配列の要素数を取り出し
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //一回全部消す
    
    //あらかじめ通知センター用のオブジェクトを生成しておく
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //アイコンも0にする
    int i = [memoUse count];
    for(int j = 0; j < i; j++) {
        
        //通知センターに追加された配列の要素を表示する
        memoNotification.timeZone = [NSTimeZone defaultTimeZone];
        memoNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        
        //配列の一番最後の行をやる
        memoNotification.alertBody = [memoUse objectAtIndex:j];
        [[UIApplication sharedApplication] scheduleLocalNotification:memoNotification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    //ここまで通知センサー一式終了
    
}

//テーブルに含まれるセクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//セクションに含まれる行の数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [memoUse count];
}

//行に表示するデータの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    cell.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.textLabel.text = [memoUse objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [memoTimeUse objectAtIndex:indexPath.row];

    return cell;
}

//セルが選択された時の画面移動処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //セルの選択を解除する
    [self.memolist deselectRowAtIndexPath:indexPath animated:YES];

    
    //セルの文字列を取得する
    celldesu = [self.memolist cellForRowAtIndexPath:indexPath];
    appDelegate.memoText = celldesu.textLabel.text;
    appDelegate.memoListNum = indexPath.row;
    
    NSLog(@"%@", appDelegate.memoText);
    NSLog(@"%d", appDelegate.memoListNum);
    
    //新しいviewを作成
    cellView *cellViewdesu = [[cellView alloc] init];
    cellViewdesu.delegate = self;
    [self presentViewController:cellViewdesu animated:YES completion:nil];
    
}



//editボタンで反応させる
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.memolist setEditing:editing animated:animated];
}

//editボタンが押されたときセルを削除できる
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [memoUse removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
        [memoTimeUse removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
        [memolist deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
    
    //変更された memoUse を defaults に保存する
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:memoUse];
    [defaults setObject:data forKey:@"memoList"];
    
    //次に時間も defaults に保存する
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:memoTimeUse];
    [defaults setObject:data2 forKey:@"memoListTime"];
    
    
    //ここから通知センター一式開始
    
    //配列の要素数を取り出し
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //一回全部消す
    //あらかじめ通知センター用のオブジェクトを生成しておく
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //アイコンも0にする
    int i = [memoUse count];
    for(int j = 0; j < i; j++) {
        //通知センターに追加された配列の要素を表示する
        memoNotification.timeZone = [NSTimeZone defaultTimeZone];
        memoNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //配列の一番最後の行をやる
        memoNotification.alertBody = [memoUse objectAtIndex:j];
        [[UIApplication sharedApplication] scheduleLocalNotification:memoNotification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    //ここまで通知センサー一式終了
}

//editボタンが押されたときセルを移動する
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if(fromIndexPath.section == toIndexPath.section) { // 移動元と移動先は同じセクションです。
        if(memoUse && toIndexPath.row < [memoUse count]) {
            id item = [memoUse objectAtIndex:fromIndexPath.row];
            id item2 = [memoTimeUse objectAtIndex:fromIndexPath.row];
            [memoUse removeObject:item]; // 配列から一度消します。
            [memoUse insertObject:item atIndex:toIndexPath.row]; // 保持しておいた対象を挿入します。
            [memoTimeUse removeObject:item2]; // 配列から一度消します。
            [memoTimeUse insertObject:item2 atIndex:toIndexPath.row]; // 保持しておいた対象を挿入します。
        }
    }
    
    //変更された memoUse を defaults に保存する
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:memoUse];
    [defaults setObject:data forKey:@"memoList"];
    
    //次に時間も defaults に保存する
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:memoTimeUse];
    [defaults setObject:data2 forKey:@"memoListTime"];
    
    
    //ここから通知センター一式開始
    
    //配列の要素数を取り出し
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //一回全部消す
    //あらかじめ通知センター用のオブジェクトを生成しておく
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //アイコンも0にする
    int i = [memoUse count];
    for(int j = 0; j < i; j++) {
        //通知センターに追加された配列の要素を表示する
        memoNotification.timeZone = [NSTimeZone defaultTimeZone];
        memoNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //配列の一番最後の行をやる
        memoNotification.alertBody = [memoUse objectAtIndex:j];
        [[UIApplication sharedApplication] scheduleLocalNotification:memoNotification];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = i;
    
    //ここまで通知センサー一式終了
}


//Viewが表示される直前に実行される
- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath* selection = [memolist indexPathForSelectedRow];
    if(selection){
        [memolist deselectRowAtIndexPath:selection animated:YES];
    }
    [memolist reloadData];

}
//Viewが表示された直後に実行される
- (void)viewDidAppear:(BOOL)animated {
    [self.memolist flashScrollIndicators];
}




@end