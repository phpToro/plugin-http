import Foundation

final class HttpHandler: AsyncHandler {
    let namespace = "http"

    var onAsyncCallback: ((String, Any?) -> Void)?

    func handle(method: String, args: [String: Any]) -> Any? {
        switch method {
        case "request":
            return performRequest(args)

        default:
            return ["error": "Unknown method: \(method)"]
        }
    }

    private func performRequest(_ args: [String: Any]) -> Any? {
        guard let urlString = args["url"] as? String,
              let url = URL(string: urlString) else {
            return ["error": "Invalid URL"]
        }

        let ref = args["_callbackRef"] as? String
        let httpMethod = (args["method"] as? String ?? "GET").uppercased()
        let headers = args["headers"] as? [String: String] ?? [:]
        let body = args["body"] as? String

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.timeoutInterval = args["timeout"] as? TimeInterval ?? 30

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = body.data(using: .utf8)
        }

        dbg.log("HTTP", "\(httpMethod) \(urlString)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                dbg.error("HTTP", "Request failed: \(error.localizedDescription)")
                self.onAsyncCallback?(ref ?? "", [
                    "error": error.localizedDescription
                ])
                return
            }

            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode ?? 0
            let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            let responseHeaders = httpResponse?.allHeaderFields as? [String: String] ?? [:]

            dbg.log("HTTP", "Response: \(statusCode) (\(responseBody.count) bytes)")

            self.onAsyncCallback?(ref ?? "", [
                "status": statusCode,
                "body": responseBody,
                "headers": responseHeaders
            ])
        }.resume()

        return ["status": "pending"]
    }
}
