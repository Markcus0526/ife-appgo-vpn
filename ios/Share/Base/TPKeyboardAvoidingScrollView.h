//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKeyboardAvoidingScrollView : UIScrollView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

@property (nonatomic, readwrite) BOOL   keyboardVisible;


- (void)adjustOffsetToIdealIfNeeded;
@end
