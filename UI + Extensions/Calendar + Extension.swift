import Foundation


extension Calendar {
   static func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
       let numberOfDays = current.dateComponents([.day], from: from, to: to)
        
        return numberOfDays.day!
    }
}
