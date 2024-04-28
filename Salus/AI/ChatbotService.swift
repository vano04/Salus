//
//  APIRequest.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//

import Alamofire
import Foundation

class ChatbotService {
    static let shared = ChatbotService()
    let apiKey = "YOUR_API_KEY"
    let openAIURL = "https://api.openai.com/v1/engines/davinci-codex/completions"

    func sendMessage(message: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "prompt": message,
            "max_tokens": 50
        ]

        AF.request(openAIURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let response = data as? [String: Any],
                       let choices = response["choices"] as? [[String: Any]],
                       let text = choices.first?["text"] as? String {
                        completion(.success(text))
                    } else {
                        completion(.failure(NSError(domain: "Chatbot", code: 1, userInfo: ["message": "Invalid response"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
