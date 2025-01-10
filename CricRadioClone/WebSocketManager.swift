//
//  WebSocketManager.swift
//  CricRadioClone
//
//  Created by Sameer Bhati on 10/01/25.
//

//import Foundation
//
//protocol WebSocketDelegate: AnyObject {
//    func didReceiveMessage(_ message: String)
//    func didEncounterError(_ error: Error)
//}
//
//class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
//    private var webSocketTask: URLSessionWebSocketTask?
//    private var urlSession: URLSession!
//    private let serverURL: URL
//    private let maxRetries: Int
//    private var retryCount = 0
//    
//    weak var delegate: WebSocketDelegate?
//    
//    init(serverURL: URL, maxRetries: Int = 3) {
//        self.serverURL = serverURL
//        self.maxRetries = maxRetries
//        super.init()
//        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        connect()
//    }
//    
//    private func connect() {
//        print("Attempting to connect to \(serverURL)")
//        webSocketTask = urlSession.webSocketTask(with: serverURL)
//        webSocketTask?.resume()
//        listenForMessages()
//    }
//    
//    func sendMessage(_ message: String) {
//        let message = URLSessionWebSocketTask.Message.string(message)
//        webSocketTask?.send(message) { [weak self] error in
//            if let error = error {
//                self?.handleError(error)
//            }
//        }
//    }
//    
//    private func listenForMessages() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    self?.delegate?.didReceiveMessage(text)
//                case .data(let data):
//                    print("Received binary message: \(data)")
//                @unknown default:
//                    fatalError()
//                }
//            case .failure(let error):
//                self?.handleError(error)
//            }
//            
//            self?.listenForMessages() // Continue listening for messages
//        }
//    }
//    
//    private func handleError(_ error: Error) {
//        delegate?.didEncounterError(error)
//        print("Encountered error: \(error.localizedDescription)")
//        retryConnection()
//    }
//    
//    private func retryConnection() {
//        guard retryCount < maxRetries else {
//            print("Max retry attempts reached. Failed to establish WebSocket connection.")
//            return
//        }
//        
//        retryCount += 1
//        print("Retrying connection (\(retryCount)/\(maxRetries))...")
//        connect()
//    }
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("WebSocket connection closed with code: \(closeCode), reason: \(String(describing: reason))")
//        retryConnection()
//    }
//}

import Foundation

protocol WebSocketDelegate: AnyObject {
    func didReceiveMessage(_ message: String)
    func didEncounterError(_ error: Error)
}

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession!
    private let serverURL: URL
    private let maxRetries: Int
    private var retryCount = 0
    
    weak var delegate: WebSocketDelegate?
    
    init(serverURL: URL, maxRetries: Int = 3) {
        self.serverURL = serverURL
        self.maxRetries = maxRetries
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        connect()
    }
    
    private func connect() {
        print("Attempting to connect to \(serverURL)")
        webSocketTask = urlSession.webSocketTask(with: serverURL)
        webSocketTask?.resume()
        listenForMessages()
    }
    
    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            }
        }
    }
    
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.didReceiveMessage(text)
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                self?.handleError(error)
            }
            
            self?.listenForMessages() // Continue listening for messages
        }
    }
    
    private func handleError(_ error: Error) {
        delegate?.didEncounterError(error)
        print("Encountered error: \(error.localizedDescription)")
        retryConnection()
    }
    
    private func retryConnection() {
        guard retryCount < maxRetries else {
            print("Max retry attempts reached. Failed to establish WebSocket connection.")
            return
        }
        
        retryCount += 1
        print("Retrying connection (\(retryCount)/\(maxRetries))...")
        connect()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket connection closed with code: \(closeCode), reason: \(String(describing: reason))")
        retryConnection()
    }
}
