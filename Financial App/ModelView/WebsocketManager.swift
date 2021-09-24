//
//  WebsocketManager.swift
//  Financial App
//
//  Created by administrator on 24.09.21.
//

import Foundation


class WebSocket: NSObject, URLSessionWebSocketDelegate {
    public static let shared = WebSocket()
    var td = TickDetail()
   
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")

        send()
        receiveData { data in
            print(data?.data[0].p ?? 0.0)
        }
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
    
    func receiveData(completion: @escaping (Websocket?) -> Void) {
        
          webSocketTask.receive { result in
            switch result {
                case .failure(let error):
                  print("Error in receiving message: \(error)")
                case .success(let message):
                  switch message {
                    case .string(let text):
                        let data: Data? = text.data(using: .utf8)
                        let srvData = try? JSONDecoder().decode(Websocket.self, from: data ?? Data())
                        completion(srvData)
                    case .data(let data):
                        print("Received data: \(data)")
                  @unknown default:
                    debugPrint("Unknown message")
                  }
            }
          }
        }
}

let webSocketDelegate = WebSocket()
let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
let url = URL(string: "wss://ws.finnhub.io?token=c5474t2ad3ifdcrdfsmg")!
let webSocketTask = session.webSocketTask(with: url)

func send() {
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
        send()
        webSocketTask.send(.string("{\"type\": \"subscribe\", \"symbol\": \"\(TickDetail.tick)\"}")) { error in
          if let error = error {
            print("Error when sending a message \(error)")
          }
        }
    }
}



func ping() {
  webSocketTask.sendPing { error in
    if let error = error {
      print("Error when sending PING \(error)")
    } else {
        print("Web Socket connection is alive")
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            ping()
        }
    }
  }
}

func close() {
  let reason = "Closing connection".data(using: .utf8)
  webSocketTask.cancel(with: .goingAway, reason: reason)
}






