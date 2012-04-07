//
//  DRScrollListViewDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRScrollListView;

@protocol DRScrollListViewItem;

@protocol DRScrollListViewDelegate <NSObject, UIScrollViewDelegate>

@required
-(NSUInteger)numberOfItemsInListView:(DRScrollListView*)listView;
-(UIView<DRScrollListViewItem>*)listView:(DRScrollListView*)listView itemViewForIndex:(NSUInteger)index;

@end
