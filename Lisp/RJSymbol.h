//
//  RJSymbol.h
//  Lisp
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJSymbol : NSObject

@property (nonatomic, strong) NSString *name;

+ (id)symbolWithName:(NSString *)name;

@end
