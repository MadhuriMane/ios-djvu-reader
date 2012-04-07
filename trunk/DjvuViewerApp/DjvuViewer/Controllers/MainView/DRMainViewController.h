//
//  DRMainViewController.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBook;
@class DRBookViewController;
@class DRBooksBrowserViewController;

@interface DRMainViewController : UIViewController
{
	@private
	BOOL isBooksBrowserViewActive;
	BOOL isBookViewActive;
	DRBooksBrowserViewController* booksBrowserController;
	DRBookViewController* bookController;
}

+(id)mainViewController;

-(void)showBooksBrowserAnimated:(BOOL)animated;

-(void)showBook:(DRBook*)book animated:(BOOL)animated;

@end
