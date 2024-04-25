//
//  ContentView.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import SwiftUI
import AppwriteModels

struct IdeasView: View {
    @StateObject var ideasViewModel: IdeasViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @State private var title: String = ""
    @State private var description: String = ""
    @FocusState private var focusedTextField: FormTextField?
    
    init() {
        self.title = ""
        self.description = ""
        let ideasViewModel = IdeasViewModel()
        _ideasViewModel = StateObject(wrappedValue: ideasViewModel)

    }
    
    enum FormTextField {
        case title, description
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("Add Ideas")
                .font(.title2)
                .fontWeight(.bold)
                .padding(10)
            Form {
                Section {
                    TextField("Title", text: $title)
                        .onSubmit { focusedTextField = .description }
                        .submitLabel(.next)
                    
                    TextField("Description",
                              text: $description,
                              axis: .vertical
                    )
                    .onSubmit { focusedTextField = nil }
                    .submitLabel(.continue)
                    HStack{
                        Spacer()
                        Button(
                            "Add Idea",
                            action: {
                                Task {
                                    await self.ideasViewModel.addIdea(
                                        title: self.title,
                                        description: self.description,
                                        userId: self.loginViewModel.userId
                                    )
                                    title = ""
                                    description = ""
                                }
                            }
                        ).buttonStyle(.borderedProminent)
                    }
                }
            }.frame(height: 200)
            
            List {
                Section (header: Text("Ideas")) {
                    ForEach(self.ideasViewModel.ideaItems) { item in
                        HStack (alignment: .center, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text(item.idea.title)
                                    .font(.headline)
                                    .padding(.bottom, 1)
                                
                                Text(item.idea.description)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(
                                "Remove",
                                action: {
                                    Task{
                                        await self.ideasViewModel
                                            .removeIdea(
                                                id: item.id
                                            )
                                    }
                                }
                            )
                            .disabled(loginViewModel.userId != item.idea.userId)
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            
        }
        .task {
            await self.ideasViewModel.loadIdeas()
        }
    }
}

// Preview provider
struct IdeasView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasView()
            .environmentObject(LoginViewModel())
            .environmentObject(Router())
    }
}
