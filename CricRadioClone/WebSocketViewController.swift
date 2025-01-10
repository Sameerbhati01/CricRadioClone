//
//  WebSocketViewController.swift
//  CricRadioClone
//
//  Created by Sameer Bhati on 10/01/25.
//

import SwiftUI
import UIKit

class WebSocketViewController: UIViewController, WebSocketDelegate {
    private var webSocketManager: WebSocketManager!
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serverURL = URL(string: "wss://ws.postman-echo.com/raw")!
        webSocketManager = WebSocketManager(serverURL: serverURL)
        webSocketManager.delegate = self
        
        setupUI()
        
        webSocketManager.sendMessage("Hello, Postman!")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        messageTextField.placeholder = "Enter your message"
        messageTextField.borderStyle = .roundedRect
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        
        sendButton.setTitle("Send Message", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: 10),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func sendMessage() {
        guard let message = messageTextField.text, !message.isEmpty else {
            return
        }
        
        webSocketManager.sendMessage(message)
        messageTextField.text = ""
    }
    
    func didReceiveMessage(_ message: String) {
        print("Received message: \(message)")
    }
    
    func didEncounterError(_ error: Error) {
        print("Encountered error: \(error.localizedDescription)")
    }
}

struct WebSocketViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WebSocketViewController {
        return WebSocketViewController()
    }
    
    func updateUIViewController(_ uiViewController: WebSocketViewController, context: Context) {}
}
