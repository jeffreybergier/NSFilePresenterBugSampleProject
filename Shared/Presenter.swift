//
//  Monitor.swift
//  CoordinatorBug
//
//  Created by Jeffrey Bergier on 2024/06/08.
//

import Foundation

/**
 The `Presenter` object enforces a structure with a parent directory and a single subdirectory.
 `Presenter` conforms to `NSFilePresenter` which monitors the parent directory.
 
 `Presenter` has methods that add files into the parent or subdirectory, however, in a normal application,
 these methods would probably exist in different objects.
 
 When `presentedSubitemDidChange` is called by `NSFileCoordinator`, this object updates
 two properties which contain the directory contents of the Parent and Subdirectories.
 
 When run on macOS, iOS (simulator), iOS (hardware), and watchOS (simulator) Presenter works as expected.
 However, when run on the watchOS (hardware), NSFileCoordinator never calls the `presentedSubitemDidChange`
 */

class Presenter: NSObject, NSFilePresenter, ObservableObject {
    
    // MARK: NSFilePresenter Protocol Conformance
    
    var presentedItemURL: URL? { Presenter.parentDirectoryURL }
    var presentedItemOperationQueue: OperationQueue = OperationQueue.main
    
    func presentedSubitemDidAppear(at url: URL) {
        let message = "presentedSubitemDidAppearAt: " + String(describing: url)
        fatalError(message)
    }
    
    func presentedSubitem(at oldURL: URL, didMoveTo newURL: URL) {
        let message = "presentedSubitemDidAppearAtOldURL: " + String(describing: oldURL) + "didMoveTo: " + String(describing: newURL)
        fatalError(message)
    }

    func presentedSubitemDidChange(at url: URL) {
        NSLog("presentedSubitemDidChange: " + String(describing: url))
        self.updateContentsArrays()
    }
    
    // MARK: External API
    
    @Published var parentDirectoryContents = [String]()
    @Published var subdirectoryContents = [String]()
    
    override init() {
        super.init()
        let fm = FileManager.default
        try? fm.createDirectory(at: Presenter.subDirectoryURL, withIntermediateDirectories: true)
        self.updateContentsArrays()
        NSFileCoordinator.addFilePresenter(self)
    }
    
    func parentDirectoryAppend() {
        let url = Presenter.parentDirectoryURL.appending(path: UUID().uuidString)
        self.addFile(at: url)
    }
    
    func subirectoryAppend() {
        let url = Presenter.subDirectoryURL.appending(path: UUID().uuidString)
        self.addFile(at: url)
    }
    
    func resetDirectories() {
        let c = NSFileCoordinator()
        let fm = FileManager.default
        c.coordinate(writingItemAt: Presenter.parentDirectoryURL, options: .forReplacing, error: nil) { url in
            try! fm.removeItem(at: url)
            try! fm.createDirectory(at: Presenter.subDirectoryURL, withIntermediateDirectories: true)
        }
    }
    
    // MARK: Private API
    
    static private let parentDirectoryURL: URL = {
        let docs = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return docs.appending(path: "Parent", directoryHint: .isDirectory)
    }()
    
    static private let subDirectoryURL: URL = {
        return Presenter.parentDirectoryURL.appending(component: "SubDirectory", directoryHint: .isDirectory)
    }()
    
    private func updateContentsArrays() {
        let fm = FileManager.default
        self.parentDirectoryContents = try! fm.contentsOfDirectory(atPath: Presenter.parentDirectoryURL.path)
        self.subdirectoryContents = try! fm.contentsOfDirectory(atPath: Presenter.subDirectoryURL.path)
    }
    
    private func addFile(at url: URL) {
        let c = NSFileCoordinator()
        c.coordinate(writingItemAt: url, error: nil) { url in
            let fm = FileManager.default
            fm.createFile(atPath: url.path, contents: Data())
        }
    }
}
