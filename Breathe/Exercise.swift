import SwiftData
import Foundation

@Model
class Exercise {
    @Attribute(.unique) var id: UUID
    var order: Int
    var title: String

    init(id: UUID = UUID(), order: Int, title: String) {
        self.id = id
        self.order = order
        self.title = title
    }
}
