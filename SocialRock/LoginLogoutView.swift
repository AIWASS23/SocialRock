//
//  LoginLogoutView.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 17/08/22.
//

import SwiftUI

@ObservedObject var viewModel: SignInViewModel

struct LoginLogoutView: View {
    var body: some View {
        HStack {
            Spacer()

            VStack {
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    Text("Password")
                    SecureField("Password", text: $viewModel.password)
                }
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isSigningIn)

                if viewModel.isSigningIn {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button("Sign In") {
                        viewModel.signIn()
                    }
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: 400.0)

            Spacer()
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Sign In Failed"),
                message: Text("The email/password combination is invalid.")
            )
        }
    }
}


struct LoginLogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLogoutView()
    }
}
