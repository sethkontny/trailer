
//////////////////////// Logging: Ugly as hell but works and is fast

func DLog(message: String) {
    if Settings.logActivityToConsole {
        NSLog(message)
    }
}

func DLog(message: String, @autoclosure _ arg1: ()->CVarArgType?) {
    if Settings.logActivityToConsole {
        NSLog(message, arg1() ?? "(nil)")
    }
}

func DLog(message: String, @autoclosure _ arg1: ()->CVarArgType?, @autoclosure _ arg2: ()->CVarArgType?) {
    if Settings.logActivityToConsole {
        NSLog(message, arg1() ?? "(nil)", arg2() ?? "(nil)")
    }
}

func DLog(message: String, @autoclosure _ arg1: ()->CVarArgType?, @autoclosure _ arg2: ()->CVarArgType?, @autoclosure _ arg3: ()->CVarArgType?) {
    if Settings.logActivityToConsole {
        NSLog(message, arg1() ?? "(nil)", arg2() ?? "(nil)", arg3() ?? "(nil)")
    }
}

func DLog(message: String, @autoclosure _ arg1: ()->CVarArgType?, @autoclosure _ arg2: ()->CVarArgType?, @autoclosure _ arg3: ()->CVarArgType?, @autoclosure _ arg4: ()->CVarArgType?) {
	if Settings.logActivityToConsole {
		NSLog(message, arg1() ?? "(nil)", arg2() ?? "(nil)", arg3() ?? "(nil)", arg4() ?? "(nil)")
	}
}

func DLog(message: String, @autoclosure _ arg1: ()->CVarArgType?, @autoclosure _ arg2: ()->CVarArgType?, @autoclosure _ arg3: ()->CVarArgType?, @autoclosure _ arg4: ()->CVarArgType?, @autoclosure _ arg5: ()->CVarArgType?) {
	if Settings.logActivityToConsole {
		NSLog(message, arg1() ?? "(nil)", arg2() ?? "(nil)", arg3() ?? "(nil)", arg4() ?? "(nil)", arg5() ?? "(nil)")
	}
}

////////////////////////////////////

#if os(iOS)

	import UIKit

	let REFRESH_STARTED_NOTIFICATION = "RefreshStartedNotification"
	let REFRESH_ENDED_NOTIFICATION = "RefreshEndedNotification"
	let RECEIVED_NOTIFICATION_KEY = "ReceivedNotificationKey"
	let GLOBAL_SCREEN_SCALE = UIScreen.mainScreen().scale
	let GLOBAL_TINT = UIColor(red: 52.0/255.0, green: 110.0/255.0, blue: 183.0/255.0, alpha: 1.0)

	let stringDrawingOptions: NSStringDrawingOptions = [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading]
	typealias COLOR_CLASS = UIColor
	typealias FONT_CLASS = UIFont
	typealias IMAGE_CLASS = UIImage

#elseif os(watchOS)

	import WatchKit

	typealias COLOR_CLASS = UIColor
	typealias FONT_CLASS = UIFont
	typealias IMAGE_CLASS = WKImage

#elseif os(OSX)

	let STATUSITEM_PADDING: CGFloat = 1.0
	let TOP_HEADER_HEIGHT: CGFloat = 28.0
	let AVATAR_SIZE: CGFloat = 26.0
	let LEFTPADDING: CGFloat = 44.0
	let TITLE_HEIGHT: CGFloat = 42.0
	let BASE_BADGE_SIZE: CGFloat = 20.0
	let SMALL_BADGE_SIZE: CGFloat = 14.0
	let MENU_WIDTH: CGFloat = 500.0
	let AVATAR_PADDING: CGFloat = 8.0
	let REMOVE_BUTTON_WIDTH: CGFloat = 80.0

	let stringDrawingOptions: NSStringDrawingOptions = [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading]
	typealias COLOR_CLASS = NSColor
	typealias FONT_CLASS = NSFont
	typealias IMAGE_CLASS = NSImage

#endif

let itemCountFormatter = { () -> NSNumberFormatter in
    let n = NSNumberFormatter()
    n.numberStyle = NSNumberFormatterStyle.DecimalStyle
    return n
}()

let syncDateFormatter = { () -> NSDateFormatter in
    let d = NSDateFormatter()
    d.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    d.timeZone = NSTimeZone(abbreviation: "UTC")
    d.locale = NSLocale(localeIdentifier: "en_US")
    return d
}()

func MAKECOLOR(red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> COLOR_CLASS {
	return COLOR_CLASS(red: red, green: green, blue: blue, alpha: alpha)
}

let PULL_REQUEST_ID_KEY = "pullRequestIdKey"
let ISSUE_ID_KEY = "issueIdKey"
let STATUS_ID_KEY = "statusIdKey"
let COMMENT_ID_KEY = "commentIdKey"
let NOTIFICATION_URL_KEY = "urlKey"
let API_USAGE_UPDATE = "RateUpdateNotification"

let LOW_API_WARNING: Double = 0.20
let NETWORK_TIMEOUT: NSTimeInterval = 120.0
let BACKOFF_STEP: NSTimeInterval = 120.0

func currentAppVersion() -> String {
	return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String ?? "(unknown version)"
}

#if os(iOS)
	enum MasterViewMode: Int {
		case PullRequests, Issues
		static let namesPlural = ["Pull Requests", "Issues"]
		func namePlural() -> String {
			return MasterViewMode.namesPlural[rawValue]
		}
		static let namesSingular = ["Pull Request", "Issue"]
		func nameSingular() -> String {
			return MasterViewMode.namesSingular[rawValue]
		}
	}

	func imageFromColor(color: UIColor) -> UIImage {
		let rect = CGRectMake(0, 0, 1, 1)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return img
	}
#endif

func versionString() -> String {
	let buildNumber = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String ?? "unknown build"
	return "Version \(currentAppVersion()) (\(buildNumber))"
}

func isDarkColor(color: COLOR_CLASS) -> Bool {
	var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
	color.getRed(&r, green: &g, blue: &b, alpha: nil)
	let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
	return (lum < 0.5)
}

func indexOfObject(array: [AnyObject], value: AnyObject) -> Int? {
	for (index, element) in array.enumerate() {
		if element === value {
			return index
		}
	}
	return nil
}

func atNextEvent(completion: Completion) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
		completion()
	}
}

func never() -> NSDate {
	return NSDate.distantPast() 
}

func N(data: AnyObject?, _ key: String) -> AnyObject? {
	if let d = data as? [NSObject : AnyObject], o: AnyObject = d[key] where !(o is NSNull) {
		return o
	}
	return nil
}

func md5hash(s: String) -> String {
	let digestLen = Int(CC_MD5_DIGEST_LENGTH)
	let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)

	CC_MD5(
		s.cStringUsingEncoding(NSUTF8StringEncoding)!,
		CC_LONG(s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)),
		result)

	let hash = NSMutableString()
	for i in 0..<digestLen {
		hash.appendFormat("%02X", result[i])
	}

	result.destroy()

	return String(hash)
}

func parseFromHex(s: String) -> UInt32 {
	var safe = s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	safe = safe.stringByTrimmingCharactersInSet(NSCharacterSet.symbolCharacterSet())
	let s = NSScanner(string: safe)
	var result:UInt32 = 0
	s.scanHexInt(&result)
	return result
}

//////////////////////// From tieferbegabt's post on https://forums.developer.apple.com/message/37935, with thanks!
extension String {
	var lastPathComponent: String {
		get {
			return (self as NSString).lastPathComponent
		}
	}
	var pathExtension: String {
		get {

			return (self as NSString).pathExtension
		}
	}
	var stringByDeletingLastPathComponent: String {
		get {

			return (self as NSString).stringByDeletingLastPathComponent
		}
	}
	var stringByDeletingPathExtension: String {
		get {

			return (self as NSString).stringByDeletingPathExtension
		}
	}
	var pathComponents: [String] {
		get {

			return (self as NSString).pathComponents
		}
	}
	func stringByAppendingPathComponent(path: String) -> String {
		return (self as NSString).stringByAppendingPathComponent(path)
	}
	func stringByAppendingPathExtension(ext: String) -> String? {
		return (self as NSString).stringByAppendingPathExtension(ext)
	}
	func stringByReplacingCharactersInRange(range: NSRange, withString string: String) -> String {
		return (self as NSString).stringByReplacingCharactersInRange(range, withString: string)
	}
}

