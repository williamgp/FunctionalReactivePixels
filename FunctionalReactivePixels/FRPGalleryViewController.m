//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 29/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryViewFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"
#import "FRPFullSizePhotoViewController.h"

#import <RACDelegateProxy.h>

@interface FRPGalleryViewController () <FRPFullSizePhotoViewControllerDelegate>

@property (nonatomic, strong) NSArray *photosArray;

@property (nonatomic, strong) id collectionViewDelegate;

@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)init {
    FRPGalleryViewFlowLayout *flowLayout = [FRPGalleryViewFlowLayout new];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //Configure self
    self.title = @"Popular on 500px";
    
    //Configure view
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Reactive Stuff
    @weakify(self);

    RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)];
    [[viewControllerDelegate rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:) fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)] subscribeNext:^(RACTuple *value) {
        
        @strongify(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }];
    
    self.collectionViewDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
    [[self.collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple *arguments) {
        
        @strongify(self);
        FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photosArray currentPhotoIndex:[(NSIndexPath *) arguments.second item]];
        
        viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    [RACObserve(self, photosArray) subscribeNext:^(id  _Nullable x) { //returns a signal whenever photosArray is changed, completes when self is deallocated.
        
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    //Load data
    //[self loadPopularPhotos];
    
    //    RACSignal *photoSignal = [FRPPhotoImporter importPhotos];
    //    RACSignal *photosLoaded = [photoSignal catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
    //        NSLog(@"Couldnt fetch the photos from 500px %@", error);
    //        return [RACSignal empty];
    //    }];
    //    RAC(self, photosArray) = photosLoaded;
    //    [photosLoaded subscribeCompleted:^{
    //        @strongify(self);
    //        [self.collectionView reloadData];
    //    }];
    
    //clean up local variable scope
    RAC(self, photosArray) = [[[[FRPPhotoImporter importPhotos] doCompleted:^{
        @strongify(self);
        [self.collectionView reloadData];
    }] logError] catchTo:[RACSignal empty]];
}

//Abstracted to viewDidLoad
//- (void)loadPopularPhotos {
//    
//    [[FRPPhotoImporter importPhotos] subscribeNext:^(id  _Nullable x) {
//        self.photosArray = x;
//    } error:^(NSError *error) {
//        NSLog(@"Couldnt fetch photos from 500px %@", error);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setPhotoModel:self.photosArray[indexPath.row]];
    
    return cell;
}

//Abstracted to viewDidLoad
//#pragma mark <UICollectionViewDelegate>
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc]
//                                                      initWithPhotoModels:self.photosArray
//                                                      currentPhotoIndex:indexPath.item];
//
//    viewController.delegate = self;
//    [self.navigationController pushViewController:viewController animated:YES];
//}
//
//#pragma mark <FRPFullSizePhotoViewControllerDelegate>
//
//- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index {
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//}

@end
