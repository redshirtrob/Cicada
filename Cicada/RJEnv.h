//
//  RJEnv.h
//  Cicada
//
//  Created by Robert Jones on 1/9/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJEnv : NSObject

- (id)initWithParameters:(NSArray *)parameters values:(NSArray *)values outerEnvironment:(id)outerEnvironment;
- (id)find:(id)aKey;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id <NSCopying>)aKey;

@end
