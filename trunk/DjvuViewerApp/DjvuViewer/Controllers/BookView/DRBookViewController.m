//
//  DRBookViewController.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBookViewController.h"

#import "DRBook.h"
#import "DRThemeInfo.h"
#import "MADjvuParser.h"
#import "DRImageScrollView.h"
#import "DRScrollListView.h"
#import "DRBookViewControllerDelegate.h"

static const CGFloat DRBookViewControllerPageWidth = 728;

@interface DRBookViewController()

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet DRScrollListView* listView;
@property(nonatomic, retain) DRBook* book;

-(IBAction)swipeAction:(id)sender;

-(void)configureNavigationItem;
-(void)loadCurrentBook;
-(void)updateVisiblePagesIfNeeded;
-(void)updateScrollViewContentSize;

@end

@implementation DRBookViewController

-(id)init
{
	return [self initWithNibName:@"DRBookViewController" bundle:nil];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		pageNumber = 0;
		djvuParser = nil;
		currentView = nil;
		visiblePages = [NSMutableSet new];
		reusablePages = [NSMutableSet new];
	}
	return self;
}

- (void)dealloc
{
	self.book = nil;
	[djvuParser release];
	[reusablePages release];
	[visiblePages release];
	[super dealloc];
}

#pragma mark -
#pragma mark properties

@synthesize imageView, navigationBar, delegate;
@synthesize book, scrollView, listView;

#pragma mark -
#pragma mark public

- (void)loadBook:(DRBook*)aBook
{
	if (book != aBook)
	{
		self.book = aBook;
		pageNumber = 0;
		[self loadCurrentBook];
	}
}

#pragma mark -
#pragma mark actions

- (IBAction)showPreviousPage:(id)sender
{
	pageNumber--;
	[self updatePage];
}

- (IBAction)showNextPage:(id)sender
{
	pageNumber++;
	[self updatePage];
}

-(IBAction)swipeAction:(id)sender
{
	pageNumber++;
	[self updatePage];
}

-(IBAction)pinchAction:(id)sender
{
	NSLog(@"pinch");
	self.scrollView.zoomScale = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	//http://code.autistici.org/svn/fim/trunk/src/FbiStuffDjvu.cpp
	[super viewDidLoad];
	[self configureNavigationItem];
	
	self.view.backgroundColor = [DRThemeInfo scrollViewBackground];
	
	[self updateScrollViewContentSize];
	self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
	
	//[self updateVisiblePagesIfNeeded];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark actions

-(void)collectionAction:(id)sender
{
	[self.delegate bookViewControllerDidFinish:self];
}

#pragma mark -
#pragma mark DRScrollListViewDelegate

-(NSUInteger)numberOfItemsInListView:(DRScrollListView*)listView
{
	return djvuParser.numberOfPages;
}

-(UIView<DRScrollListViewItem>*)listView:(DRScrollListView*)aListView itemViewForIndex:(NSUInteger)index
{
	DRImageScrollView *itemView = 
		(DRImageScrollView*)[aListView dequeueReusableItem];
	if (itemView == nil)
	{
		itemView = [[DRImageScrollView new]autorelease];
	}
	
	itemView.imageView.image = 
	[djvuParser imageForPage:index
					  ofSize:CGSizeZero];
	
	return itemView;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//[self updateVisiblePagesIfNeeded];
}

#pragma mark -
#pragma mark private

-(void)configureNavigationItem
{
	self.navigationItem.title = self.book.title;
	self.navigationItem.leftBarButtonItem = 
	[[[UIBarButtonItem alloc] initWithTitle:@"Collection"
									  style:UIBarButtonItemStyleBordered
									 target:self
									 action:@selector(collectionAction:)]
	 autorelease];
	
	[self.navigationBar pushNavigationItem:self.navigationItem
								  animated:NO];
}
	 
-(void)loadCurrentBook
{
	//TODO: check is parser working
	[djvuParser release];
	djvuParser = [[MADjvuParser alloc]initWithPath:self.book.path];
	[self updateScrollViewContentSize];
}

- (void) updatePage
{
	//http://wdnuon.blogspot.com/2010/05/implementing-ibooks-page-curling-using.html
	UIImage* img = [djvuParser imageForPage:pageNumber ofSize:CGSizeMake(1024, 768)];
	self.imageView.image = img;
}
	 
-(void)updateVisiblePagesIfNeeded
{
	CGRect scrollBounds = self.scrollView.bounds;
	int firstVisiblePageIndex = floorf(CGRectGetMinX(scrollBounds) / CGRectGetWidth(scrollBounds));
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
		viewRect.origin.x = i * DRBookViewControllerPageWidth;
		
		newImageView.tag = i;
		newImageView.frame = viewRect;
		newImageView.imageView.image = 
		[djvuParser imageForPage:i
						  ofSize:CGSizeZero];
		[self.scrollView addSubview:newImageView];
		[visiblePages addObject:newImageView];
		
		if (i == firstVisiblePageIndex)
			currentView = newImageView;
	}
}

-(void)updateScrollViewContentSize
{
	if (!self.scrollView)
		return;
	CGFloat scrollViewWidth = djvuParser.numberOfPages * 
		DRBookViewControllerPageWidth;
	self.scrollView.contentSize = 
	CGSizeMake(scrollViewWidth, self.view.frame.size.height);	
}

@end
