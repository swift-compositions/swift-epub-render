// EPUB.swift
//
// EPUB rendering namespace and utilities.

/// Namespace for EPUB rendering utilities.
public enum EPUB {}

// MARK: - XML Escaping

/// Escape special characters for XML content.
@usableFromInline
func escapeXML(_ string: String) -> String {
    var result = ""
    result.reserveCapacity(string.count)
    for char in string.unicodeScalars {
        switch char {
        case "&":
            result += "&amp;"

        case "<":
            result += "&lt;"

        case ">":
            result += "&gt;"

        case "\"":
            result += "&quot;"

        case "'":
            result += "&apos;"

        default:
            result.append(Character(char))
        }
    }
    return result
}

// MARK: - ISO 8601 Date

extension EPUB {
    /// Generate ISO 8601 date string for EPUB dcterms:modified.
    ///
    /// Format: YYYY-MM-DDTHH:MM:SSZ
    public static func iso8601Date(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0
    ) -> String {
        String(
            format: "%04d-%02d-%02dT%02d:%02d:%02dZ",
            year,
            month,
            day,
            hour,
            minute,
            second
        )
    }
}

// Helper for String format without Foundation
extension String {
    init(format: String, _ arguments: Int...) {
        var result = ""
        var argIndex = 0
        var i = format.startIndex

        while i < format.endIndex {
            if format[i] == "%" && format.index(after: i) < format.endIndex {
                let next = format.index(after: i)
                if format[next] == "0" {
                    // Parse width specifier like %04d
                    var width = 0
                    var j = next
                    while j < format.endIndex {
                        let c = format[j]
                        if c.isNumber {
                            width = width * 10 + Int(String(c))!
                        } else if c == "d" {
                            if argIndex < arguments.count {
                                let num = arguments[argIndex]
                                var numStr = String(num)
                                while numStr.count < width {
                                    numStr = "0" + numStr
                                }
                                result += numStr
                                argIndex += 1
                            }
                            i = format.index(after: j)
                            break
                        } else {
                            break
                        }
                        j = format.index(after: j)
                    }
                    continue
                }
            }
            result.append(format[i])
            i = format.index(after: i)
        }

        self = result
    }
}
