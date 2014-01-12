//
//  RJSymbolTable.m
//  Lisp
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJSymbolTable.h"
#import "RJSymbol.h"

@interface RJSymbolTable ()

@property (nonatomic, strong) NSMutableDictionary *table;

@end

@implementation RJSymbolTable

- (instancetype)init
{
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key
{
    if (!self.table[key]) {
        self.table[key] = [RJSymbol symbolWithName:key];
    }
    return self.table[key];
}

@end
