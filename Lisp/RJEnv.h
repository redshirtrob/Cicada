//
//  RJEnv.h
//  Lisp
//
//  Created by Robert Jones on 1/9/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^lambda)(NSArray *);

@interface RJEnv : NSObject

- (id)initWithParameters:(NSArray *)parameters values:(NSArray *)values outerEnvironment:(id)outerEnvironment;
- (instancetype)find:(id)aKey;
- (void)initialize;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey;

@end
