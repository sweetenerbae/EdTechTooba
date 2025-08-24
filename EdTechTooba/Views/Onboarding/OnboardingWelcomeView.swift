//
//  OnboardingWelcomeView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Перемена")
                        .font(.system(size: 28, weight: .bold))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.labelBlack)
                    
                    Text("Приложение с удобным и быстрым доступом к полезной информации и механикам для школьников")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Color.labelBlack)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            .padding(.top, 40)
            
            Spacer()
            
            ActionButton(title: "Далее",
                                   action: onNext,
                                   backgroundColor: Color.primaryRed,
                                   foregroundColor: Color("whiteAsset"))
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .background(Color("whiteAsset"))
    }
}

#Preview {
    OnboardingWelcomeView(
        onNext: {}
    )
}
