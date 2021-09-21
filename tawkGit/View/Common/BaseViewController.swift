//
//  BaseViewController.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var offlinePromptView: PromtView = {
        let screenWidth = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 22)
        let view = PromtView(frame: frame)
        view.promt = "No internet connection"
        return view

    }()

    private var reachability: Reachability?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReachability()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupReachability() {
        do {
            let reachability = try Reachability()
            self.reachability = reachability

            reachability.whenUnreachable = { _ in
                self.showOfflineStatus()
            }

            reachability.whenReachable = { _ in
                self.hideOfflineStatus()
            }

            try reachability.startNotifier()
        } catch {
            print("Unable to setup Reachability")
        }
    }

    func showOfflineStatus() {
        offlinePromptView.backgroundColor = .systemOrange
        offlinePromptView.promt = "No internet connection"
        navigationItem.prompt = ""
        if offlinePromptView.superview == nil {
            navigationController?.navigationBar.subviews.forEach({ $0.removeFromSuperview() })
            navigationController?.navigationBar.addSubview(offlinePromptView)
        }
    }

    func hideOfflineStatus() {
        offlinePromptView.backgroundColor = .systemGreen
        offlinePromptView.promt = "Back to online"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // remove only if still reachable,
            // otherwise offlinePromptView should be in the proper state already
            // so we do not change them
            if let connection = self.reachability?.connection,
               connection != .unavailable {
                self.navigationItem.prompt = nil
                self.navigationController?.navigationBar.subviews.forEach({ $0.removeFromSuperview() })

                // naviagation controller becomes translucent when promt removed
                // this hack fore redraw navigation bar

                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
    }
}
