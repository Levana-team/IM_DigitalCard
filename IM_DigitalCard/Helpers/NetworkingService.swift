//
//  NetworkingService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import SalesforceSDKCore
import CoreData

public class NetworkingService{
    public static let WS_ENDPOINT = Utils.getPlistValue(for: "WebServiceEndPoint") as? String ?? "/services/apexrest/"
    private static var cancellables = Set<AnyCancellable>()
    
    static func toJson(data: [String: Any]) ->String{
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        return String(data: jsonData!, encoding: .utf8) ?? ""
    }
    
    public static func SOQLExecuter<U: Codable>(query: String,
                                                mapping: [String:String],
                                                _: U.Type,
                                                onBeforeSave: ((_ items: Set<NSManagedObject>, _ context: NSManagedObjectContext) -> Void)? = nil) -> AnyPublisher<Bool, Never> {
        func checkNextRecord(_ restResponse: RestResponse) -> String?{
            do {
                let responseJson = try restResponse.asJson()
                if let responseData = responseJson as? [String : Any]{
                    if let nextRecordsUrl = responseData["nextRecordsUrl"] as? String{
                        return  nextRecordsUrl
                    }
                }
                return nil
            } catch {
                fatalError("Failed to fetch tasks:")
            }
        }
        
        func loadPage(request: RestRequest) -> AnyPublisher<RestResponse, RestClientError> {
            RestClient.shared.publisher(for: request)
                .saveToCoreData(mapping: mapping, type: U.self, onBeforeSave: onBeforeSave)
                .eraseToAnyPublisher()
        }
        
        let request = RestClient.shared.request(forQuery: query, apiVersion: SFRestDefaultAPIVersion)
        let pageIndexPublisher = CurrentValueSubject<RestRequest, Never>(request)

        return pageIndexPublisher
            .flatMap({ restRequest in
                return loadPage(request: restRequest)
            })
            .handleEvents(receiveOutput: { (response: RestResponse) in
                if let nextRecordsUrl = checkNextRecord(response){
                    let request = RestRequest(method: .GET, path: nextRecordsUrl, queryParams: nil)
                    pageIndexPublisher.send(request)
                }else{
                    pageIndexPublisher.send(completion: .finished)
                }
            })
            .map{ _ in true}.replaceError(with: true).eraseToAnyPublisher()
    }
    
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
    
    
    public static func executeQueryPublisher(query: String) -> AnyPublisher<RestResponse, RestClientError>{
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
