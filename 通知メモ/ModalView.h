//
//  ModalView.h
//  通知メモ
//
//  Created by sshota0809 on 2013/04/07.
//  Copyright (c) 2013年 sshota0809. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ModalView;

@protocol ModalViewDelegate <NSObject>

- (void)memoAdd:(NSString *)text;

@end

@interface ModalView : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate> {
    //UILabel *modaldayo;
    //UIButton *modaloff;
    UITextView *memoContent;
    UIBarButtonItem *add;
}

//画面外をタップしたらキーボードが閉じるようにするための処理
@property(strong, nonatomic) UITapGestureRecognizer *singleTap;

@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) UITextView *memoContent;
@property(weak, nonatomic) id<ModalViewDelegate> delegate;


@end
