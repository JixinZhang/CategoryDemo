//
//  UIView+EmptyView.m
//  CategoryDemo
//
//  Created by WSCN on 07/12/2016.
//  Copyright © 2016 wallstreetcn.com. All rights reserved.
//
//  参考资料: http://www.jianshu.com/p/3cbab68fb856

#import "UIView+EmptyView.h"
#import <objc/runtime.h>

@interface BaseEmptyView()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;

@end

@implementation BaseEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2-160, 0, 320, CGRectGetHeight(self.bounds) - 25)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"ThamesTown"];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2-160, CGRectGetHeight(self.bounds) - 25, 320, 50)];
        _label.textColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16.0f];
    }
    return _label;
}

@end

/*
 *  👇给UIView添加了一个emptyView category
 *  参考资料：http://www.jianshu.com/p/535d1574cb86
 */

@implementation UIView (EmptyView)

- (BaseEmptyView *)baseEmptyView {
    BaseEmptyView *_baseEmptyView = objc_getAssociatedObject(self, _cmd);
    if (!_baseEmptyView) {
        _baseEmptyView = [[BaseEmptyView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-110, 60, 220, 200)];
        objc_setAssociatedObject(self, _cmd, _baseEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _baseEmptyView;
}

- (void)setBaseEmptyView:(BaseEmptyView *)baseEmptyView {
    objc_setAssociatedObject(self, @selector(baseEmptyView), baseEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)hideButton {
    UIButton *_hideButton = objc_getAssociatedObject(self, @selector(hideButton));
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideButton.frame = CGRectMake(self.bounds.size.width/2-110, 300, 220, 44);
        _hideButton.backgroundColor = [UIColor brownColor];
        [_hideButton setTitle:@"Hide" forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(hideEmptyView) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, @selector(hideButton), _hideButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _hideButton;
}

- (void)setHideButton:(UIButton *)hideButton {
    objc_setAssociatedObject(self, @selector(hideButton), hideButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showEmptyViewWith:(NSString *)tips {
    self.baseEmptyView.label.text = tips;
    if (!self.baseEmptyView.superview) {
        [self addSubview:self.baseEmptyView];
    }
    
    if (!self.hideButton.superview) {
        [self addSubview:self.hideButton];
    }
}

- (void)hideEmptyView {
    [self.baseEmptyView removeFromSuperview];
    [self.hideButton removeFromSuperview];
}

@end
