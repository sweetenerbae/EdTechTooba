import SwiftUI
import FirebaseFunctions

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let time = Date()
}

final class ChatVM: ObservableObject {
    @Published var input: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var onlineText: String = "Онлайн"
    @Published var sending = false

    private let functions = Functions.functions(region: "us-central1")

    func send() {
        let prompt = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty, !sending else { return }
        sending = true

        // локально добавляем сообщение пользователя
        messages.append(.init(text: prompt, isUser: true))
        input = ""

        // вызов callable-функции: askGPTCallable
        functions.httpsCallable("askGPTCallable")
            .call(["prompt": prompt]) { [weak self] result, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.sending = false
                    if let dict = result?.data as? [String: Any],
                       let text = dict["text"] as? String {
                        self.messages.append(.init(text: text, isUser: false))
                    } else {
                        self.messages.append(
                            .init(text: "Не удалось получить ответ. \(error?.localizedDescription ?? "")",
                                  isUser: false)
                        )
                    }
                }
            }
    }
}
