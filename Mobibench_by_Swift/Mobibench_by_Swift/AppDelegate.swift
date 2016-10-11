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

enum IOError: ErrorType {
    case FileOpenError
    case WriteError
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Property
    var window: UIWindow?
    
    // 각 실험 변수들
    var sequentialIOSize = 1024 * 256
    var fileSize = 1024 * 1024 * 32
    var mode = 0
    var dbSize = 100
    var dataSize = 64
    
    var stmt: COpaquePointer = nil          // 쿼리를 저장할 객체
    
    // 파일과 DB를 저장할 디렉토리
    lazy var documentDirectory: NSURL = {
        NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    // 위에서 정한 디렉토리에 db.sql의 이름으로 저장한다.
    lazy var dbPath: String = {
        return self.documentDirectory.URLByAppendingPathComponent("db.sql").path!
    }()
    // DB와 연결
    lazy var db: COpaquePointer = {
        var tmpDB: COpaquePointer = nil
        guard sqlite3_open(self.dbPath, &tmpDB) == SQLITE_OK else { return nil }
        return tmpDB
    }()
    
    // 위에서 정한 디렉토리에 deck.txt 파일로 저장한다.
    lazy var filePath: String = {
        return self.documentDirectory.URLByAppendingPathComponent("deck.txt").path!
    }()
    // 파일과 연결
    lazy var fd: CInt = {
        let fileCString = self.filePath.cStringUsingEncoding(NSString.defaultCStringEncoding())
        return open(fileCString!, O_RDWR)
    }()
    // NSFileHandle형으로 변환해준다.
    lazy var fileHandler: NSFileHandle = {
        return NSFileHandle.init(fileDescriptor: self.fd)
    }()
    // Sequential I/O 측정에 사용할 I/O size 만큼의 데이터
    lazy var cCharacterArray: [CChar] = [CChar].init(count: self.sequentialIOSize, repeatedValue: 65)
    // NSString형으로 변환해준다.
    lazy var sampleString: NSString = NSString.init(CString: self.cCharacterArray, encoding: NSASCIIStringEncoding)!
    
    // Random I/O 측정에 사용할 Data size 만큼의 데이터
    lazy var cCharacterArray2: [CChar] = [CChar].init(count: self.dataSize, repeatedValue: 66)
    // NSString형으로 변환해준다.
    lazy var sampleString2: NSString = NSString.init(CString: self.cCharacterArray2, encoding: NSASCIIStringEncoding)!
    // random으로 데이터를 쓰기 위해서 offset을 랜덤으로 설정한다.
    lazy var randomOffset: [Int] = {
        let offnum = self.fileSize / 4096
        var arr = [Int].init(count: offnum, repeatedValue: 0)
        for i in 0..<offnum {
            arr[i] = i
        }
        var temp = 0
        var n = 0
        var m = 0
        for _ in 0..<offnum/1024 {
            n = Int(arc4random()) % offnum
            m = Int(arc4random()) % offnum
            
            temp = arr[n]
            arr[n] = arr[m]
            arr[m] = temp
        }
        return arr
    }()
    
    // Methods
    // DB에 테이블을 만들어 준비시킨다.
    func prepareDatabase() throws {
        guard db != nil else { throw SQLError.ConnectionError }
        defer { sqlite3_finalize(stmt) }
        
        let query = "CREATE TABLE IF NOT EXISTS persons (pk PRIMARY KEY, name TEXT)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                return
            }
        }
        throw SQLError.QueryError
    }
    
    // DB에 데이터를 insert 시킨다.
    func insertData(name: String) throws {
        let query = "INSERT INTO persons (name) VALUES ('\(name)')"
        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            return
        } else {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        throw SQLError.QueryError
    }
    
    // 데이터를 update 한다.
    func updateData(name: String, oldName: String) throws {
        let query = "UPDATE persons SET name = '\(name)' where name = '\(oldName)'"
        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            return
        } else {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        throw SQLError.QueryError
    }
    
    // 데이터를 DB에서 지운다.
    func deleteData() throws {
        let query = "DELETE FROM persons"
        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            return
        } else {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        throw SQLError.QueryError
    }
    
    // DB의 저널모드를 확인한다.
    func getJournalMode() -> String {
        let query = "PRAGMA JOURNAL_MODE"
        var result: UnsafeMutablePointer<UnsafeMutablePointer<CChar>> = nil
        
        if sqlite3_get_table(db, query, &result, nil, nil, nil) == SQLITE_OK {
            guard let resultString = String(CString: result.successor().memory, encoding: NSUTF8StringEncoding) else {
                print("Can't get journal mode")
                abort()
            }
            return resultString
        } else {
            guard let errmsg = String.fromCString(sqlite3_errmsg(db)) else {
                print("Error!")
                abort()
            }
            return errmsg
        }
    }
    
    // DB의 저널모드를 바꿔준다.
    func changeJournalMode(mode: String) {
        let query = "PRAGMA JOURNAL_MODE = '\(mode)'"
        
        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            return
        } else {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("Error message: \(errmsg)")
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // 앱 실행시 DB를 만든다.
        do {
            try prepareDatabase()
        } catch {
            print("Fail to initialize database")
            abort()
        }
        // 앱 실행시 File을 만든다.
        NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        sqlite3_close(db)
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch let e {
            print(e)
        }

    }
    
    
}

