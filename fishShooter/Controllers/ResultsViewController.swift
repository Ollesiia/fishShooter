//
//  ResultsViewController.swift
//  fishShooter
//
//  Created by Олеся Скидан on 24.04.2024.
//

import UIKit
import WebKit

class ResultsViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        setupNavigationBar()
        addBackButton()
        view.backgroundColor = .gray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNavigationController()
    }

    private func configureWebView() {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences

        guard let userID = UserDataService.shared.getUserID() else {
            print("User ID is not available")
            return
        }

        let score = ScoreManager.shared.bestScore
        let urlString = "https://quiz-appservice.bleksi.com/quiz-redirect?user-id=\(userID)&score=\(score)"

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            showError(message: "Incorrect URL or parameters")
        }
    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToGame))
        navigationItem.leftBarButtonItem = backButton
    }

    private func addBackButton() {
        let backButton = UIButton(frame: CGRect(x: 20, y: view.bounds.height - 100, width: view.bounds.width - 40, height: 50))
        backButton.setTitle("Back to Game", for: .normal)
        backButton.backgroundColor = .white
        backButton.setTitleColor(.blue, for: .normal)
        backButton.layer.cornerRadius = 5
        backButton.addTarget(self, action: #selector(backToGame), for: .touchUpInside)
        view.addSubview(backButton)
    }

    @objc private func backToGame() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func checkNavigationController() {
        if navigationController == nil {
            print("NavigationController is nil")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavaScriptForBackgroundColor()
    }

    private func evaluateJavaScriptForBackgroundColor() {
        let javascript = """
        var header = document.querySelector('header');
        var style = window.getComputedStyle(header || document.body);
        var backgroundColor = style.backgroundColor;
        return backgroundColor || 'rgba(120, 120, 120, 1)';
        """

        webView.evaluateJavaScript(javascript) { [weak self] result, error in
            if let bgColor = result as? String {
                self?.updateStatusBarColor(bgColor)
            } else {
                print("Error fetching background color: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func updateStatusBarColor(_ cssColor: String) {
        DispatchQueue.main.async {
            let color = UIColor(cssString: cssColor) ?? .gray
            self.view.window?.rootViewController?.view.backgroundColor = color
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
