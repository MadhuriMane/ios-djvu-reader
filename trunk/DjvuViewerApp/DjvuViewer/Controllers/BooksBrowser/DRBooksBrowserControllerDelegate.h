//
//  DRBooksBrowserControllerDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBook;
@class DRBooksBrowserViewController;

@protocol DRBooksBrowserControllerDelegate <NSObject>

@optional
-(void)booksBrowserController:(DRBooksBrowserViewController*)controller
				didSelectBook:(DRBook*)book;

@end
