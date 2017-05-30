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

+ (RACSignal *)importPhotos {
    
    NSURLRequest *request = [self popularURLRequest];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *reponse, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return [[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
            
            FRPPhotoModel *model = [FRPPhotoModel new];
            
            [self configurePhotoModel:model withDictionary:photoDictionary];
            [self downloadThumbnailForPhotoModel:model];
            
            return model;
        }] array];
    }] publish] autoconnect];
}

+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel {
   
    NSURLRequest *request = [self photoURLRequest:photoModel];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photo"];
        
        [self configurePhotoModel:photoModel withDictionary:results];
        [self downloadFullSizedImageForPhotoModel:photoModel];
        
        return photoModel;
    }] publish] autoconnect];
}

+ (NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel {
    return [AppDelegate.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+ (NSURLRequest *)popularURLRequest {

    return [AppDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}

+ (void)configurePhotoModel:(FRPPhotoModel *)photoModel withDictionary:(NSDictionary *)dictionary {
    
    //Basic details fetched with the first basic request
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    
    photoModel.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
    
    //Extend attributes fetched with subsequent request
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
    }
}

+ (NSString *)urlForImageSize:(NSInteger)size inArray:(NSArray *)array {
    
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size; //filter out dictionaries whose size doesnt match our size param
    }] map:^id(id value) {
        return value[@"url"]; //use map: to extract the url value of the dictionaries
    }] array] firstObject]; //Get a sequence of strings, turn back into array, and return the first object. Implicit error handling: firstObject returns nil if sequence is empty
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel {
    
    RAC(photoModel, thumbnailData) = [self download:photoModel.thumbnailURL];
}

+ (void)downloadFullSizedImageForPhotoModel:(FRPPhotoModel *)photoModel {
    
    RAC(photoModel, fullsizedData) = [self download:photoModel.fullsizedURL];
}

+ (RACSignal *)download:(NSString *)urlString {
    
    NSAssert(urlString, @"Thumbnail URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
