

import Foundation
import UIKit

func postService(Serverlink:String,CompletionHandler:@escaping (_ success:Bool,_ response:NSDictionary) -> ()) //,userName:String,password:String
{
    let urlNew:String = Serverlink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    //let todosEndpoint: String = Constants.BASE_URL + Serverlink
    guard let todosURL = URL(string: urlNew) else {
        print("Error: cannot create URL")
        return
    }
    var todosUrlRequest = URLRequest(url: todosURL)
    todosUrlRequest.httpMethod = "POST"
    
   // let str = UserDefaults().object(forKey: "TOKEN") as! String
   // let tokenString = "Bearer " + str
    
   // todosUrlRequest.setValue(tokenString, forHTTPHeaderField: "Authorization")
    todosUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
   
    let session = URLSession.shared
    
    let task = session.dataTask(with: todosUrlRequest) {
        (data, response, error) in
        guard error == nil else {
            print("error calling POST on /todos/1")
            print(error!)
            return
        }
        guard let responseData = data else {
            print("Error: did not receive data")
            return
        }
        
        // parse the result as JSON, since that's what the API provides
        do {
            guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                      options: []) as? [String: Any] else {
                                                                        print("Could not get JSON from responseData as dictionary")
                                                                        // CompletionHandler(true, receivedTodo)
                                                                        return
            }
            print("The todo is: " + receivedTodo.description)
            if (receivedTodo["error_code"] as? String) != nil{
                CompletionHandler(false, receivedTodo as NSDictionary)
            }else if (receivedTodo["errorCode"] as? String) != nil{
                CompletionHandler(false, receivedTodo as NSDictionary)
            }else{
                CompletionHandler(true, receivedTodo as NSDictionary)
            }
            
            
        } catch  {
            CompletionHandler(false, NSDictionary())
            
            print("error parsing response from POST on /todos")
            return
        }
    }
    task.resume()
    
}
