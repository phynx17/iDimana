//
//  ItuDimanaAppDelegate.h
//  ItuDimana
//
//  Created by Pandu  Pradhana on 8/17/09.
//  Copyright Melati Group 2009. All rights reserved.
//

@interface ItuDimanaAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	
	/*
	 * For Core Data
	 *
	 */
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	
    UIWindow *window;
    UITabBarController *tabBarController;
	BOOL offlineMode;
	
	int currentSaved;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) BOOL offlineMode;
@property (nonatomic, assign) int currentSaved;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;


@end
