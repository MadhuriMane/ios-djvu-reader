//
//  DRBookScrollViewDataSource.m
//  DjvuViewer
//
//  Created by Alex Martynov on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBookScrollViewDataSource.h"

#import "DRImageScrollView.h"

@implementation DRBookScrollViewDataSource

-(id)init
{
	if (self = [super init])
	{
		self.pageSize = CGSizeMake(1024, 768);
	}
	return self;
}

-(void)dealloc
{
	[visiblePages release];
	[reusablePages release];
	[super dealloc];
}

#pragma mark -
#pragma mark public

-(void)updateVisiblePagesForRect:(CGRect)rect
{
	CGRect scrollBounds = rect;
	int firstVisiblePageIndex = 
	floorf(CGRectGetMinX(scrollBounds) / CGRectGetWidth(scrollBounds));
	int lastVisiblePageIndex = firstVisiblePageIndex + 1;
	
	NSMutableSet* invisiblePages = [NSMutableSet new];
	for (UIView* view in visiblePages)
	{
		int viewIndex = view.tag;
		if (viewIndex < firstVisiblePageIndex || 
			viewIndex > lastVisiblePageIndex)
		{
			[invisiblePages addObject:view];
			[view removeFromSuperview];
		}
	}
	
	[visiblePages minusSet:invisiblePages];
	[reusablePages unionSet:invisiblePages];
	[invisiblePages release];
	
	for (int i = firstVisiblePageIndex; i <= lastVisiblePageIndex; i++)
	{
		BOOL isVisible = NO;
		for (UIView* view in visiblePages)
		{
			if (view.tag == i)
			{
				isVisible = YES;
				if (i == firstVisiblePageIndex)
					currentView = view;
				break;
			}
		}
		
		if (isVisible)
		{
			continue;
		}
		
		DRImageScrollView* newImageView = 
		[[[reusablePages anyObject]retain]autorelease];
		[newImageView prepareForReuse];
		
		if (!newImageView)
		{
			newImageView = [[DRImageScrollView new]autorelease];
		}
		else
		{
			[reusablePages removeObject:newImageView];
		}
		
		CGRect viewRect = scrollBounds;
		viewRect.origin.x = i * self.pageSize.width;
		
		newImageView.tag = i;
		newImageView.frame = viewRect;
//		newImageView.imageView.image = 
//		[djvuParser imageForPage:i
//						  ofSize:CGSizeZero];
//		[self.scrollView addSubview:newImageView];
		[visiblePages addObject:newImageView];
		
		if (i == firstVisiblePageIndex)
			currentView = newImageView;
	}
}

@end
