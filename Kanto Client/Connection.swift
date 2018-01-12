//
//  Connection.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-03-30.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//

import Foundation
import Alamofire


/*
 * This class is used to perform asynchronous rest API requests to a local server.
 */
class Connection: NSObject
{
    // MARK: Constructor
    override init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 // timeout after 15 seconds
    }
    
    func searchQuery(searchString: String, callBack: @escaping (_ returnType: String, _ returnedArray: NSArray) -> Void)
    {
        let q = searchString.replacingOccurrences(of: " ", with: "+")
        
        Alamofire.request("\(Constants.HOST)/search/\(q)", headers: ["Accept" : "application/json"]).validate().responseJSON {
            response in
            
            switch (response.result)
            {
            case .success:
                if let result = response.result.value // grab the json returned from the server
                {
                    let resultOfRequest = result as! NSDictionary // store the json as a dictionary
                    
                    if let type: String = resultOfRequest["type"] as? String
                    {
                        if (type == "SEARCH_RESULTS") // check for the valid query result
                        {
                            if let  results = resultOfRequest["results"]
                            {
                                // grab the array of results that is in the json
                                let resultArray = results as! NSArray
                                
                                // return the callback
                                callBack(type, resultArray)
                            } else {
                                // return an empty array if no songs were found
                                callBack(type, [])
                            }
                            
                        }
                    }
                }
                
                break
            case .failure(let error):
                if error._code  == NSURLErrorTimedOut {
                    // timeout here
                }
                
                print("\n\nConnection request 'testConnection' failed with error:\n\(error)")
                break
                
            }
        }
    }
}
