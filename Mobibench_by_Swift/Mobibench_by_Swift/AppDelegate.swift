//
//  AppDelegate.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/2/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

enum SQLError: ErrorType {
    case ConnectionError
    case QueryError
    case OtherError
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var dbName: String?
    var dbPath: String?
    var persons: NSMutableArray?
    
    func checkAndCreateDatabase() {
        let fileManager = NSFileManager.defaultManager()
        
        if !(fileManager.fileExistsAtPath(dbPath!)) {
            let dbPathFromApp = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent(dbName!)
            
            do {
                try fileManager.copyItemAtPath(dbPathFromApp, toPath: dbPath!)
            } catch {
                print("Fail!")
            }
        }
    }
    
    func readFilesFromDatabase() {
        var db: COpaquePointer = nil
        
        if persons == nil {
            persons = NSMutableArray()
        } else {
            persons!.removeAllObjects()
        }
        
        if sqlite3_open(self.dbPath!, &db) == SQLITE_OK {
            let sqlStatement = "select * from persons"
            var compiledStatement: COpaquePointer = nil
            
            if sqlite3_prepare(db, sqlStatement, -1, &compiledStatement, nil) == SQLITE_OK {
                while sqlite3_step(compiledStatement) == SQLITE_ROW {
                    let name = NSString.init(UTF8String: UnsafePointer<Int8>(sqlite3_column_text(compiledStatement, 1)))
                    let telno = NSString.init(UTF8String: UnsafePointer<Int8>(sqlite3_column_text(compiledStatement, 2)))
                    let email = NSString.init(UTF8String: UnsafePointer<Int8>(sqlite3_column_text(compiledStatement, 3)))
                    
                    let person = PersonData.init(name: name!, phoneNumber: telno!, mailAddr: email!)
                    persons!.addObject(person)
                }
            }
            sqlite3_finalize(compiledStatement)
        }
        sqlite3_close(db)
    }
    
    func insertData(name: String?, phoneNumber: String?, mailAddr: String?) {
        var db: COpaquePointer = nil
        
        if sqlite3_open(self.dbPath!, &db) == SQLITE_OK {
            let query = "insert into persons (name, telno, email) values (\(name), \(phoneNumber), \(mailAddr))"
            var error: UnsafeMutablePointer<Int8> = nil
            
            if sqlite3_exec(db, query, nil, nil, &error) != SQLITE_OK {
                print(error)
            }
        }
        sqlite3_close(db)
        
        self.readFilesFromDatabase()
    }
    
    func updateData(name: String?, phoneNumber: String?, mailAddr: String?, oldName: String) {
        var db: COpaquePointer = nil
        
        if sqlite3_open(self.dbPath!, &db) == SQLITE_OK {
            let query = "update persons sets name = \(name), telno = \(phoneNumber), email = \(mailAddr)" +
                "where name = \(oldName)"
            var error: UnsafeMutablePointer<Int8> = nil
            
            if sqlite3_exec(db, query, nil, nil, &error) != SQLITE_OK {
                print(error)
            }
        }
        sqlite3_close(db)
        
        self.readFilesFromDatabase()
    }
    
    func deleteData(name: String?, phoneNumber: String?, mailAddr: String?) {
        var db: COpaquePointer = nil
        
        if sqlite3_open(self.dbPath!, &db) == SQLITE_OK {
            let query = "delete from persons where"
            var error: UnsafeMutablePointer<Int8> = nil
            
            if sqlite3_exec(db, query, nil, nil, &error) != SQLITE_OK {
                print(error)
            }
        }
        sqlite3_close(db)
        
        self.readFilesFromDatabase()
    }
    
    //    func journalGet() -> String {
    //        var db: COpaquePointer = nil
    //        var query2: UnsafeMutablePointer<UnsafeMutablePointer<Int8>> = nil
    //
    //        if sqlite3_open(dbPath!, &db) == SQLITE_OK {
    //            let query = "pragma journal_mode;"
    //            let row: UnsafeMutablePointer<Int32> = nil
    //            let column: UnsafeMutablePointer<Int32> = nil
    //            var error: UnsafeMutablePointer<Int8> = nil
    //
    //            if sqlite3_get_table(db, query, &query2, row, column, &error) != SQLITE_OK {
    //                print(error)
    //            }
    //        }
    //        sqlite3_close(db)
    //
    //
    //    }
    
    /* var obj_db: COpaquePointer = nil
     var stmt: COpaquePointer = nil
     var persons: NSMutableArray?
     
     lazy var db: COpaquePointer = {
     guard self.obj_db == nil else { return self.obj_db }
     if sqlite3_open(self.db_path, &(self.obj_db)) == SQLITE_OK {
     return self.obj_db
     }
     return nil
     }()
     
     lazy var db_path: String = {
     return self.doc_dir.URLByAppendingPathComponent("db.sqlite").path!
     }()
     
     lazy var doc_dir: NSURL = {
     NSFileManager.defaultManager()
     .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
     .last!
     }()
     
     func prepareDB() throws {
     guard db != nil else { throw SQLError.ConnectionError }
     defer { sqlite3_finalize(stmt) }
     
     let query = "CREATE TABLE IF NOT EXISTS test (num INTERGER)"
     if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
     if sqlite3_step(stmt) == SQLITE_DONE {
     return
     }
     }
     throw SQLError.QueryError
     }
     
     func insertValue(value: Int32) throws {
     guard db != nil else { throw SQLError.ConnectionError }
     defer { sqlite3_finalize(stmt) }
     
     let query = "INSERT INTO test (num) VALUES (?)"
     if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
     if sqlite3_bind_int(stmt, 1, value) == SQLITE_OK {
     if sqlite3_step(stmt) == SQLITE_DONE {
     return
     }
     }
     }
     throw SQLError.QueryError
     } */
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        dbName = "namecard.sql"
        let documentPaths: NSURL =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
        dbPath = documentPaths.URLByAppendingPathComponent(dbName!).path!
        
        self.checkAndCreateDatabase()
        self.readFilesFromDatabase()
        
        /* do {
         try self.prepareDB()
         } catch {
         print("Fail to initialize database")
         abort()
         } */
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //sqlite3_close(obj_db)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

