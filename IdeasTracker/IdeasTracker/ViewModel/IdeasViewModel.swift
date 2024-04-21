import Foundation

class IdeasViewModel: ObservableObject {
    @Published var ideaItems: [IdeaItem]
    private var appwriteService: Appwrite
    
    init() {
        self.ideaItems = []
        self.appwriteService = Appwrite()
    }
    
    @MainActor public func loadIdeas() async {
        let response = try! await self.appwriteService.listIdeas()
        // Mapping and updating on the main thread
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
    
    public func removeIdea(id: String) async {
        let _ = try! await self.appwriteService.removeIdea(id: id)
    }
    
    @MainActor public func addIdea(title: String, description: String, userId: String) async {
        
        let idea = try! await self.appwriteService.addIdea(
            title: title,
            description: description,
            userId: userId
        )
        ideaItems.insert(
            IdeaItem(id: idea.id, idea: idea.data),
            at: 0
        )
        
    }
}
