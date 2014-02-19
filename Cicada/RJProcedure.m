//
//  RJProcedure.m
//  Cicada
//
//  Created by Robert Jones on 1/26/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJProcedure.h"
#import "RJScheme.h"
#import "RJEnv.h"

@interface RJProcedure ()

@property (nonatomic, strong) RJScheme *repl;

@end

@implementation RJProcedure

- (instancetype)initWithParameters:(NSArray *)parameters expression:(id)expression environment:(RJEnv *)environment repl:(RJScheme *)repl
{
    self = [super init];
    if (self) {
        _parameters = parameters;
        _expression = expression;
        _environment = environment;
        _repl = repl;
    }
    return self;
}

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    RJEnv *evalEnv = [[RJEnv alloc] initWithParameters:self.parameters values:values outerEnvironment:self.environment];
    return [self.repl eval:self.expression environment:evalEnv error:error];
}

- (NSString *)stringValue
{
    return [self description];
}

@end
