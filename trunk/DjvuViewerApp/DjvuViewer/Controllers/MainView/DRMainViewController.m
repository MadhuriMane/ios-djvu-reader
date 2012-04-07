//
//  DRMainViewController.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRMainViewController.h"

#import "DRBook.h"
#import "CUSafeRelease.h"
#import "DRBookViewController.h"
#import "DRBookViewControllerDelegate.h"
#import "DRBooksBrowserViewController.h"
#import "DRBooksBrowserControllerDelegate.h"

static const NSString * kDRMainViewController_ShowBookViewAnimationName =
	@"kDRMainViewController_ShowBookViewAnimationName";

static const NSString * kDRMainViewController_ShowBooksBrowserAnimationName =
	@"kDRMainViewController_ShowBooksBrowserAnimationName";

@interface DRMainViewController()<DRBooksBrowserControllerDelegate, DRBookViewControllerDelegate>

-(void)showDefaultView;

@end

@implementation DRMainViewController

+(id)mainViewController
{
	return [[[DRMainViewController alloc] init] autorelease];
}

-(void)dealloc
{
	[booksBrowserController release];
	[bookController release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self showDefaultView];
}

-(void)didReceiveMemoryWarning
{
	if (!isBooksBrowserViewActive)
	{
		[booksBrowserController.view removeFromSuperview];
		RELEASE_AND_NIL(booksBrowserController);
	}
	if (!isBookViewActive)
	{
		[bookController.view removeFromSuperview];
		RELEASE_AND_NIL(bookController);
	}

	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark public

-(void)showBooksBrowserAnimated:(BOOL)animated
{
	if (booksBrowserController == nil)
	{
		booksBrowserController = [DRBooksBrowserViewController new];
		booksBrowserController.delegate = self;
	}
	
	[bookController.view removeFromSuperview];
	
	booksBrowserController.view.alpha = 0;
	
	if (animated)
	{
		[UIView beginAnimations:(NSString*)kDRMainViewController_ShowBooksBrowserAnimationName
						context:NULL];
		[UIView setAnimationDuration:1];
	}
	
	[self.view addSubview:booksBrowserController.view];
	
	booksBrowserController.view.frame = self.view.bounds;
	booksBrowserController.view.alpha = 1;
	
	if (animated)
	{
		[UIView commitAnimations];
	}
	
	booksBrowserController.view.frame = self.view.bounds;
	isBooksBrowserViewActive = YES;
	isBookViewActive = NO;
}

-(void)showBook:(DRBook*)book animated:(BOOL)animated
{
	if (bookController == nil)
	{
		bookController = [DRBookViewController new];
		bookController.delegate = self;
	}
	
	[booksBrowserController.view removeFromSuperview];
	
	[bookController loadBook:book];
	
	bookController.view.alpha = 0;
	
	if (animated)
	{
		[UIView beginAnimations:(NSString*)kDRMainViewController_ShowBookViewAnimationName
						context:NULL];
		[UIView setAnimationDuration:1];
	}
	
	[self.view addSubview:bookController.view];
	bookController.view.frame = self.view.bounds;
	bookController.view.alpha = 1;
	
	if (animated)
	{
		[UIView commitAnimations];
	}
	isBooksBrowserViewActive = NO;
	isBookViewActive = YES;
}

#pragma mark -
#pragma mark DRBooksBrowserControllerDelegate

-(void)booksBrowserController:(DRBooksBrowserViewController*)controller
				didSelectBook:(DRBook*)book
{
	[self showBook:book animated:YES];
}

#pragma mark -
#pragma mark DRBookViewControllerDelegate

-(void)bookViewControllerDidFinish:(DRBookViewController*)controller
{
	[self showBooksBrowserAnimated:YES];
}

#pragma mark -
#pragma mark private

-(void)showDefaultView
{
	[self showBooksBrowserAnimated:YES];
}

@end
