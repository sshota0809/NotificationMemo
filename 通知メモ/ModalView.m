//
//  ModalView.m
//  通知メモ
//
//  Created by sshota0809 on 2013/04/07.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import "ModalView.h"

@implementation ModalView

@synthesize memoContent;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //NavigationBarを表示
    UINavigationBar *navi = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    navi.barStyle = UIBarStyleBlack;
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"メモ新規作成"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelOn:)];
    add = [[UIBarButtonItem alloc] initWithTitle:@"追加" style:UIBarButtonItemStyleBordered target:self action:@selector(add:)];
    add.enabled = NO;
    naviItem.leftBarButtonItem = cancel;
    naviItem.rightBarButtonItem = add;
    [navi pushNavigationItem:naviItem animated:YES];
    UIImage *barWood = [UIImage imageNamed:@"wood2.jpg"];
    [navi setBackgroundImage:barWood forBarMetrics:UIBarMetricsDefault];
    cancel.tintColor = [UIColor brownColor];
    add.tintColor = [UIColor brownColor];
    
    [self.view addSubview:navi];

    
    //label表示
    //modaldayo = [[UILabel alloc] initWithFrame:self.view.bounds];
    //modaldayo.text = @"modal表示中";
    //[self.view addSubview:modaldayo];
    
    //modalを閉じるボタン
    //modalを表示するためのボタンを作成
    //modaloff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[modaloff setTitle:@"modalを閉じます" forState:UIControlStateNormal];
    //[modaloff sizeToFit];
    //CGPoint modaloffPoint = self.view.center;
    //modaloffPoint.y += 80;
    //modaloff.center = modaloffPoint;
    //[modaloff addTarget:self action:@selector(modaloffPush:) forControlEvents:UIControlEventTouchUpInside];
    // [self.view addSubview:modaloff];
    
    //メモ入力項目
    memoContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, 320, 520)];
    memoContent.editable = YES;
    [memoContent setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:memoContent];
    [memoContent becomeFirstResponder];
    memoContent.delegate = self;
    
    //キーボードをタップで閉じるための処理
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
}

//キャンセルを押したら閉じる
- (void)cancelOn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) add:(id)sender {
    NSString *ukewatasi = memoContent.text;
    if ( [self.delegate respondsToSelector:@selector(memoAdd:)] ) {
        [self.delegate memoAdd:ukewatasi];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* - (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [memoContent resignFirstResponder];
    return YES;
} */

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

//文字入力をしたときに呼び出される
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([memoContent hasText]) {
    add.enabled = YES;
    }
    return YES;
}

@end