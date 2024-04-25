import Foundation

class IdeasViewModel: ObservableObject {
    @Published var ideaItems: [IdeaItem]
    private var appwriteService: Appwrite
    
    init() {
        self.ideaItems = []
        self.appwriteService = Appwrite.shared
    }
    
    public func loadIdeas() async {
        do {
            let response = try await self.appwriteService.listIdeas()
            // Mapping and updating on the main thread
            await MainActor.run {
                self.ideaItems = response.documents.map { document in
                    IdeaItem(
                        id: document.id,
                        idea: Idea(
                            userId: document.data.userId,
                            title: document.data.title,
                            description: document.data.description
                        )
                    )
                }
            }
        }
        catch {
            print("Could not load ideas")
        }
    }
    
    public func removeIdea(id: String) async {
        do {
            let _ = try await self.appwriteService.removeIdea(id: id)
            ideaItems.removeAll { $0.id == id }
        }
        catch {
            print("Could not remove idea")
        }
    }
    
    public func addIdea(title: String, description: String, userId: String) async {
        do {
            let idea = try await self.appwriteService.addIdea(
                title: title,
                description: description,
                userId: userId
            )
            await MainActor.run {
                ideaItems.insert(
                    IdeaItem(id: idea.id, idea: idea.data),
                    at: 0
                )
            }
        }
        catch {
            print("Could not add idea")
        }
        
    }
}
