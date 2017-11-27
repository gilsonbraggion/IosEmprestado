import Foundation


class ByteArrayImage {
    
    func getArrayOfBytesFromImage(_ imageData : Data) -> NSMutableArray {
        
        let count = imageData.count / MemoryLayout<UInt8>.size
        var bytes = [UInt8](repeating: 0, count: count)
        
        (imageData as NSData).getBytes(&bytes, length:count * MemoryLayout<UInt8>.size)
        
        let byteArray:NSMutableArray = NSMutableArray()
        
        for (i in 0 ..< count) {
            byteArray.add(NSNumber(value: bytes[i] as UInt8))
        }
        
        return byteArray
    }
}
