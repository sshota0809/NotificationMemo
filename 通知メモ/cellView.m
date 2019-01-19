//
//  cellView.m
//  通知メモ
//
//  Created by sshota0809 on 2013/04/14.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import "cellView.h"

@implementation cellView

@synthesize memoContent;
@synthesize hoge;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"corkboard2.jpg"];
    
    hoge = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 528)];
   self.hoge.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    

    
    //NavigationBarを表示
    UINavigationBar *navi = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"選択したメモ"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelOn:)];
    //メモ編集用
    add = [[UIBarButtonItem alloc] initWithTitle:@"編集" style:UIBarButtonItemStyleBordered target:self action:@selector(add:)];
    naviItem.leftBarButtonItem = cancel;
    naviItem.rightBarButtonItem = add;
    [navi pushNavigationItem:naviItem animated:YES];
    UIImage *barWood = [UIImage imageNamed:@"wood2.jpg"];
    [navi setBackgroundImage:barWood forBarMetrics:UIBarMetricsDefault];
    cancel.tintColor = [UIColor brownColor];
    add.tintColor = [UIColor brownColor];
    // navi.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:navi];
    [self.view addSubview:hoge];
    
    //メモ入力項目
        memoContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 310, 280)];
    memoContent.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    // memoContent.layer.borderWidth = 1;
    // memoContent.layer.borderColor = [[UIColor blackColor] CGColor];
    //編集不可能にする
    // memoContent.editable = NO;
    //メモのテキストを指定
    [memoContent setFont:[UIFont systemFontOfSize:17]];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    memoContent.text = appDelegate.memoText;
    CGPoint testfieldPoint = self.view.center;
    testfieldPoint.y -= 30;
    memoContent.center = testfieldPoint;
    [self.hoge addSubview:memoContent];
    //[memoContent becomeFirstResponder];
    memoContent.delegate = self;
    
    //ピンの画像を表示
    UIImage *pin = [UIImage imageNamed:@"pin.png"];
    UIImageView *pinUp = [[UIImageView alloc] initWithImage:pin];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    if (frame.size.height == 548.0) { //iphone5 (568 -20)
    [pinUp setFrame:CGRectMake(145, 160, pin.size.width / 2, pin.size.height / 2)];
    }
    else {
    [pinUp setFrame:CGRectMake(145, 118, pin.size.width / 2, pin.size.height / 2)];
    }
    [self.view addSubview:pinUp];
    
    //キーボードをタップで閉じるための処理
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
}

//画面がタップされたらキーボードを閉じる
- (void) onSingleTap:(UITapGestureRecognizer *)recognizer {
    [memoContent resignFirstResponder];
}

//キーボード非表示の時にほかにキーボードを閉じるタップの処理を適用しない
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        //キーボード表示中のみ有効にする
        if (self.memoContent.isFirstResponder) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}

//キャンセルを押したら閉じる
- (void)cancelOn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//編集ボタンを押したときの処理
- (void)add:(id)sender {
    if ( [self.delegate respondsToSelector:@selector(memoEdit:)] ) {
        [self.delegate memoEdit:memoContent.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
