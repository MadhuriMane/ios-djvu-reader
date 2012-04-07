//
//  DRBookViewControllerDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBookViewController;

@protocol DRBookViewControllerDelegate <NSObject>

-(void)bookViewControllerDidFinish:(DRBookViewController*)controller;

@end
