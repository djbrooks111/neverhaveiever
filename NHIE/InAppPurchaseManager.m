//
//  InAppPurchaseManager.m
//  NHIE
//
//  Created by David Brooks on 12/31/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "InAppPurchaseManager.h"

#define kInAppPurchaseProUpgradeProductId @"removeAds"



@implementation InAppPurchaseManager

-(void)requestProUpgradeProductData {
    NSLog(@"Getting Product");
    NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [products firstObject]: nil;
    if (proUpgradeProduct) {
        NSLog(@"Product title: %@", proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@", proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@", proUpgradeProduct.price);
        NSLog(@"Product id: %@", proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product id: %@", invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma -
#pragma Public methods

// Call this method once on startup
-(void)loadStore {
    NSLog(@"Loading Store");
    
    // Restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // Get the product description
    [self requestProUpgradeProductData];
}

// Call this before making a purchase
-(BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

// Kick off the upgrade transaction
-(void)purchaseProUpgrade {
    NSLog(@"Purchasing Product");
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// Restores previously purchses products
-(void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma -
#pragma Purchase helpers

// Saves a record of the transaction by storing the receipt to disk
-(void)recordTransaction:(SKPaymentTransaction *)transaction {
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId]) {
        // Save the transaction recipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// Enable pro features
-(void)provideContent:(NSString *)productID {
    if ([productID isEqualToString:kInAppPurchaseProUpgradeProductId]) {
        // Enable pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// Removes the trasaction from the queue and posts a notification with the transaction result
-(void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful {
    // Remove the transaction from the payment queue
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil];
    if (wasSuccessful) {
        // Send out a notification that we've finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    } else {
        // Send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

// Called when the transaction was successful
-(void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// Called when a transaction has been restored and successfully completed
-(void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// Called when a trasaction has failed
-(void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    } else {
        // User cancelled
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

// Called when the transaction status is updated
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

@end
