//
//  DRScrollListView.h
//  DjvuViewer
//
//  Created by Alex Martynov on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DRScrollListViewDelegate.h"

@interface DRScrollListView : UIScrollView {
	
@private
	id<DRScrollListViewDelegate> delegate;
	NSMutableSet* visiblePages;
	NSMutableSet* reusablePages;
	BOOL isLayouted;
	
}

@property(nonatomic,assign) CGSize itemSize;
@property(nonatomic,assign) CGFloat spaceBetweenItems;
@property(nonatomic,assign) id<DRScrollListViewDelegate> delegate;

-(UIView<DRScrollListViewItem>*)dequeueReusableItem;

@end
