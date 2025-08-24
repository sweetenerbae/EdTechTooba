//
//  OnboardingPointsView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//

import SwiftUI

struct OnboardingRoleView: View {
    let onNext: () -> Void
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 16) {
                    RoleCard(emoji: "🧑🏻‍🏫", title: "Учитель", isSelected: selectedRole == "teacher")
                        .onTapGesture {
                            selectedRole = selectedRole == "teacher" ? nil : "teacher"
                        }

                    RoleCard(emoji: "🧑🏻‍🎓", title: "Ученик", isSelected: selectedRole == "student")
                        .onTapGesture {
                            selectedRole = selectedRole == "student" ? nil : "student"
                        }
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Выбор роли")
                        .foregroundColor(Color(hex: "#000000"))
                        .font(.system(size: 30, weight: .bold))

                    Text("Интерфейс и возможности будут зависить от выбора вашей роли")
                        .foregroundColor(Color(hex: "#232323"))
                        .font(.system(size: 20))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 32)
                .padding(.bottom, 30)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
        
            Spacer()
            
            ActionButton(title: "Далее",
                                   action: onNext,
                                   backgroundColor: Color.primaryPurple,
                                   foregroundColor: Color("whiteAsset"))
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .background(Color("whiteAsset"))
    }
}

#Preview {
    OnboardingPointsView(onNext: {})
}
