// Please help improve quicktype by enabling anonymous telemetry with:
//
//   $ quicktype --telemetry enable
//
// You can also enable telemetry on any quicktype invocation:
//
//   $ quicktype pokedex.json -o Pokedex.cs --telemetry enable
//
// This helps us improve quicktype by measuring:
//
//   * How many people use quicktype
//   * Which features are popular or unpopular
//   * Performance
//   * Errors
//
// quicktype does not collect:
//
//   * Your filenames or input data
//   * Any personally identifiable information (PII)
//   * Anything not directly related to quicktype's usage
//
// If you don't want to help improve quicktype, you can dismiss this message with:
//
//   $ quicktype --telemetry disable
//
// For a full privacy policy, visit app.quicktype.io/privacy
//

import Foundation

struct Page: Codable {
    let count: Int
    let next: String?
    let results: [Result]
    let previous: String?
}

struct Result: Codable {
    let id: Int
    let name: String
    let tags: [String]
    let license: License
    let username: String
}

enum License: String, Codable {
    case httpCreativecommonsOrgLicensesBy30 = "http://creativecommons.org/licenses/by/3.0/"
    case httpCreativecommonsOrgLicensesByNc30 = "http://creativecommons.org/licenses/by-nc/3.0/"
    case httpCreativecommonsOrgPublicdomainZero10 = "http://creativecommons.org/publicdomain/zero/1.0/"
}

// MARK: Convenience initializers and mutators

extension Page {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Page.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        count: Int? = nil,
        next: String? = nil,
        results: [Result]? = nil,
        previous: String? = nil
    ) -> Page {
        return Page(
            count: count ?? self.count,
            next: next ?? self.next,
            results: results ?? self.results,
            previous: previous ?? self.previous
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Result {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Result.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        name: String? = nil,
        tags: [String]? = nil,
        license: License? = nil,
        username: String? = nil
    ) -> Result {
        return Result(
            id: id ?? self.id,
            name: name ?? self.name,
            tags: tags ?? self.tags,
            license: license ?? self.license,
            username: username ?? self.username
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
