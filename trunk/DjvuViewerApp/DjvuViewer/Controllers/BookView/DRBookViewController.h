//
//  DRBookViewController.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRBook;
@class MADjvuParser;
@class DRScrollListView;

@protocol DRBookViewControllerDelegate;

@interface DRBookViewController : UIViewController{
	
	@private
	MADjvuParser* djvuParser;
	NSUInteger pageNumber;
	NSMutableSet* visiblePages;
	NSMutableSet* reusablePages;
	UIView* currentView;
	
}

@property (nonatomic, retain, readonly) DRBook* book;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;
@property (nonatomic, assign) id<DRBookViewControllerDelegate> delegate;

- (void)loadBook:(DRBook*)aBook;

- (IBAction)showPreviousPage:(id)sender;
- (IBAction)showNextPage:(id)sender;

@end
