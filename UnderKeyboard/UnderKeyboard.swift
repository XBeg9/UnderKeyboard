import UIKit

let tegUnderKeyboard = UnderKeyboard()

/**

Moves scroll view content from under the keyboard on iOS. It adjusts the bottom inset of the scroll view by the height of the keyboard when it is shown.

*/
public class UnderKeyboard {
  
  private weak var scrollView: UIScrollView?
  private weak var bottomLayoutGuide: UILayoutSupport?
  
  private class var shared: UnderKeyboard {
    return tegUnderKeyboard
  }
  
  /**
  
  - parameter scrollView: Supply a scroll view or any of its subclasses. Its bottom inset will be adjusted to the height of the keyboard when it is shown.
  
  - parameter buttonLayoutGuide: Supply an optional bottom layout guide (like a tab bar) that will be used for adjusting  the scroll view insets.
  
  */
  public class func scrollView(scrollView: UIScrollView, bottomLayoutGuide: UILayoutSupport? = nil) {
    shared.scrollView = scrollView
    shared.bottomLayoutGuide = bottomLayoutGuide
  }
  
  private init() {
    registerForKeyboardNotifications()
  }
  
  deinit {
    unRegisterForKeyboardNotifications()
  }
  
  private func registerForKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardDidShow:",
      name: UIKeyboardDidShowNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardWillHide:",
      name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func unRegisterForKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  @objc private func keyboardDidShow(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
        
        let layoutGuideHeight = bottomLayoutGuide?.length ?? 0
        let height = value.CGRectValue().size.height - layoutGuideHeight
        
        let insets =  UIEdgeInsets(
          top: 0,
          left: 0,
          bottom: height,
          right: 0)
        
        scrollView?.contentInset = insets
        scrollView?.scrollIndicatorInsets = insets
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    scrollView?.contentInset = UIEdgeInsetsZero;
    scrollView?.scrollIndicatorInsets = UIEdgeInsetsZero;
  }
}