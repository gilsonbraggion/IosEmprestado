import Foundation


class DataUtil {
    
    func dataToString(_ date : Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        return dateString;

    }
    
    func stringToDate(_ dataString : String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let dateString = dateFormatter.date(from: dataString)
        
        return dateString!;
        
    }

}
