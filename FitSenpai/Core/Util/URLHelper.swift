import SwiftUI
import SafariServices
import UIKit
import MessageUI

struct URLHelper {
    static func openMail(to email: String) {
        if MFMailComposeViewController.canSendMail() {
            // Use the SwiftUI wrapper to present mail composer
            let recipient = email
            let subject = "FitSenpai Support"
            let mailtoUrl = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            if let url = URL(string: mailtoUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Show error or fallback
            print("Cannot send mail")
            // You might want to show an alert here to inform the user
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openAppStore() {
        // Replace YOUR_APP_ID with actual App ID
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
