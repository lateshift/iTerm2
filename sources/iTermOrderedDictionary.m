//
//  iTermOrderedDictionary.m
//  iTerm2SharedARC
//
//  Created by George Nachman on 7/29/20.
//

#import "iTermOrderedDictionary.h"
#import "NSArray+iTerm.h"

@implementation iTermOrderedDictionary {
    NSArray *_orderedKeys;
    NSDictionary *_dictionary;
}

+ (instancetype)byMapping:(NSArray<id> *)array
                    block:(nullable id (^NS_NOESCAPE)(NSUInteger, id))block {
    return [self byMappingEnumerator:array.objectEnumerator block:block];
}

+ (instancetype)byMappingEnumerator:(NSEnumerator *)enumerator
                              block:(nullable id (^NS_NOESCAPE)(NSUInteger index,
                                                                id object))block {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSInteger idx = 0;
    for (id obj = enumerator.nextObject; obj; obj = enumerator.nextObject) {
        id mapped = block(idx, obj);
        if (!mapped) {
            continue;
        }
        [keys addObject:mapped];
        dictionary[mapped] = obj;
        idx += 1;
    };
    return [[self alloc] initWithArray:keys dictionary:dictionary];
}


- (instancetype)initWithArray:(NSArray *)array dictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _orderedKeys = array;
        _dictionary = dictionary;
    }
    return self;
}

- (NSArray *)keys {
    return _orderedKeys;
}

- (NSArray *)values {
    return [_orderedKeys mapWithBlock:^id(id anObject) {
        return _dictionary[anObject];
    }];
}

- (nullable id)objectForKeyedSubscript:(id)key {
    return _dictionary[key];
}

@end
