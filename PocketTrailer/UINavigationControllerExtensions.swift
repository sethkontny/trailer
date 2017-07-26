
import UIKit

extension UINavigationController {

	open override var disablesAutomaticKeyboardDismissal: Bool {
		get {
			return topViewController!.disablesAutomaticKeyboardDismissal
		}
	}
}
