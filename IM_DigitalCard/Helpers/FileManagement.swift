//
//  FileManagement.swift
//  IM_DigitalCard
//
//  Created by elie buff on 31/12/2020.
//

import SwiftUI

class FileManagement{
    static let sharedInstance = FileManagement()
    
    var fileManager:FileManager?
    var documentDir:NSString?
    
    init(){
        fileManager = FileManager.default
        let dirPaths:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        documentDir = dirPaths[0] as? NSString
    }
    
    func directoryExist(_ directoryName :String) ->Bool{
        let filePath = documentDir?.appendingPathComponent("/\(directoryName)")
        var isDir = ObjCBool(true)
        if fileManager!.fileExists(atPath: filePath!, isDirectory: &isDir) {
            return true
        } else {
            return false
        }
    }
    
    func createDirectory(_ directoryName :String){
        if directoryExist(directoryName){
            return
        }
        
        let filePath = documentDir?.appendingPathComponent("/\(directoryName)")
        do {
            try fileManager?.createDirectory(atPath: filePath! as String, withIntermediateDirectories: false, attributes: nil)
        } catch _ {
        }
        
    }
    
    func createFile(_ directory: String, filename :String, fileData :Data) -> String{
        createDirectory(directory)
        
        let filePath = documentDir?.appendingPathComponent("/\(directory)/\(filename)")
        let fileCreated = fileManager?.createFile(atPath: filePath! as String, contents: fileData, attributes: nil)
        if fileCreated == false {
            print("file not created")
        }
        return "\(directory)/\(filename)"
    }
    
    func createFile(fileData: Data!, fileName: String) -> String{
        return createFile(Constants.FILE_GENERAL_FOLDER, filename: fileName, fileData: fileData)
    }
    /*
     func removeFile(fullPath :NSURL!){
     do {
     try fileManager?.removeItemAtURL(fullPath)
     } catch (let error) {
     print (error)
     }
     }
     
     func removeAllContent(directory: String?){
     var urlsToDelete = [NSURL]()
     let filePath = documentDir?.stringByAppendingPathComponent("/\(directory ?? "")")
     let url:NSURL = NSURL(fileURLWithPath:  filePath!)
     let keys:Array<String> = [NSURLNameKey, NSURLIsDirectoryKey]
     
     let options: NSDirectoryEnumerationOptions = [.SkipsHiddenFiles]
     let enumerator = fileManager?.enumeratorAtURL(url, includingPropertiesForKeys: keys, options: options, errorHandler: nil)
     for item in enumerator!.allObjects{
     if let _item = item as? NSURL{
     urlsToDelete.append(_item)
     }
     }
     
     for fileUrl in urlsToDelete{
     removeFile(fileUrl)
     }
     }
     */
    func removeFileRelativePath(_ relativePath :String!){
        let fullPath = documentDir?.appendingPathComponent("/\(relativePath)")
        removeFileFullPath(fullPath)
    }
    
    func removeFileFullPath(_ fullPath :String!){
        do {
            try fileManager?.removeItem(atPath: fullPath)
        } catch (let error) {
            print (error)
        }
    }
    
    func removeAllFiles(_ directory: String?){
        var pathsToDelete = [String]()
        let filePath = documentDir?.appendingPathComponent("/\(directory ?? "")")
        let subs = fileManager?.subpaths(atPath: filePath!)
        
        if let _subs = subs{
            for subpath in _subs {
                let fullPath = documentDir?.appendingPathComponent("/\(directory ?? "")/\(subpath)")
                
                var isDir : ObjCBool = false
                if fileManager!.fileExists(atPath: fullPath!, isDirectory:&isDir) {
                    if isDir.boolValue {
                        pathsToDelete.append(fullPath!)
                    }
                }
            }
        }
        
        for fileUrl in pathsToDelete{
            removeFileFullPath(fileUrl)
        }
    }
    
    func getPathToLocalFile(_ localPath :String?) ->URL?{
        if let localPath = localPath{
            return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(localPath)
        }
        return nil
    }
    
    func getImageFromDirectory (_ localPath: String?) -> Image? {
        
        if let localPath = localPath, let fileURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(localPath) {
            var imageData : Data?
            do {
                imageData = try Data(contentsOf: fileURL)
            } catch {
                print(error.localizedDescription)
                return nil
            }
            guard let dataOfImage = imageData, let image = UIImage(data: dataOfImage) else { return nil }
            
            return Image(uiImage: image)
        }
        return nil
    }
}

