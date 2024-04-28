//
//  ViewController.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//

import Foundation
import SwiftUI
import UIKit

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!

    let chatbotService = ChatbotService.shared

    @IBAction func sendMessage(_ sender: Any) {
        print("pong!")
        if let message = messageTextField.text {
            chatTextView.text += "User: \(message)\n"
            messageTextField.text = ""
            
            chatbotService.sendMessage(message: message) { result in
                switch result {
                case .success(let response):
                    self.chatTextView.text += "Chatbot: \(response)\n"
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}


struct ChatView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ChatViewController
    
    func makeUIViewController(context: Context) -> ChatViewController {
        print("VIEW MADE")
        let vc = ChatViewController()
                // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ChatViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
