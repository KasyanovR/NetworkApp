//
//  DataProvider.swift
//  NetworkApp
//
//  Created by User on 12/01/2020.
//  Copyright © 2020 Ruslan Kasyanov. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    
    var fileLocation: ((URL)->())?
    var onProgress: ((Double)->())?
    
    private lazy var  bgSession: URLSession = {
        var config = URLSessionConfiguration.background(withIdentifier: "S.Networking")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func StartDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }

    func StopDownload() {
        downloadTask.cancel()
        print("Download is STOP")
    }
}



extension DataProvider: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bsgSessionCompletoinHandler
                else {return}
            
            appDelegate.bsgSessionCompletoinHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {return}
        
        let progress = Double(totalBytesWritten) /  Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}

