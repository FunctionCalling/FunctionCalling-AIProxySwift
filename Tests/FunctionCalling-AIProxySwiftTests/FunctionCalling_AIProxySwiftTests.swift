import XCTest
@testable import FunctionCalling_AIProxySwift
import FunctionCalling
import AIProxy

final class FunctionCalling_AIProxySwiftTests: XCTestCase {
    
    var toolContainer: ToolContainer!

    struct MockToolContainer: ToolContainer {
        func execute(methodName name: String, parameters: [String : Any]) async -> String {
            ""
        }
        
        let allTools: [Tool]?

        let allToolsJSONString: String = ""

        let service: FunctionCallingService = .claude
    }

    override func setUp() {
        super.setUp()
        // テスト用のToolContainerを設定
        let tool = Tool(
            service: .claude,
            name: "testTool",
            description: "A test tool",
            inputSchema: .init(
                type: .object,
                properties: [
                    "testParam": .init(type: .string, description: "A test parameter", enumValues: ["option1", "option2"])
                ],
                requiredProperties: ["testParam"]
            )
        )

        toolContainer = MockToolContainer(allTools: [tool])
    }
    
    func testToOpenAITools() throws {
        let openAITools = toolContainer.toOpenAITools()
        
        XCTAssertEqual(openAITools.count, 1)

        let openAITool = try XCTUnwrap(openAITools.first)

        guard case .function(let name, let description, let parameters, let strict) = openAITool else {
            XCTFail("Cannot unwrap function")
            return
        }

        // name
        XCTAssertEqual(name, "testTool")
        // description
        XCTAssertEqual(description, "A test tool")
        // strict
        XCTAssertEqual(strict, false)

        // inputSchema
        guard let parameters else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        // inputSchema.type
        guard case .string(let type) = parameters["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "object")

        // inputSchema.requiredProperties
        guard case .array(let required) = parameters["required"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        let requiredProperties = required.compactMap { r in
            switch r {
            case .string(let p):
                return p
            default:
                return nil
            }
        }
        XCTAssertEqual(requiredProperties, ["testParam"])

        // inputSchema.properties
        guard case .object(let properties) = parameters["properties"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(properties.count, 1)

        // inputSchema.properties.testParam
        let testParam = try XCTUnwrap(properties["testParam"])

        guard case .object(let prop) = testParam else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        guard case .string(let type) = prop["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "string")

        guard case .string(let description) = prop["description"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(description, "A test parameter")

        guard case .array(let enumValueArray) = prop["enum"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        XCTAssertEqual(enumValueArray.count, 2)

        let enumValues = enumValueArray.compactMap { e in
            switch e {
            case .string(let v):
                return v
            default:
                return nil
            }
        }
        XCTAssertEqual(enumValues, ["option1", "option2"])
    }
    
    func testToAnthropicTools() throws {
        let anthropicTools = toolContainer.toAnthropicTools()
        
        XCTAssertEqual(anthropicTools.count, 1)
        XCTAssertEqual(anthropicTools[0].name, "testTool")
        XCTAssertEqual(anthropicTools[0].description, "A test tool")

        // inputSchema
        let parameters = anthropicTools[0].inputSchema

        // inputSchema.type
        guard case .string(let type) = parameters["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "object")

        // inputSchema.requiredProperties
        guard case .array(let required) = parameters["required"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        let requiredProperties = required.compactMap { r in
            switch r {
            case .string(let p):
                return p
            default:
                return nil
            }
        }
        XCTAssertEqual(requiredProperties, ["testParam"])

        // inputSchema.properties
        guard case .object(let properties) = parameters["properties"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(properties.count, 1)

        // inputSchema.properties.testParam
        let testParam = try XCTUnwrap(properties["testParam"])

        guard case .object(let prop) = testParam else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        guard case .string(let type) = prop["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "string")

        guard case .string(let description) = prop["description"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(description, "A test parameter")

        guard case .array(let enumValueArray) = prop["enum"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        XCTAssertEqual(enumValueArray.count, 2)

        let enumValues = enumValueArray.compactMap { e in
            switch e {
            case .string(let v):
                return v
            default:
                return nil
            }
        }
        XCTAssertEqual(enumValues, ["option1", "option2"])
    }
    
    func testToTogetherAITools() throws {
        let togetherAITools = toolContainer.toTogetherAITools()
        
        XCTAssertEqual(togetherAITools.count, 1)
        XCTAssertEqual(togetherAITools[0].function.name, "testTool")
        XCTAssertEqual(togetherAITools[0].function.description, "A test tool")
        
        // inputSchema
        let parameters = togetherAITools[0].function.parameters

        // inputSchema.type
        guard case .string(let type) = parameters["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "object")

        // inputSchema.requiredProperties
        guard case .array(let required) = parameters["required"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        let requiredProperties = required.compactMap { r in
            switch r {
            case .string(let p):
                return p
            default:
                return nil
            }
        }
        XCTAssertEqual(requiredProperties, ["testParam"])

        // inputSchema.properties
        guard case .object(let properties) = parameters["properties"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(properties.count, 1)

        // inputSchema.properties.testParam
        let testParam = try XCTUnwrap(properties["testParam"])

        guard case .object(let prop) = testParam else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        guard case .string(let type) = prop["type"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(type, "string")

        guard case .string(let description) = prop["description"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }
        XCTAssertEqual(description, "A test parameter")

        guard case .array(let enumValueArray) = prop["enum"] else {
            XCTFail("Parameters should be a dictionary")
            return
        }

        XCTAssertEqual(enumValueArray.count, 2)

        let enumValues = enumValueArray.compactMap { e in
            switch e {
            case .string(let v):
                return v
            default:
                return nil
            }
        }
        XCTAssertEqual(enumValues, ["option1", "option2"])
    }
}
