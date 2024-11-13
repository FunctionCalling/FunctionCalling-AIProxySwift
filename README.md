# FunctionCalling-AIProxySwift

This library simplifies the integration of the [FunctionCalling](https://github.com/fumito-ito/FunctionCalling) macro into [AIProxySwift](https://github.com/lzell/AIProxySwift). By using this library, you can directly generate `Tool` objects from Swift native functions, which can then be specified as FunctionCalling when invoking AIProxy.

## Usage

```swift

import FunctionCalling
import FunctionCalling_AIProxySwift
import AIProxy

// MARK: Declare the container and functions for the tools to be called from FunctionCalling.

@FunctionCalling(service: .chatGPT)
struct MyFunctionTools {
    @CallableFunction
    /// Get the current stock price for a given ticker symbol
    ///
    /// - Parameter: The stock ticker symbol, e.g. GOOG for Google Inc.
    func getStockPrice(ticker: String) async throws -> String {
        // code to return stock price of passed ticker
    }
}

// MARK: You can directly pass the tools generated from objects to the model in AIProxy.

let openAIService = AIProxy.openAIService(
    partialKey: "partial-key-from-your-developer-dashboard",
    serviceURL: "service-url-from-your-developer-dashboard"
)

do {
    let requestBody = OpenAIChatCompletionRequestBody(
        model: "gpt-4o-2024-08-06",
        messages: [
            .user(content: .text("How cold is it today in SF?"))
        ],
        tools: MyFunctionTools().toOpenAITools()
    )

    let response = try await openAIService.chatCompletionRequest(body: requestBody)
    if let toolCall = response.choices.first?.message.toolCalls?.first {
        let functionName = toolCall.function.name
        let arguments = toolCall.function.arguments ?? [:]
        print("ChatGPT wants us to call function \(functionName) with arguments: \(arguments)")
    } else {
        print("Could not get function arguments")
    }

} catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
    print("Received \(statusCode) status code with response body: \(responseBody)")
} catch {
    print("Could not make an OpenAI structured output tool call: \(error.localizedDescription)")
}
```

## Installation

### Swift Package Manager

```
let package = Package(
    name: "MyPackage",
    products: [...],
    targets: [
        .target(
            "YouAppModule",
            dependencies: [
                .product(name: "FunctionCalling-AIProxySwift", package: "FunctionCalling-AIProxySwift")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/FunctionCalling/FunctionCalling-AIProxySwift", from: "0.1.0")
    ]
)
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

Apache v2 License
