//
//  cellView.h
//  通知メモ
//
//  Created by sshota0809 on 2013/04/14.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@class cellView;

@protocol CellViewDelegate <NSObject>

- (void)memoEdit:(NSString *)moziEditAfter;

@end


@interface cellView : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate> {
    UITextView *memoContent;
    UIToolbar *menubar;
    UIView *hoge;
    UIBarButtonItem * add;
    UIBarButtonItem *edit;
}

//画面外をタップしたらキーボードが閉じるようにするための処理
@property(strong, nonatomic) UITapGestureRecognizer *singleTap;
@property(strong, nonatomic) UITextView *memoContent;
@property(strong, nonatomic) UIView *hoge;

@property(weak, nonatomic) id<CellViewDelegate> delegate;

@end
