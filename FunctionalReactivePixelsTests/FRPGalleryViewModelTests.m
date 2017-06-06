//
//  FRPGalleryViewModelTests.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/6/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <Specta.h>
#import <OCMock.h>
#import <RACSignal.h>

#import "FRPGalleryViewModel.h"

@interface FRPGalleryViewModel ()

- (RACSignal *)importPhotosSignal;

@end

SpecBegin(FRPGalleryViewModel)

describe(@"FRPGallerViewModel", ^{
    it(@"should be initialized and call importPhotos", ^{
        id mockObject = [OCMockObject mockForClass:[FRPGalleryViewModel class]];
        [[[mockObject expect] andReturn:[RACSignal empty]] importPhotosSignal];
        
        mockObject = [mockObject init];
        
        [mockObject verify];
        [mockObject stopMocking];
    });
});

SpecEnd
