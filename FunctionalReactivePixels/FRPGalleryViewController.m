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
#import "FRPFullSizePhotoViewModel.h"

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
        FRPFullSizePhotoViewModel *viewModel = [[FRPFullSizePhotoViewModel alloc] initWithPhotoArray:self.viewModel.model initialPhotoIndex:indexPath.item];
        
        FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] init];
        
        viewController.viewModel = viewModel;
        viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    self.collectionView.delegate = self.collectionViewDelegate;
    
    [RACObserve(self, photosArray) subscribeNext:^(id  _Nullable x) { //returns a signal whenever photosArray is changed, completes when self is deallocated.
        
        @strongify(self);
        [self.collectionView reloadData];
    }];

    RAC(self, photosArray) = [[[[FRPPhotoImporter importPhotos] doCompleted:^{
        @strongify(self);
        [self.collectionView reloadData];
    }] logError] catchTo:[RACSignal empty]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
