//
//  RJPrimitiveProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJPrimitiveProcedure.h"

@interface RJPrimitiveProcedure ()

@property (nonatomic, strong) NSString *name;

@end

@implementation RJPrimitiveProcedure

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    return nil;
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"#<Function %@>", self.name];
}

@end
