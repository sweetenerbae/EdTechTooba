//
//  ChatView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm = ChatVM()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .padding(.trailing, 8)
                    Text("ChatGPT")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(Color.labelBlack)
                            .frame(width: 40, height: 40)
                            .background(Color.cardGray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Text(vm.onlineText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.green)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .background(Color(uiColor: .systemGray6))

            // Сообщения
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.messages) { msg in
                            HStack {
                                if msg.isUser { Spacer(minLength: 40) }
                                Text(msg.text)
                                    .font(.system(size: 17))
                                    .foregroundStyle(msg.isUser ? Color("whiteAsset") : Color.labelBlack)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(msg.isUser ? Color.labelBlack : Color.cardGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 22))
                                if !msg.isUser { Spacer(minLength: 40) }
                            }
                            .id(msg.id)
                            .padding(.horizontal, 12)
                        }
                        if vm.sending { ProgressView().padding(.top, 4) }
                        Color.clear.frame(height: 8).id("bottom")
                    }
                    .padding(.top, 8)
                }
                .onChange(of: vm.messages) { _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }

            // Инпут панель
            HStack(spacing: 12) {
                TextField("Сообщение", text: $vm.input, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.cardGray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Button(action: vm.send) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(Color("whiteAsset"))
                        .frame(width: 44, height: 44)
                        .background(Color.labelBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(vm.sending)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
        .hideKeyboardOnTap()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { _ = UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }) {
                    EmptyView()
                }
            }
        }
    }
}
