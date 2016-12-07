//
//  UIView+EmptyView.h
//  CategoryDemo
//
//  Created by WSCN on 07/12/2016.
//  Copyright © 2016 wallstreetcn.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseEmptyView : UIControl

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *label;

@end


@interface UIView (EmptyView)

@property (nonatomic, strong) BaseEmptyView *baseEmptyView;
@property (nonatomic, strong) UIButton *hideButton;

- (void) showEmptyViewWith:(NSString *)tips;

- (void) hideEmptyView;

@end
