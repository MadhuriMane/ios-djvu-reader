//
//  DRImageScrollView.m
//  DjvuViewer
//
//  Created by Alex Martynov on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRImageScrollView.h"

@interface DRImageScrollView()<UIScrollViewDelegate>

@property(nonatomic,retain) UIImageView *imageView;

@end

@implementation DRImageScrollView

-(id)initWithFrame:(CGRect)rect
{
	if (self = [super initWithFrame:rect])
	{
		self.imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
		
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.bouncesZoom = YES;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.minimumZoomScale = 1;
		self.maximumZoomScale = 8;
        self.delegate = self;
		
		[self addSubview:self.imageView];
	}
	return self;
}

- (void)dealloc
{
    self.imageView = nil;
	[super dealloc];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	self.imageView.frame = self.bounds;
	self.contentSize = CGSizeMake(self.bounds.size.width,
								  self.bounds.size.height);
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	//self.imageView.frame = self.bounds;
	
//	CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = self.imageView.frame;
//    
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//	
//	self.imageView.frame = frameToCenter;
//	
//	self.contentSize = CGSizeMake(self.bounds.size.width,
//								  self.bounds.size.height);
//	self.zoomScale = self.minimumZoomScale;
}

-(void)prepareForReuse
{
	self.imageView.frame = self.bounds;
	self.contentSize = CGSizeMake(self.bounds.size.width,
								  self.bounds.size.height);
	self.minimumZoomScale = 1;
	self.maximumZoomScale = 8;
	self.zoomScale = 1;
}

#pragma mark -
#pragma mark properties

@synthesize imageView;

#pragma mark -
#pragma mark UIScrollViewDelegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

@end
