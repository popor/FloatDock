//
//  StatusBarView.h
//  FloatDock
//
//  Created by popor on 2020/11/20.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FavoriteAppEntity.h"

NS_ASSUME_NONNULL_BEGIN

@class StatusBarView;

typedef void(^StatusBarViewBlockPVoid) (StatusBarView * statusBarView);
//typedef void(^StatusBarViewBlockPVoid) (StatusBarView * statusBarView, NSInteger indexPathRow);

@interface StatusBarView : NSView

@property (nonatomic, strong) NSButton    * iconBT;
@property (nonatomic, strong) NSTextField * nameTF;
@property (nonatomic, strong) NSTextField * hotkeyTF;
@property (nonatomic, strong) NSTextField * statusTF;
@property (nonatomic        ) BOOL          hotkeyEnable;

@property (nonatomic        ) NSInteger     number;
@property (nonatomic, weak  ) FavoriteAppEntity * weakFavoriteAppEntity;

@property (nonatomic, copy  ) StatusBarViewBlockPVoid selectBlock;

- (void)updateHotKeyTfColor;

@end

NS_ASSUME_NONNULL_END
