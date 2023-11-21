//
//  API.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import Foundation

typealias GenericJSON = [String: AnyHashable]
typealias DjangoError = [String: String]
typealias DjangoSerializerError = [String: [String]]

//let baseURL = "http://localhost:8000/"
let baseURL = "https://umm-actually.com/"

func getEndpoint(_ path: String) -> URL {
    URL(string: baseURL + path)!
}

func isSuccess(_ statusCode: Int) -> Bool {
    statusCode >= 200 && statusCode < 300
}

enum HTTPMethod {
    case get, post, put, delete
    
    func asString() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

enum HTTPStatusCode {
    case success, clientError, serverError, other
    
    init(_ statusCode: Int) {
        switch statusCode {
        case 200..<300:
            self = .success
        case 400..<500:
            self = .clientError
        case 500..<600:
            self = .serverError
        default:
            self = .other
        }
    }
}

struct APIError: Error {
    let statusCode: Int
    let status: HTTPStatusCode
    let response: GenericJSON?
    
    init(_ statusCode: Int, _ response: GenericJSON?) {
        self.statusCode = statusCode
        status = HTTPStatusCode(statusCode)
        self.response = response
    }
}

@Sendable func dateDecodingStrategy(decoder: Decoder) throws -> Date {
    let dateString = try decoder.singleValueContainer().decode(String.self)
        
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = formatter.date(from: dateString) {
        return date
    }
    
    let fallbackFormatter = DateFormatter()
    // 2023-11-15T23:07:51-06:00
    fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
    fallbackFormatter.timeZone = TimeZone(identifier: "UTC-6:00")
    
    if let date = fallbackFormatter.date(from: dateString) {
        return date
    }
    
    fallbackFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = fallbackFormatter.date(from: dateString) {
        return date
    }
    
    let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Invalid date format: \(dateString)"
    )
    throw DecodingError.dataCorrupted(context)
}

final class API {
    static let testing = true
    
    static var shared = API()
    static let tests = API(email: "hermenegildo@example.com", password: "")
    
    var email: String?
    var password: String?
    var bearerToken: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    init() {
        
    }
    
    func login() async -> String {
        if let token = bearerToken {
            return token
        }
        
        guard let email = email, let password = password else {
            fatalError("Como que me falta EL EMAIL amigos...")
        }
        
        let endpoint = getEndpoint("token/")
        let body = ["email": email, "password": password]
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONEncoder().encode(body)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard isSuccess(httpResponse.statusCode) else {
                fatalError("HTTP status code: \(httpResponse.statusCode).")
            }
            do {
                let parsedData = try JSONDecoder().decode([String: String].self, from: data)
                self.bearerToken = parsedData["access"]!
                return self.bearerToken!
            } catch {
                fatalError("Mamó la deserialización de JSON.")
            }
        } catch {
            fatalError("Mamó la POST request: \(error).")
        }
    }
    
    func call<T: Decodable>(_ endpointPath: String, method: HTTPMethod = .get, body: Encodable? = nil, requiresToken: Bool = true) async -> Result<T, APIError> {
        let token = requiresToken ? await login() : ""
        let endpoint = getEndpoint(endpointPath)
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = method.asString()
        
        if requiresToken {
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let jsonData = try! encoder.encode(body)
            request.httpBody = jsonData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            let status = HTTPStatusCode(httpResponse.statusCode)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .custom(dateDecodingStrategy)
            
            switch status {
            case .success:
                return .success(try! decoder.decode(T.self, from: data))
            case .clientError:
                var parsedResponse: GenericJSON? = try? decoder.decode(DjangoSerializerError.self, from: data)
                if parsedResponse == nil {
                    parsedResponse = try? decoder.decode(DjangoError.self, from: data)
                }
                return .failure(.init(httpResponse.statusCode, parsedResponse))
            default:
                return .failure(.init(httpResponse.statusCode, nil))
            }
        } catch {
            return .failure(.init(500, nil))
        }
    }
    
    // Convenience func para usar API.call() en lugar de API.shared.call()
    static func call<T: Decodable>(_ endpointPath: String, method: HTTPMethod = .get, body: Encodable? = nil, requiresToken: Bool = true) async -> Result<T, APIError> {
        let instance = testing ? Self.tests : Self.shared
        return await instance.call(endpointPath, method: method, body: body, requiresToken: requiresToken)
    }
}
