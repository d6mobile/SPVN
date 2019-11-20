//
//  Document.swift
//  Cloud Music
//
//  Created by ntq on 8/28/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation

enum ImageType: String {
    case JPG    = "JPG"
    case PNG    = "PNG"
    case JPEG   = "JPEG"
    case HEIC   = "HEIC"
    case NORMAL = ""
}

enum VideoType: String {
    case MOV    = "MOV"
    case MP4    = "MP4"
    case NORMAL = ""
}

class Document {
    
    public func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
            else {
                print("Source File not found.")
                return
        }
            let fileManager = FileManager.default
            do {
                try fileManager.copyItem(at: sourceURL, to: destURL)
            } catch {
                print("Unable to copy file")
            }
    }
    
    public func fetPathFileFromDirectory(_ folderName: String) -> String? {
        if let filePath = Document().CreatFolderToDirectory(folderName: folderName)?.path {
            return filePath
        }
        return nil
    }
    
    public func CreatFolderToDirectory(folderName: String) -> URL? {
        let fileManager = FileManager.default
        let documentsPath1 = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath1.appendingPathComponent(folderName)
        
        if !fileManager.fileExists(atPath: logsPath.absoluteString) {
            
            do
            {
                try fileManager.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
                return logsPath
            }
            catch let error as NSError
            {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        
    
        return nil
    }
    
    public func fetListFileFromDirectory(name: String) -> [FileModel]? {
        guard let documentsUrl = self.CreatFolderToDirectory(folderName: name) else { return nil }
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//            print(directoryContents)
            
            var fileList = [FileModel]()
            // if you want to filter the directory contents you can do like this:
            let files = directoryContents.filter{ (ImageType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .JPG) || (ImageType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .PNG) || (ImageType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .JPEG) || (ImageType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .HEIC) || (VideoType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .MOV || (VideoType(rawValue: $0.pathExtension.uppercased()) ?? .NORMAL == .MP4))}
            
            for item in files {
                let file = FileModel(iFileName: item.deletingPathExtension().lastPathComponent, iFileSize: 0, iFileExtension: item.pathExtension)
                
                do {
                    var fileSize : UInt64
                    let attr = try FileManager.default.attributesOfItem(atPath: item.path)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    
                    //if you convert to NSDictionary, you can get file size old way as well.
                    let dict = attr as NSDictionary
                    fileSize = dict.fileSize()
                    file.fileSize = fileSize
                } catch {
                    print("Error: \(error)")
                }
                
                fileList.append(file)
            }
            
            return fileList
            
        } catch {
            print(error)
            return nil
        }
    }
}

