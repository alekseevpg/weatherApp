//
//  LoadingButton.swift
//  WeatherApp
//
//  Created by alekseevpg.
//

import SwiftUI

@MainActor
struct LoadingButton<Label: View>: View {
    var tintColor: Color
    var action: () async -> Void
    @ViewBuilder var label: () -> Label

    init(
        tintColor: Color = .white,
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.tintColor = tintColor
        self.action = action
        self.label = label
    }

    @State fileprivate var isPerformingTask = false

    var body: some View {
        Button(
            role: isPerformingTask ? .cancel : nil,
            action: {
                isPerformingTask = true

                Task {
                    await action()
                    isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    label()
                        .opacity(isPerformingTask ? 0 : 1)
                    ProgressView()
                        .foregroundColor(.yellow)
                        .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                        .frame(height: 32, alignment: .center)
                        .opacity(isPerformingTask ? 1 : 0)
                }
            }
        )
        .disabled(isPerformingTask)
    }
}

extension LoadingButton where Label == Text {
    init(
        _ label: String,
        action: @escaping () async -> Void
    ) {
        self.init(action: action) {
            Text(label)
        }
    }
}

extension LoadingButton where Label == Image {
    init(
        systemImageName: String,
        action: @escaping () async -> Void
    ) {
        self.init(action: action) {
            Image(systemName: systemImageName)
        }
    }
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingButton {
            do { try await Task.sleep(s: 10) } catch { }
        } label: {
            Text("Hello")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
