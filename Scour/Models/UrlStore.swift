//
//  GitRepositories.swift
//  Scour
//
//  Created by Paul Thrasher on 7/24/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation

// NOTTODO: move this to App Storage
// @AppStorage("urls") var urls: [URL] = []
// ^ this doesn't work with arrays, so we'd have to serialize as a string,
//   which this data is probably too large for

// TODO: convert to the new FileManager file read/write API
// https://www.swiftbysundell.com/articles/working-with-files-and-folders-in-swift/

class UrlStore: ObservableObject {
    static var plistName = "scour_urls.plist"
    static func plistPath() -> URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent(plistName)
    }

    static func index() -> [URL] {
        var urls: [URL] = []

        let paths = _read()
        for path in paths {
            urls.append(URL(fileURLWithPath: path))
        }
        print(urls[0].absoluteURL)
        return urls
    }

    static func insert(url: URL) -> Error? {
        let path = url.path

        var arr = _read()
        arr.append(path)
        return _write(arr)
    }

    static func delete(url: URL) -> Error? {
        let path = url.path

        var arr = _read()
        let i = arr.firstIndex(of: path)
        if i != nil {
            arr.remove(at: i!)
            return _write(arr)
        }
        return nil
    }

    private static func _read() -> [String] {
        let url = plistPath()
        let arr = NSArray(contentsOfFile: url.path)
//        print("_read from: \(url.path)")
        guard let out = arr else { return [] }
        return out as! [String]
    }

    private static func _write(_ arr: [String] = []) -> Error? {
        let url = plistPath()
        do {
            print("_write to: \(url.path)")
            let data = try PropertyListSerialization.data(fromPropertyList: arr, format: .binary, options: 0)
            try data.write(to: url)
            return nil
        } catch {
            print("_write ERROR \(url.path) \(error)")
            return error
        }
    }
}
