//
//  RKSearchIndexerTest.m
//  RestKit
//
//  Created by Blake Watters on 7/30/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKTestEnvironment.h"
#import "RKSearchIndexer.h"
#import "RKSearchWordEntity.h"

@interface RKSearchIndexer ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@interface RKSearchIndexerTest : RKTestCase

@end

@implementation RKSearchIndexerTest

- (void)testAddingSearchIndexingToEntity
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    NSEntityDescription *searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(nilValue()));
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    // Check that the entity now exists
    searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(notNilValue()));
    
    // Check that Human now has a searchWords relationship
    NSRelationshipDescription *searchWordsRelationship = [[entity relationshipsByName] objectForKey:@"searchWords"];
    assertThat(searchWordsRelationship, is(notNilValue()));
    
    // Check that RKSearchWord now has a RKHuman inverse
    NSRelationshipDescription *humanInverse = [[searchWordEntity relationshipsByName] objectForKey:@"Human"];
    assertThat(humanInverse, is(notNilValue()));
    assertThat([humanInverse inverseRelationship], is(equalTo(searchWordsRelationship)));
    assertThat([searchWordsRelationship inverseRelationship], is(equalTo(humanInverse)));
    
    // Check the userInfo of the Human entity for the searchable attributes
    NSArray *attributes = [entity.userInfo objectForKey:RKSearchableAttributeNamesUserInfoKey];
    assertThat(attributes, is(equalTo(@[ @"name", @"nickName" ])));
}

- (void)testAddingSearchIndexingToEntityWithMixtureOfNSAttributeDescriptionAndStringNames
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    NSEntityDescription *searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(nilValue()));
    NSAttributeDescription *nickNameAttribute = [entity.attributesByName objectForKey:@"nickName"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", nickNameAttribute ]];
    
    // Check that the entity now exists
    searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(notNilValue()));
    
    // Check that Human now has a searchWords relationship
    NSRelationshipDescription *searchWordsRelationship = [[entity relationshipsByName] objectForKey:@"searchWords"];
    assertThat(searchWordsRelationship, is(notNilValue()));
    
    // Check that RKSearchWord now has a RKHuman inverse
    NSRelationshipDescription *humanInverse = [[searchWordEntity relationshipsByName] objectForKey:@"Human"];
    assertThat(humanInverse, is(notNilValue()));
    assertThat([humanInverse inverseRelationship], is(equalTo(searchWordsRelationship)));
    assertThat([searchWordsRelationship inverseRelationship], is(equalTo(humanInverse)));
    
    // Check the userInfo of the Human entity for the searchable attributes
    NSArray *attributes = [entity.userInfo objectForKey:RKSearchableAttributeNamesUserInfoKey];
    assertThat(attributes, is(equalTo(@[ @"name", @"nickName" ])));
}

- (void)testAddingSearchIndexingToNonStringAttributeTypeRaisesException
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    NSEntityDescription *searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(nilValue()));
    
    NSException *exception = nil;
    @try {
        [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"railsID" ]];
    }
    @catch (NSException *e) {
        exception = e;
    }
    @finally {
        assertThat(exception, is(notNilValue()));
        assertThat(exception.reason, containsString(@"Invalid attribute identifier given: Expected an attribute of type NSStringAttributeType, got 200."));
    }
}

- (void)testAddingSearchIndexingToNonExistantAttributeRaisesException
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    NSEntityDescription *searchWordEntity = [managedObjectModel.entitiesByName objectForKey:@"RKSearchWord"];
    assertThat(searchWordEntity, is(nilValue()));
    
    NSException *exception = nil;
    @try {
        [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"doesNotExist" ]];
    }
    @catch (NSException *e) {
        exception = e;
    }
    @finally {
        assertThat(exception, is(notNilValue()));
        assertThat(exception.reason, containsString(@"Invalid attribute identifier given: No attribute with the name 'doesNotExist' found in the 'Human' entity."));
    }
}

- (void)testAddingSearchIndexingToTwoEntitiesManipulatesTheSameSearchWordEntity
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *humanEntity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    NSEntityDescription *catEntity = [[managedObjectModel entitiesByName] objectForKey:@"Cat"];

    [RKSearchIndexer addSearchIndexingToEntity:humanEntity
                      onAttributes:@[ @"name", @"nickName" ]];
    [RKSearchIndexer addSearchIndexingToEntity:catEntity
                      onAttributes:@[ @"name", @"nickName" ]];

    NSEntityDescription *searchWordEntity = [[managedObjectModel entitiesByName] objectForKey:RKSearchWordEntityName];
    
    NSRelationshipDescription *humanRelationship = [[searchWordEntity relationshipsByName] objectForKey:@"Human"];
    assertThat(humanRelationship, is(notNilValue()));
    NSRelationshipDescription *catRelationship = [[searchWordEntity relationshipsByName] objectForKey:@"Cat"];
    assertThat(catRelationship, is(notNilValue()));
}

- (void)testIndexingManagedObject
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
        
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    NSUInteger count = [indexer indexManagedObject:human];
    assertThatInteger(count, is(equalToInteger(3)));
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    
    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));
}

- (void)testIndexingManagedObjectUsingIndexingContext
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

    NSManagedObjectContext *indexingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [indexingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:indexingContext queue:nil usingBlock:^(NSNotification *notification) {
        [managedObjectContext performBlock:^{
            [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }];

    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    indexer.indexingContext = indexingContext;
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];

    NSUInteger count = [indexer indexManagedObject:human];
    assertThatInteger(count, is(equalToInteger(3)));
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];

    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));
}

- (void)testIndexingOnManagedObjectContextSave
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    // Index on save
    [indexer startObservingManagedObjectContext:managedObjectContext];
    [managedObjectContext save:&error];
    
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));
    
    [indexer stopObservingManagedObjectContext:managedObjectContext];
}

- (void)testIndexingOnManagedObjectContextSaveUsingIndexingContext
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

    NSManagedObjectContext *indexingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [indexingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:indexingContext queue:nil usingBlock:^(NSNotification *notification) {
        [managedObjectContext performBlock:^{
            [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }];

    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    indexer.indexingContext = indexingContext;
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];

    // Index on save
    [indexer startObservingManagedObjectContext:managedObjectContext];
    [managedObjectContext save:&error];

    // Spin the run loop to allow the did save notifications to propogate
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];

    [managedObjectContext refreshObject:human mergeChanges:YES];
    NSManagedObjectID *objectID = [human objectID];
    [managedObjectContext reset];
    human = [managedObjectContext existingObjectWithID:objectID error:nil];

    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));

    [indexer stopObservingManagedObjectContext:managedObjectContext];
}

- (void)testIndexingChangesInManagedObjectContextWithoutSave
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    // Index the current changes
    [indexer indexChangedObjectsInManagedObjectContext:managedObjectContext waitUntilFinished:YES];
    
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));
    
}

- (void)testIndexingChangesInManagedObjectContextWithoutSaveUsingIndexingContext
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

    NSManagedObjectContext *indexingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [indexingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:indexingContext queue:nil usingBlock:^(NSNotification *notification) {
        [managedObjectContext performBlock:^{
            [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }];

    RKSearchIndexer *indexer = [RKSearchIndexer new];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    indexer.indexingContext = indexingContext;
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];

    // Index the current changes
    [indexer indexChangedObjectsInManagedObjectContext:managedObjectContext waitUntilFinished:YES];

    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    assertThat([searchWords valueForKey:@"word"],
               is(equalTo([NSSet setWithArray:@[ @"this", @"my", @"name" ]])));
}

- (void)testCancellationOfIndexingInAnIndexingContext
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    NSManagedObjectContext *indexingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [indexingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:indexingContext queue:nil usingBlock:^(NSNotification *notification) {
        [managedObjectContext performBlock:^{
            [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }];
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    [indexer.operationQueue setSuspended:YES];
    indexer.stopWords = [NSSet setWithObject:@"is"];
    indexer.indexingContext = indexingContext;
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    // Index the current changes
    [indexer indexChangedObjectsInManagedObjectContext:managedObjectContext waitUntilFinished:NO];
    
    assertThat([indexer.operationQueue operations], hasCountOf(1));
    NSArray *operations = indexer.operationQueue.operations;
    assertThatBool([operations[0] isCancelled], is(equalToBool(NO)));
    [indexer cancelAllIndexingOperations];
    assertThatBool([operations[0] isCancelled], is(equalToBool(YES)));
    
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    assertThat([searchWords valueForKey:@"word"], is(empty()));
}

#pragma mark - Delegate Tests

- (void)testThatDelegateCanDenyCreationOfSearchWordForWord
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

    RKSearchIndexer *indexer = [RKSearchIndexer new];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RKSearchIndexerDelegate)];
    BOOL returnValue = NO;
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:OCMOCK_ANY shouldInsertSearchWordForWord:@"this" inManagedObjectContext:managedObjectContext];
    returnValue = YES;
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:OCMOCK_ANY shouldInsertSearchWordForWord:@"my" inManagedObjectContext:managedObjectContext];
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:OCMOCK_ANY shouldInsertSearchWordForWord:@"name" inManagedObjectContext:managedObjectContext];
    indexer.delegate = mockDelegate;
     
    NSUInteger count = [indexer indexManagedObject:human];
    expect(count).to.equal(2);
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];

    NSSet *expectedSet = [NSSet setWithArray:@[ @"my", @"name" ]];
    expect([searchWords valueForKey:@"word"]).to.equal(expectedSet);
    [mockDelegate verify];
}

- (void)testThatDelegateIsInformedWhenSearchWordIsCreated
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RKSearchIndexerDelegate)];
    BOOL returnValue = YES;
    [[[mockDelegate stub] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:indexer shouldInsertSearchWordForWord:OCMOCK_ANY inManagedObjectContext:OCMOCK_ANY];
    [[mockDelegate expect] searchIndexer:indexer didInsertSearchWord:OCMOCK_ANY forWord:@"this" inManagedObjectContext:managedObjectContext];
    [[mockDelegate expect] searchIndexer:indexer didInsertSearchWord:OCMOCK_ANY forWord:@"is" inManagedObjectContext:managedObjectContext];
    [[mockDelegate expect] searchIndexer:indexer didInsertSearchWord:OCMOCK_ANY forWord:@"my" inManagedObjectContext:managedObjectContext];
    [[mockDelegate expect] searchIndexer:indexer didInsertSearchWord:OCMOCK_ANY forWord:@"name" inManagedObjectContext:managedObjectContext];
    indexer.delegate = mockDelegate;
    
    [indexer indexManagedObject:human];
    [mockDelegate verify];
}

- (void)testThatDelegateCanBeUsedToFetchExistingSearchWords
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RKSearchIndexerDelegate)];
    BOOL returnValue = NO;
    RKSearchWord *searchWord = [NSEntityDescription insertNewObjectForEntityForName:@"RKSearchWord" inManagedObjectContext:managedObjectContext];
    [[[mockDelegate expect] andReturn:searchWord] searchIndexer:indexer searchWordForWord:@"this" inManagedObjectContext:managedObjectContext error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
    [[[mockDelegate expect] andReturn:searchWord] searchIndexer:indexer searchWordForWord:@"is" inManagedObjectContext:managedObjectContext error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
    [[[mockDelegate expect] andReturn:searchWord] searchIndexer:indexer searchWordForWord:@"my" inManagedObjectContext:managedObjectContext error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
    [[[mockDelegate expect] andReturn:searchWord] searchIndexer:indexer searchWordForWord:@"name" inManagedObjectContext:managedObjectContext error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
    [[[mockDelegate stub] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:indexer shouldInsertSearchWordForWord:OCMOCK_ANY inManagedObjectContext:OCMOCK_ANY];
    [[mockDelegate reject] searchIndexer:indexer didInsertSearchWord:OCMOCK_ANY forWord:OCMOCK_ANY inManagedObjectContext:OCMOCK_ANY];
    indexer.delegate = mockDelegate;
    
    [indexer indexManagedObject:human];
    [mockDelegate verify];
}

- (void)testThatTheDelegateCanDeclineIndexingOfAnObject
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RKSearchIndexerDelegate)];
    BOOL returnValue = NO;
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(returnValue)] searchIndexer:indexer shouldIndexManagedObject:human];
    indexer.delegate = mockDelegate;
    
    [indexer indexChangedObjectsInManagedObjectContext:managedObjectContext waitUntilFinished:YES];
    [mockDelegate verify];
    NSSet *searchWords = [human valueForKey:RKSearchWordsRelationshipName];
    expect([searchWords valueForKey:@"word"]).to.beEmpty();
}

- (void)testThatTheDelegateIsNotifiedAfterIndexingHasCompleted
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:@"Human"];
    [RKSearchIndexer addSearchIndexingToEntity:entity onAttributes:@[ @"name", @"nickName" ]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    RKSearchIndexer *indexer = [RKSearchIndexer new];
    NSManagedObject *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectContext];
    [human setValue:@"This is my name" forKey:@"name"];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RKSearchIndexerDelegate)];
    [[mockDelegate expect] searchIndexer:indexer didIndexManagedObject:human];
    indexer.delegate = mockDelegate;
    [indexer indexManagedObject:human];
    [mockDelegate verify];
}

@end
