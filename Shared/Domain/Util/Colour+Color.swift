import SwiftUI

public extension Colour {
    init(from color: Color) {
        let components = UIColor(color).cgColor.components ?? [0, 0, 0, 0]
        self.red = Double(components[0])
        self.green = Double(components[1])
        self.blue = Double(components[2])
        self.opacity = Double(components[3])
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
