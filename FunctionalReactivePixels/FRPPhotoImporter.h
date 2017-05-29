//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 30/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject

+ (RACSignal *)importPhotos;

+ (RACReplaySubject *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

@end
