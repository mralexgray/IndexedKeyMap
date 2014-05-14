//
//  IndexedKeyMapTests.m
//  IndexedKeyMapTests
//
//  Created by Alex Gray on 5/13/14.
//  Copyright (c) 2014 Alex Gray. All rights reserved.
//
@import Cocoa;
#import <SenTestingKit/SenTestingKit.h>
#import <IndexedKeyMap.h>

@interface IndexedKeyMapTests : SenTestCase
@property       IndexedKeyMap * kmap;
@end

@implementation IndexedKeyMapTests

- (void)setUp { [super setUp]; _kmap = IndexedKeyMapExample; STAssertNotNil(_kmap, @"Empty map!"); }

- (void)testReads {

  STAssertNotNil(_kmap, @"Empty map! for \"%s\"", __PRETTY_FUNCTION__);
}

@end
