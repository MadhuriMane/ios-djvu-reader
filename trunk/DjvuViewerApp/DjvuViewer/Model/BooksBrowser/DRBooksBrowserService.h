//
//  DRBooksBrowserService.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRCachedBooksService;

@protocol DRBooksBrowserServiceDelegate;

@interface DRBooksBrowserService : NSObject {
	
	@private
	NSArray* books;
	DRCachedBooksService* serv;
	
}

@property(nonatomic, assign) id<DRBooksBrowserServiceDelegate> delegate;

@property(nonatomic, readonly) NSArray* books;

-(void)startUpdating;

-(void)syncCache:(NSArray*)books;

@end
