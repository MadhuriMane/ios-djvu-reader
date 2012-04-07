//
//  MADjvuParser.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct MADjvuParserContext MADjvuParserContext;

@interface MADjvuParser : NSObject
{
    NSString *filePath;
    MADjvuParserContext *context;
    
}

- (id) initWithPath:(NSString*)path;

@property(nonatomic, assign, readonly) NSUInteger numberOfPages;

- (UIImage*)imageForPage:(NSUInteger)page;
- (UIImage*)imageForPage:(NSUInteger)page ofSize:(CGSize)size;

@end
