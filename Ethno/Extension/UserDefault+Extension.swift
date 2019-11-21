
import Foundation

enum UserDefaultKeys : String
{
    case micon
    case temperature
    case alarmtime
    case alarmstatus
    case notificationstatus
}

extension UserDefaults
{
    
    //savetokeninfo
    func setmicon(value : Bool)
    {
        set(value, forKey: UserDefaultKeys.micon.rawValue)
    }
    
    func getmicon() -> Bool
    {
        return bool(forKey : UserDefaultKeys.micon.rawValue)
    }
    
    func settemperture(value : Bool){
        set(value, forKey: UserDefaultKeys.temperature.rawValue)
    }
    
    func gettemperature() -> Bool{
        return bool(forKey: UserDefaultKeys.temperature.rawValue)
    }
  
    func setalarmtime(value : String){
        set(value, forKey: UserDefaultKeys.alarmtime.rawValue)
    }
    
    func getalarmtime() -> String{
        return string(forKey: UserDefaultKeys.alarmtime.rawValue)!
    }
    
    func setalarmstatus(value : Bool){
        set(value, forKey: UserDefaultKeys.alarmstatus.rawValue)
    }
    
    func getalarmstatus() -> Bool{
        return bool(forKey: UserDefaultKeys.alarmstatus.rawValue)
    }
    
    func setnotificationstatus(value : Bool){
        set(value, forKey: UserDefaultKeys.alarmstatus.rawValue)
    }
    
    func getnotificationstatus() -> Bool{
        return bool(forKey: UserDefaultKeys.alarmstatus.rawValue)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
