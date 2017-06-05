//
//  FRPFullSizePhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPFullSizePhotoViewController.h"
#import "FRPFullSizePhotoViewModel.h"

#import "FRPPhotoModel.h"
#import "FRPPhotoViewController.h"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

//Private properties
@property (nonatomic, strong) UIPageViewController *pageViewController;


@end

@implementation FRPFullSizePhotoViewController

- (instancetype)init {
    
    self = [super init];
    if (!self) return nil;

    //View Controllers
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Configure selfs view
    self.view.backgroundColor = [UIColor blackColor];
    
    //Configure subviews
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
    
    //Configure child view controllers
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:self.viewModel.initialPhotoIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //Configure self
    self.title = self.viewModel.initialPhotoName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UIPageViewControllerDelegate & Datasource>

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<FRPPhotoViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index {
    if (index >= 0 && index < self.viewModel.model.count) {
        FRPPhotoModel *photoModel = self.viewModel.model[index];
        
        FRPPhotoViewController *photoViewController = [[FRPPhotoViewController alloc] initWithPhotoModel:photoModel index:index];
        return photoViewController;
    }
    
    //Index was out of bounds, return nil
    return nil;
}

@end
