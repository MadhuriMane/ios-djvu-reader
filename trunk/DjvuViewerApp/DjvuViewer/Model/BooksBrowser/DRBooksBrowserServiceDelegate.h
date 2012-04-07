//
//  DRBooksBrowserServiceDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBooksBrowserService;

@protocol DRBooksBrowserServiceDelegate <NSObject>

@optional
-(void)booksBrowserService:(DRBooksBrowserService*)service didUpdateToList:(NSArray*)books;

@end
