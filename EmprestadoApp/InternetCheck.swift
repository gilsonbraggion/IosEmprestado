import Foundation
import SystemConfiguration


open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = URL(string: Endereco().enderecoConexao)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as Data?
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }

        } catch {
            print("Something went wrong!")
        }
        
        return Status
    }
}




open class Conectividade {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}


/*


    if Reachability.isConnectedToNetwork() == true {
        
        // Codigo de sucesso

    } else {
        
        var alert = AlertIntert.getAlert();
        alert.show()

    }

*/
