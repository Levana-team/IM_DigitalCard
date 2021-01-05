//
//  NetworkingService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import SalesforceSDKCore

public class NetworkingService{
    public static let WS_ENDPOINT = Utils.getPlistValue(for: "WebServiceEndPoint") as? String ?? "/services/apexrest/"
    private static var cancellables = Set<AnyCancellable>()
    
    public static func executeRequestDecodable<U: Codable>(restMethod: RestRequest.Method, wsName :String, queryParams:[String: String]?, body: U?) ->AnyPublisher<RestResponse, RestClientError>?{
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(body)
            let jsonBody = String(data: jsonData, encoding: String.Encoding.utf8)
            
            return executeRequest(restMethod: restMethod, wsName: wsName, queryParams: queryParams, bodyString: jsonBody)
        } catch{
            print("Not me error")
        }
        return nil
    }
    
    public static func executeRequest(restMethod: RestRequest.Method, wsName :String, queryParams: [String: String]? = nil, bodyString: String? = nil) ->AnyPublisher<RestResponse, RestClientError>{
        
        let request = RestRequest(method: restMethod, path: wsName, queryParams: queryParams)
        request.endpoint = self.WS_ENDPOINT
        
        if let bodyString = bodyString, restMethod == .POST{
            request.setCustomRequestBodyString(bodyString, contentType: "application/json")
        }
        
        return RestClient.shared.publisher(for: request)
            .eraseToAnyPublisher()
    }
    
    public static func executeRequest(restMethod: RestRequest.Method, wsName :String, queryParams:[String: String]?, body:[String: AnyObject]?) ->AnyPublisher<RestResponse, RestClientError>{
        
        let request = RestRequest(method: restMethod, path: wsName, queryParams: queryParams)
        request.endpoint = self.WS_ENDPOINT
        
        return RestClient.shared.publisher(for: request).eraseToAnyPublisher()
    }
    
    
    public static func executeQueryPublisher(query: String) ->AnyPublisher<RestResponse, RestClientError>{
        let request = RestClient.shared.request(forQuery: query, apiVersion: nil)
        let requestPublisher = CurrentValueSubject<RestRequest, RestClientError>(request)

        let mainRequest = requestPublisher.flatMap({ req -> Future<RestResponse, RestClientError> in
            let publisher =  RestClient.shared.publisher(for: req)
            
            return publisher
        })
        
        return mainRequest.eraseToAnyPublisher()
    }
    
    static func getFileBody(fileId :String) -> AnyPublisher<RestResponse, RestClientError>{
        
        let apiVersion = RestClient.shared.apiVersion
        let path = "/\(apiVersion)/sobjects/ContentVersion/\(fileId)/VersionData"
        
        let request = RestRequest(method: .GET, path: path, queryParams: nil)
        request.endpoint = "/services/data/"
        request.parseResponse = false
        
        return RestClient.shared.publisher(for: request).eraseToAnyPublisher()
    }
    
}
