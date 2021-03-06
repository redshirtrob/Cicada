//
//  RJProcedure.h
//  Cicada
//
//  Created by Robert Jones on 1/26/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJEnv;
@class RJScheme;

@interface RJProcedure : NSObject

@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) id expression;
@property (nonatomic, strong) RJEnv *environment;

- (instancetype)initWithParameters:(NSArray *)parameters expression:(id)expression environment:(RJEnv *)environment repl:(RJScheme *)repl;
- (id)evalWithValues:(NSArray *)values error:(NSError **)error;

@end
