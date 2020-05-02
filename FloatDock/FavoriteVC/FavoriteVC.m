//
//  FavoriteVC.m
//  FloatDock
//
//  Created by 王凯庆 on 2020/4/29.
//  Copyright © 2020 王凯庆. All rights reserved.
//

#import "FavoriteVC.h"
#import <Masonry/Masonry.h>
#import "FavoriteAppEntity.h"
#import "FavoriteColumnEntity.h"

#import "FavoriteVM.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "HotKeyTool.h"


@interface FavoriteVC () 

//@property (nonatomic, strong) NSTextField  * tipTF;
@property (nonatomic, strong) NSTextView   * tipTextView;

@property (nonatomic, strong) NSTableView  * infoTV;
@property (nonatomic, strong) NSScrollView * infoTV_CSV;
@property (nonatomic, strong) NSMenu       * infoTVClickMenu;

@property (nonatomic, weak  ) HotKeyTool      * hotKeyTool;


@property (nonatomic, strong) FavoriteVM   * favoriteVM;

@end

@implementation FavoriteVC

// 没有 使用 xib 的话, 需要自己创建
- (void)loadView {
    self.view = [NSView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    //[self addTFs];2
    [self addTextViews];
    
    self.hotKeyTool = [HotKeyTool share];
    self.favoriteVM = [FavoriteVM new];
    
    [self addTagTVs];
    self.favoriteVM.infoTV = self.infoTV;
    
    [self.infoTV setTarget:self.favoriteVM];
    [self.infoTV setAction:@selector(closeEditHotkeyInner)];
    
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self.favoriteVM action:@selector(closeEditHotkeyInner)];
    [self.tipTextView addGestureRecognizer:click];
    
    @weakify(self);
    [RACObserve(self.hotKeyTool.favoriteAppArrayEntity, array) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self.infoTV reloadData];
    }];
    
    //2[self.view needsLayout];
}

/*
- (void)addTFs {
    self.tipTF = ({
        NSTextField * tf = [NSTextField new];
        tf.backgroundColor = [NSColor clearColor];//[NSColor textBackgroundColor];
        tf.textColor       = [NSColor textColor];
        tf.alignment       = NSTextAlignmentLeft;
        tf.font            = [NSFont systemFontOfSize:14];
        tf.bordered        = NO;
        tf.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        tf.editable        = NO;

        tf.maximumNumberOfLines = 3;

        [self.view addSubview:tf];
        tf;
    });

    self.tipTF.stringValue = @"全局快捷键需要您在 [系统偏好设置] > [安全与隐私] > [辅助功能] 中选中 FloatDock, 并且重启APP.";

    [self.tipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
        //make.bottom.mas_equalTo(-20);
        //make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
    }];
}
//*/

- (void)addTextViews {
    
    self.tipTextView = ({
        NSTextView * tv = [NSTextView new];
        tv.backgroundColor = [NSColor clearColor];//[NSColor textBackgroundColor];
        tv.textColor       = [NSColor textColor];
        tv.alignment       = NSTextAlignmentLeft;
        tv.font            = [NSFont systemFontOfSize:13];
        //tf.bordered        = NO;
        //tf.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        tv.editable        = NO;
        
        
        //tf.maximumNumberOfLines = 3;
        
        [self.view addSubview:tv];
        tv;
    });
    
    [self.tipTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        //make.bottom.mas_equalTo(-20);
        //make.height.mas_equalTo(60);
        make.right.mas_equalTo(-5);
        make.height.mas_lessThanOrEqualTo(40);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    self.tipTextView.string = @"全局快捷键需要您在 [系统偏好设置] > [安全与隐私] > [辅助功能] 中选中 FloatDock, 并且重启APP.";
    //[self.tipTextView sizeToFit];
}

// MARK: tv
- (NSScrollView *)addTagTVs {
    CGFloat width = 100;
    // create a table view and a scroll view
    NSScrollView * tableContainer  = [[NSScrollView alloc] initWithFrame:CGRectZero];
    NSTableView * tableView        = [[NSTableView alloc] initWithFrame:tableContainer.bounds];
    tableView.tag = 0;
    
    FavoriteColumnEntity * eName = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eHotkey = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eSwitch = [FavoriteColumnEntity new];
    FavoriteColumnEntity * ePath = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eDelete = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eFavorite = [FavoriteColumnEntity new];
    FavoriteColumnEntity * eIcon  = [FavoriteColumnEntity new];
    
    eName.title = @"名称(拖拽排序)";
    eName.columnID = @"2";
    eName.tip = @"APP 名称";
    eName.width = 200;
    eName.miniWidth = 70;
    
    eHotkey.title = @"全局快捷键";
    eHotkey.columnID = @"3";
    eHotkey.tip = @"APP 快捷键";
    eHotkey.width = 90;
    eHotkey.miniWidth = 50;
    
    eSwitch.title = @"开关";
    eSwitch.columnID = @"1";
    eSwitch.tip = @"快捷键开关";
    eSwitch.width = 30;
    eSwitch.miniWidth = 30;
    
    ePath.title = @"路径";
    ePath.columnID = @"4";
    ePath.tip = @"APP 路径";
    ePath.width = 300;
    ePath.miniWidth = 100;

    
    eDelete.title = @"删除快捷键";
    eDelete.columnID = @"5";
    eDelete.tip = @"删除快捷键";
    eDelete.width = 60;
    eDelete.miniWidth = 60;
    
    eIcon.title = @"图标";
    eIcon.columnID = @"6";
    eIcon.tip = @"图标";
    eIcon.width = FavoriteCellHeight;
    eIcon.miniWidth = FavoriteCellHeight;
    
    eFavorite.title = @"取消收藏";
    eFavorite.columnID = @"7";
    eFavorite.tip = @"取消收藏";
    eFavorite.width = 60;
    eFavorite.miniWidth = 60;
    
    NSArray * array = @[eSwitch, eIcon, eName, eHotkey, eDelete, eFavorite]; //ePath
    
    for (int i=0; i<array.count; i++) {
        FavoriteColumnEntity * entity = array[i];
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:entity.columnID];
        column.width         = entity.width;
        column.minWidth      = entity.miniWidth;
        column.title         = entity.title;
        column.headerToolTip = entity.tip;
        
        [tableView addTableColumn:column];
        
        width = entity.width;
    }
    
    tableView.delegate                   = self.favoriteVM;
    tableView.dataSource                 = self.favoriteVM;
    [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]]; // 注册可拖拽
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.tipTextView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.infoTV = tableView;
    
    return tableContainer;
}

- (void)closeEditHotkeyOuter {
    [self.favoriteVM closeEditHotkeyOuter];
}

@end
