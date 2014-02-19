//
//  RJSymbol.h
//  Cicada
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJSymbol : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;

+ (instancetype)symbolWithName:(NSString *)name;

+ (instancetype)EOFSymbol;

@end
