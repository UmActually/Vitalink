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
let baseURL = "http://10.14.255.92:8000/"

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

enum UserRole {
    case patient, doctor, admin
    
    init(_ role: Int) {
        switch role {
        case 1:
            self = .doctor
        case 2:
            self = .admin
        default:
            self = .patient
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
    static let testing = false
    
    static var shared = API()
    static let tests = API(email: "hermenegildo@example.com", password: "M4NGOtech")
    
    var bearerToken: String?
    var userRole: UserRole?
    private var userCredentials: UserCredentials?
    
    init() {
        if let (keychainToken, keychainRole) = Keychain.loadToken() {
            bearerToken = keychainToken
            userRole = .init(keychainRole)
        }
    }
    
    init(bearerToken: String, userRole: Int) {
        self.bearerToken = bearerToken
        self.userRole = .init(userRole)
        Keychain.saveToken(bearerToken, userRole)
    }
    
    // Solo para pruebas
    init(email: String, password: String) {
        userCredentials = UserCredentials(email: email, password: password)
    }
    
    func call<T: Decodable>(_ endpointPath: String, method: HTTPMethod = .get, body: Encodable? = nil, requiresToken: Bool = true) async -> Result<T, APIError> {
        var token = ""
        
        if requiresToken && bearerToken == nil {
            guard let credentials = userCredentials else {
                return .failure(.init(500, nil))
            }
            
            let result: LoginResult = await call("token/", method: .post, body: credentials, requiresToken: false)
            switch result {
            case .success(let value):
                token = value.access
                userRole = .init(value.role)
            case .failure(_):
                fatalError("Error al iniciar sesión.")
            }
        } else if requiresToken {
            token = bearerToken!
        }
        
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
    
    var userIsAuthenticated: Bool {
        bearerToken != nil
    }
    
    static func userIsAuthenticated() -> Bool {
        let instance = testing ? Self.tests : Self.shared
        return instance.userIsAuthenticated
    }
    
    static func userRole() -> UserRole? {
        let instance = testing ? Self.tests : Self.shared
        return instance.userRole
    }
    
    static func logout() {
        Keychain.deleteToken()
        let instance = testing ? Self.tests : Self.shared
        instance.bearerToken = nil
    }
}
