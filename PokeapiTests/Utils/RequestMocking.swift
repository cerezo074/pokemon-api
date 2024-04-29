//
//  RequestMocking.swift
//  PokeapiTests
//
//  Created by eli on 29/04/24.
//

import Foundation

final class RequestMocking: URLProtocol {
    static private var mocks: [MockedResponse] = []
    
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }
    
    static func removeAllMocks() {
        mocks.removeAll()
    }
    
    static private func mock(for request: URLRequest) -> MockedResponse? {
        return mocks.first { mock in
            guard let url = request.url else { return false }
            return mock.url.compareComponents(url)
        }
    }
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return mock(for: request) != nil
    }

    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    
    override func startLoading() {
        guard let mock = RequestMocking.mock(for: request),
              let url = request.url,
              let response = mock.customResponse ?? HTTPURLResponse(
                url: url,
                statusCode: mock.httpCode,
                httpVersion: "HTTP/1.1",
                headerFields: mock.headers
              ) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
            guard let self = self else { return }
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            switch mock.result {
            case let .success(data):
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            case let .failure(error):
                // Embed custom error in userInfo[NSUnderlyingErrorKey], to be extracted later
                let failure = NSError(domain: NSURLErrorDomain, code: 1, userInfo: [NSUnderlyingErrorKey: error])
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    

    override func stopLoading() {
        
    }
}


extension RequestMocking {
    
    struct MockedResponse {
        let url: URL
        let result: Result<Data, Swift.Error>
        let httpCode: Int
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
                
        init(url: URL, result: Result<Data, Swift.Error>,
             httpCode: Int = 200, headers: [HTTPHeader] = [.contentType(.json)],
             loadingTime: TimeInterval = 0.1) {
            self.url = url
            self.result = result
            self.httpCode = httpCode
            self.headers = Dictionary(headers.map { ($0.key, $0.value) }) { _, last in last }
            self.loadingTime = loadingTime
            customResponse = nil
        }
    }
    
    static func createMockResponse(
        requestURL: String,
        successData: Data,
        requestError: HTTPError = .invalidRequest,
        isSuccessful: Bool
    ) -> RequestMocking.MockedResponse {
        let result: Result<Data, Error>
        
        if (isSuccessful) {
            result = .success(successData)
        } else {
            result = .failure(requestError)
        }
        
        return .init(
            url: URL(string: requestURL)!,
            result: result,
            httpCode: isSuccessful ? 200 : 400
        )
    }
}
