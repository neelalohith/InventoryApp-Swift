import Foundation

class Page2ViewModel: ObservableObject {
    
    
    // convert this to a viewmodel MVVM structure
    func getResponseFromServer() async throws -> InventoryResponse {
        let endPoint = "https://raw.githubusercontent.com/neelalohith/InventoryApp-Swift/main/Inventory.json"
        guard let url = URL(string: endPoint) else {
            throw InventoryError.URLError
        }
        let (data, response) =  try await URLSession.shared.data(from: url) // type -> 2
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            // todo
            throw InventoryError.ResponseError
        }
        let decoder = JSONDecoder()
        let inventoryResponse = try decoder.decode(InventoryResponse.self, from: data)
        
        return inventoryResponse
    }
}

enum InventoryError: Error {
    case ResponseError
    case URLError
}

struct InventoryResponse: Codable { // conforms to a protocol Codable
    var inventories: [Inventory]
}

struct Inventory: Codable, Identifiable{
    let id = UUID()
    var name: String
    var url: String
    var count: Int
}

