// The Swift Programming Language
// https://docs.swift.org/swift-book

import FunctionCalling
import AIProxy

extension ToolContainer {
    public typealias AIProxyOpenAITool = OpenAIChatCompletionRequestBody.Tool
    public typealias AIProxyAnthropicTool = AnthropicTool
    public typealias AIProxyTogetherAITool = TogetherAITool

    // swiftlint:disable:next line_length
    // https://github.com/lzell/AIProxySwift?tab=readme-ov-file#how-to-use-openai-structured-outputs-json-schemas-in-a-tool-call
    public func toOpenAITools(strict: Bool = false) -> [AIProxyOpenAITool] {
        guard let allTools else { return [] }

        return allTools.map { tool in
            AIProxyOpenAITool.function(
                name: tool.name,
                description: tool.description,
                parameters: tool.inputSchema.toJSONSchema(),
                strict: strict
            )
        }
    }

    // https://github.com/lzell/AIProxySwift?tab=readme-ov-file#how-to-use-streaming-tool-calls-with-anthropic
    public func toAnthropicTools() -> [AIProxyAnthropicTool] {
        guard let allTools else { return [] }

        return allTools.map { tool in
            AIProxyAnthropicTool(
                description: tool.description,
                inputSchema: tool.inputSchema.toJSONSchema(),
                name: tool.name
            )
        }
    }

    // swiftlint:disable:next line_length
    // https://github.com/lzell/AIProxySwift?tab=readme-ov-file#how-to-make-a-tool-call-request-with-llama-and-togetherai
    public func toTogetherAITools() -> [AIProxyTogetherAITool] {
        guard let allTools else { return [] }

        return allTools.map { tool in
            AIProxyTogetherAITool(
                function: .init(
                    description: tool.description,
                    name: tool.name,
                    parameters: tool.inputSchema.toJSONSchema()
                )
            )
        }
    }
}

private extension FunctionCalling.InputSchema {
    func toJSONSchema() -> [String: AIProxyJSONValue] {
        var jsonSchema: [String: AIProxyJSONValue] = [
            "type": .string(self.type.rawValue)
        ]

        if let format {
            jsonSchema["format"] = .string(format)
        }

        if let description {
            jsonSchema["description"] = .string(description)
        }

        if let nullable {
            jsonSchema["nullable"] = .bool(nullable)
        }

        if let enumValues {
            jsonSchema["enum"] = .array(enumValues.map { .string($0) })
        }

        if let items {
            jsonSchema["items"] = .object(items.toJSONSchema())
        }

        if let properties {
            jsonSchema["properties"] = .object(properties.mapValues { AIProxyJSONValue.object($0.toJSONSchema()) })
        }

        if let requiredProperties {
            jsonSchema["required"] = .array(requiredProperties.map { .string($0) })
        }

        return jsonSchema
    }
}
