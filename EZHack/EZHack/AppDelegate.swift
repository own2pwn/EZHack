//
//  AppDelegate.swift
//  EZHack
//
//  Created by supreme on 20/04/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import GooglePlaces
import NMAKit
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        Logger.setupLogging()
        GMSPlacesClient.provideAPIKey("AIzaSyAhE7VMP3oybjetIhBqEk-WLJCN-5HYacE")

        let kHelloMapAppID = "oVoygvHFAOy0GkmQVPff"
        let kHelloMapAppCode = "6sgXHXciiUyp9WDPwEN36A"
        let kHelloMapLicenseKey = "N+Ge0LFCE13B6QopX9IviDtuNix7yb0VtIt+uXwQKQILscfwdcQ3qn8Dfgwl6rPXhYh2Vwx4kPmnff1NfEAj7U6kQ1z+N6A/0WoxtU2it8gsnTAlIGj+wlN+tlQJFAhzcOvwJzl437eGE2ya5YPzWDEk5zJ+gFnNKusgsB+0Ae42itV3RCrLAXePLwBlTleat9FuNe+PDgXNuwzE/+N+KkuOkOCvaTnO9OxTgKfIYnrTTaXUqPgKrh4GQx7TjAnUfwlfMNHNBe+RXRlkiFoNdqFgZk67VeH36XCafMLTEa6cNZAmeKv6BUfC1deOFav2bTTwExy17RXGwMSEINg+xqZ/ujHvsyIwOCk0xVl3H1ZKfys6Qp18SpqbaSuAC+HfFDQf3O3JDolFuNXepIuq7/bYS3HMCKVd2U/nwZ/rqrOfXK7tS8B/KEcQSUWV+zt5Whbl8SM/0BYCT1P2xlvTETBAxDHxKoHHutmUUXu4P7d7Ohq44PYt8Erl9k08e6oR5gO5r60PhyPJIVGzQ7NAoS+msQYPM16MgocvpKkxgRsd5z3/AlAjHMRxz3JaH36SKafmnXPuTgsvQAqqjtDi92NtqTKM393D2i2byXpkRNPrYR9hgdg7+W8ckKrRJ52Ka3ICk3JD7Y6R0OxvutDQdn+giSK2ytr68sZndZC3Iqc="

        let result = NMAApplicationContext.setAppId(kHelloMapAppID, appCode: kHelloMapAppCode, licenseKey: kHelloMapLicenseKey)

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
