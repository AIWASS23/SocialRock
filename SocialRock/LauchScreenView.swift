//
//  LauchScreenView.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 11/08/22.
//

import SwiftUI

struct LaunchScreenView: View {

    @State private var rodarRetangulo = false
    @State private var tilt = false
    @State private var fecharRetangulo = false
    @State private var zeroOpaco = false
    @State private var novoRetangulo = false

    var body: some View {
        VStack {
            ZStack{

                Text(/*systemName: */ "🤘")
                    .font(.system(size: 200))
                    .rotation3DEffect(Angle(degrees: tilt ? 0 : -90), axis: (x: 1, y: 0, z: 0))
                    .animation(.linear(duration: 1), value: tilt)
                    .opacity(zeroOpaco ? 0 : 1)
                    .animation(.easeOut(duration: 0.5).delay(1.2), value: zeroOpaco)

                Rectangle()
                    .stroke(.red, lineWidth: 10)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: rodarRetangulo ? 90 : 0))
                    .animation(.linear(duration: 1), value: rodarRetangulo)
                    .scaleEffect(novoRetangulo ? 1 : 0)
                    .animation(.default.delay(1.7), value: novoRetangulo)

                Rectangle()
                    .fill(Color.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .scaleEffect(novoRetangulo ? 1 : 0)
                    .animation(.default.delay(1.7), value: novoRetangulo)
            }
            .onAppear() {
                rodarRetangulo = true
                tilt = true
                fecharRetangulo = true
                zeroOpaco = true
                novoRetangulo = true
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
