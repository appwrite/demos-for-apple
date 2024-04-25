//
//  ContentView.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import SwiftUI
import AppwriteModels

struct IdeasView: View {
    @EnvironmentObject private var IdeasViewModel: IdeasViewModel
    @EnvironmentObject private var LoginViewModel: LoginViewModel
    @State private var title = ""
    @State private var description = ""
    @FocusState private var focusedTextField: FormTextField?
    
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
                                    await self.IdeasViewModel.addIdea(
                                        title: self.title,
                                        description: self.description,
                                        userId: self.LoginViewModel.userId
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
                    ForEach(self.IdeasViewModel.ideaItems) { item in
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
                                        await self.IdeasViewModel
                                            .removeIdea(
                                                id: item.id
                                            )
                                    }
                                }
                            )
                            .disabled(LoginViewModel.userId != item.idea.userId)
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            
        }
        .task {
            await self.IdeasViewModel.loadIdeas()
        }
    }
}

// Preview provider
struct IdeasView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasView()
            .environmentObject(LoginViewModel())
            .environmentObject(IdeasViewModel())
            .environmentObject(Router())
    }
}
