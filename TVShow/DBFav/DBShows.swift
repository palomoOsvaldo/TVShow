//
//  DBShow.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import Foundation
import SQLite3

class DBShows {
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = ".myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            debugPrint("error opening database")
            return nil
        } else {
            debugPrint("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Shows(Id INTEGER PRIMARY KEY, Name TEXT, ImgMedium TEXT, ImgOriginal TEXT, Summary TEXT, date TEXT, Rating TEXT, IsFav INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                debugPrint("Se creo la tabla de Shows")
            } else {
                debugPrint("No se pudo crear la tabla Shows")
            }
        } else {
            debugPrint("La sentencia CREATE TABLE no se pudo preparar")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id: Int, name: String, imgMedium: String, imgOriginal: String, summary: String, date: String, rating: String, isFav: Bool) {
        let shows = readAllShows()
        var showID = id
        for s in shows {
            if s.name == name {
                debugPrint("El show ya esta registrada")
                return
            }
            if s.id == id {
                showID = showID + 1
            }
        }
        let fav = isFav == true ? 1 : 0
        let insertStatementString = "INSERT INTO Shows (Id, Name, ImgMedium, ImgOriginal, Summary, date, Rating, IsFav) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 0, Int32(showID))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (imgMedium as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (imgOriginal as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (summary as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (rating as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(fav))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Se ingreso en la base de datos")
            } else {
                debugPrint("no se pudo insertar en la base de datos")
            }
        } else {
            debugPrint("La sentencia INSERT no se pudo preparar")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func showByName(name: String) -> [Result] {
        let queryStatementString = "SELECT * FROM Shows WHERE Name = '\(name)';"
        var queryStatement: OpaquePointer? = nil
        var shows: [Result] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let imgMedium = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let imgOriginal = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let summary = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let rating = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let isFav = Int(sqlite3_column_int(queryStatement, 7))
                
                let fav = isFav == 1 ? true : false
                shows.append(Result(posterPath: imgMedium, popularity: 0, id: id, backdropPath: imgOriginal, voteAverage: Double(rating) ?? 0, overview: summary, firstAirDate: date, originCountry: [], genreIDS: [], originalLanguage: "", voteCount: 0, name: name, originalName: name))
                debugPrint("Query Result:")
                debugPrint("Show: | id: \(id) |name: \(name) |imgM: \(imgMedium) |imgOri: \(imgOriginal) |summary: \(summary) |date: \(date) |rating: \(rating) |fav: \(fav)")
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return shows
    }
    
    func readAllShows() -> [Result] {
        let queryStatementString = "SELECT * FROM Shows;"
        var queryStatement: OpaquePointer? = nil
        var shows: [Result] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let imgMedium = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let imgOriginal = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let summary = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let rating = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let isFav = Int(sqlite3_column_int(queryStatement, 7))
                
                let fav = isFav == 1 ? true : false
                shows.append(Result(posterPath: imgMedium, popularity: 0, id: id, backdropPath: imgOriginal, voteAverage: Double(rating) ?? 0, overview: summary, firstAirDate: date, originCountry: [], genreIDS: [], originalLanguage: "", voteCount: 0, name: name, originalName: name))
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return shows
    }
    
    func readFavShows() -> [Result] {
        let queryStatementString = "SELECT * FROM Shows WHERE IsFav = 1;"
        var queryStatement: OpaquePointer? = nil
        var shows: [Result] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let imgMedium = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let imgOriginal = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let summary = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let rating = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let isFav = Int(sqlite3_column_int(queryStatement, 7))
                
                let fav = isFav == 1 ? true : false
                shows.append(Result(posterPath: imgMedium, popularity: 0, id: id, backdropPath: imgOriginal, voteAverage: Double(rating) ?? 0, overview: summary, firstAirDate: date, originCountry: [], genreIDS: [], originalLanguage: "", voteCount: 0, name: name, originalName: name))
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return shows
    }
    
    func updateStatusFav(name: String, isFav: Bool) {
        let fav = isFav == true ? 1 : 0
        let updateStatementString = "UPDATE Shows SET IsFav = '\(fav)' WHERE Name = '\(name)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteByName(name: String) -> Bool {
        let deleteStatementStirng = "DELETE FROM Shows WHERE Name = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                sqlite3_finalize(deleteStatement)
                return true
            } else {
                sqlite3_finalize(deleteStatement)
                return false
            }
        } else {
            sqlite3_finalize(deleteStatement)
            return false
        }
    }
    
    func deleteAllRows() {
        let deleteStatementStirng = "DELETE FROM Shows;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                debugPrint("Se borró con exíto")
            } else {
                debugPrint("No se pudo borrar")
            }
        } else {
            debugPrint("La sentencia de DELETE no se preparo")
        }
        sqlite3_finalize(deleteStatement)
    }
}

