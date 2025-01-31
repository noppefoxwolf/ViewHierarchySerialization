public import Foundation
import RegexBuilder

public struct HierarchyDataDecoder {
    
    public init() {}
    
    public func decode(from data: Data) throws -> HierarchyData {
        guard let text = String(data: data, encoding: .utf8) else {
            throw HierarchyDataDecoderError.dataCorrupted
        }
        let lines = text.split(separator: .newlineSequence)
        return HierarchyData(
            hierarchies: try lines.map(decode(line:))
        )
    }
    
    internal func decode(line: Substring) throws -> Hierarchy {
        let header = Reference<Hierarchy.Header>()
        let controllerName = Reference<Substring>()
        let controllerAddress = Reference<Substring>()
        let state = Reference<Hierarchy.State>()
        let view = Reference<Hierarchy.View>()
        let regex = Regex {
            headerRegex(as: header)
            controllerRegex(name: controllerName, address: controllerAddress)
            ", "
            stateRegex(state: state)
            ", "
            viewRegex(view: view)
            ZeroOrMore {
                .any
            }
        }
        guard let match = line.wholeMatch(of: regex) else {
            throw HierarchyDataDecoderError.invalidFormat
        }
        return Hierarchy(
            header: match[header],
            controller: Hierarchy.Controller(
                name: String(match[controllerName]),
                address: String(match[controllerAddress])
            ),
            state: match[state],
            view: match[view]
        )
    }
    
    func viewRegex(
        view: Reference<Hierarchy.View> = Reference<Hierarchy.View>()
    ) -> some RegexComponent {
        Regex {
            "view: "
            Capture(as: view) {
                ChoiceOf {
                    "(view not loaded)"
                    Regex {
                        "<"
                        OneOrMore {
                            ChoiceOf {
                                .word
                                "$"
                                "."
                            }
                        }
                        ": "
                        "0x"
                        OneOrMore {
                            .hexDigit
                        }
                        ">"
                    }
                }
            } transform: {
                switch String($0) {
                case "(view not loaded)":
                    return Hierarchy.View.notLoaded
                default:
                    let name = Reference<Substring>()
                    let address = Reference<Substring>()
                    let match = $0.wholeMatch(of: viewRegex(name: name, address: address))!
                    return Hierarchy.View.loaded(String(match[name]), String(match[address]))
                }
            }
        }
    }
    
    func viewRegex(
        name: Reference<Substring> = Reference<Substring>(),
        address: Reference<Substring> = Reference<Substring>()
    ) -> Regex<(Substring, Substring, Substring)> {
        Regex {
            "<"
            Capture(as: name) {
                OneOrMore {
                    ChoiceOf {
                        .word
                        "$"
                        "."
                    }
                }
            }
            ": "
            Capture(as: address) {
                "0x"
                OneOrMore {
                    .hexDigit
                }
            }
            ">"
        }
    }
    
    func controllerRegex(
        name: Reference<Substring> = Reference<Substring>(),
        address: Reference<Substring> = Reference<Substring>()
    ) -> Regex<(Substring, Substring, Substring)> {
        Regex {
            "<"
            Capture(as: name) {
                OneOrMore {
                    ChoiceOf {
                        .word
                        "$"
                        "."
                    }
                }
            }
            " "
            Capture(as: address) {
                "0x"
                OneOrMore {
                    .hexDigit
                }
            }
            ">"
        }
    }
    
    func stateRegex(state: Reference<Hierarchy.State> = Reference<Hierarchy.State>()) -> Regex<(Substring, Hierarchy.State)> {
        Regex {
            "state: "
            Capture(as: state) {
                ChoiceOf {
                    "appeared"
                    "disappeared"
                }
            } transform: {
                Hierarchy.State(rawValue: String($0))!
            }
        }
    }
    
    func headerRegex(as header: Reference<Hierarchy.Header> = Reference<Hierarchy.Header>()) -> Regex<(Substring, Hierarchy.Header)> {
        Regex {
            Capture(as: header) {
                ZeroOrMore {
                    ChoiceOf {
                        .whitespace
                        "|"
                        "+"
                    }
                }
            } transform: {
                var positions: [Hierarchy.Position] = []
                for character in $0 {
                    switch character {
                    case "|": positions.append(.child)
                    case "+": positions.append(.presented)
                    default: break
                    }
                }
                return Hierarchy.Header(positions: positions)
            }
        }
    }
}
