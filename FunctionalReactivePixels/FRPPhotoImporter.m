//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 30/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+ (RACReplaySubject *)importPhotos {
    RACReplaySubject * subject = [RACReplaySubject subject];
    
    NSURLRequest *request = [self popularURLRequest];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
                
                FRPPhotoModel *model = [FRPPhotoModel new];
                
                [self configurePhotoModel:model withDictionary:photoDictionary];
                
                [self downloadThumbnailForPhotoModel:model];
                
                return model;
            
            }] array]];
            
            [subject sendCompleted];
        } else {
            [subject sendError:connectionError];
        }
    }];
    
    return subject;
}

- (NSURLRequest *)popularURLRequest {
    
}

@end
