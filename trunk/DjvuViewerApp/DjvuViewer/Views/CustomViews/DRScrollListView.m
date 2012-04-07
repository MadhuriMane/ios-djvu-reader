//
//  DRScrollListView.m
//  DjvuViewer
//
//  Created by Alex Martynov on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRScrollListView.h"

#import "DRScrollListViewItem.h"

@interface DRScrollListView() <UIScrollViewDelegate>

-(void)initScrollListView;
-(void)updateScrollViewContentSize;
-(void)updateVisiblePagesIfNeeded;

@end

@implementation DRScrollListView

- (id)init
{
	if (self = [super init])
	{
		[super setDelegate:self];
		[self initScrollListView];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[super setDelegate:self];
		[self initScrollListView];
	}
	return self;
}

- (void)dealloc
{
	[visiblePages release];
	[reusablePages release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIScrollView

-(void)setDelegate:(id<DRScrollListViewDelegate>)aDelegate
{
	if ((id<UIScrollViewDelegate>)aDelegate == self)
		[super setDelegate:delegate];
	else
		delegate = aDelegate;
}

-(id<DRScrollListViewDelegate>)delegate
{
	return delegate;
}

#pragma mark -
#pragma mark UIView

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self updateScrollViewContentSize];
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
}

-(void)layoutSubviews
{
	if (!isLayouted)
	{
		[self updateScrollViewContentSize];
		[self updateVisiblePagesIfNeeded];
		isLayouted = YES;
	}
	[super layoutSubviews];
}

#pragma mark -
#pragma mark properties

@synthesize itemSize, spaceBetweenItems;

#pragma mark -
#pragma mark public

-(UIView<DRScrollListViewItem>*)dequeueReusableItem
{
	if ([reusablePages count] == 0)
		return nil;
	UIView<DRScrollListViewItem>* reusableView = 
		[[[reusablePages anyObject]retain]autorelease];
	
	[reusablePages removeObject:reusableView];
	
	return reusableView;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self updateVisiblePagesIfNeeded];
}

#pragma mark -
#pragma mark private

-(void)initScrollListView
{
	visiblePages = [NSMutableSet new];
	reusablePages = [NSMutableSet new];
	self.pagingEnabled = YES;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	
	self.spaceBetweenItems = 40;
	
	self.backgroundColor = [UIColor redColor];
	self.clipsToBounds = YES;
	
	[self updateScrollViewContentSize];
}

-(void)updateScrollViewContentSize
{
	self.itemSize = 
	CGSizeMake(self.bounds.size.width - 2 * self.spaceBetweenItems,
			   self.bounds.size.height);
	
	NSUInteger numberOfItems = 
		[self.delegate numberOfItemsInListView:self];
	
	CGFloat scrollViewWidth = 
		numberOfItems * self.itemSize.width + 
		self.spaceBetweenItems * numberOfItems * 2;
	self.contentSize = 
		CGSizeMake(scrollViewWidth, self.itemSize.height);	
}

-(void)updateVisiblePagesIfNeeded
{
	CGRect scrollBounds = self.bounds;
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

				break;
			}
		}
		
		if (isVisible)
		{
			continue;
		}
		
		UIView<DRScrollListViewItem>* newView = [self.delegate listView:self itemViewForIndex:i];
		[newView prepareForReuse];
				
		CGRect viewRect = CGRectMake
		((self.itemSize.width + 2 * self.spaceBetweenItems) * i + 
		 self.spaceBetweenItems,
		 scrollBounds.origin.y,
		 self.itemSize.width,
		 self.itemSize.height);

		newView.tag = i;
		newView.frame = viewRect;
		[self addSubview:newView];
		
		[visiblePages addObject:newView];
	}
}

@end
