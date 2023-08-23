//
//  ErrorHandler.swift
//  WeatherApp
//
//  Created by Pavel Alekseev on 02.12.2021.

import SwiftUI

@MainActor
protocol ErrorHandler {
    @MainActor
    func handle<T: View>(
        _ error: Binding<BackendError?>,
        in view: T,
        retryHandler: @Sendable @escaping () async -> Void
    ) -> AnyView
}

@MainActor
struct AlertErrorHandler: ErrorHandler {
    // We give our handler an ID, so that SwiftUI will be able
    // to keep track of the alerts that it creates as it updates
    // our various views:
    private let id = UUID()

    func handle<T: View>(
        _ error: Binding<BackendError?>,
        in view: T,
        retryHandler: @Sendable @escaping () async -> Void
    ) -> AnyView {
        var isPresented = error.wrappedValue != nil

        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
        return AnyView(
            view.alert(
                error.wrappedValue?.errorTitle ?? "Error",
                isPresented: binding,
                presenting: error.wrappedValue,
                actions: { _ in
                    makeAlertAction(for: error, retryHandler: retryHandler)
                },
                message: { error in
                    Text(error.errorMessage)
                }
            ).id(id)
        )
    }
}

enum ErrorCategory {
    case nonRetryable
    case retryable
    case needsAppUpdate
}

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}

extension Error {
    func resolveCategory() -> ErrorCategory {
        guard let categorized = self as? CategorizedError else {
            // We could optionally choose to trigger an assertion
            // here, if we consider it important that all of our
            // errors have categories assigned to them.
            return .nonRetryable
        }

        return categorized.category
    }
}

extension BackendError: CategorizedError {
    var category: ErrorCategory {
        switch self {
        case  .notFound:
            return .nonRetryable
        case  .sadServer, .noData, .invalidHTTPStatusCode, .badNetwork, .urlError:
            return .retryable
        case .inlineError(_):
            return .nonRetryable
        }
    }
}

private extension AlertErrorHandler {
    @ViewBuilder
    func makeAlertAction(for error: Binding<BackendError?>, retryHandler: @Sendable @escaping () async -> Void) -> some View {
        if let wrappedError = error.wrappedValue {
            switch wrappedError.resolveCategory() {
            case .needsAppUpdate:
                Button("Open TestFlight", action: {
                    error.wrappedValue = nil
                    DispatchQueue.main.async {
                        guard let testFlightURL = URL(string: "itms-beta://") else { return }
                        UIApplication.shared.open(testFlightURL, options: [:], completionHandler: nil)
                    }
                })
            case .retryable:
                Button("Dismiss") { error.wrappedValue = nil }
                Button("Retry") {
                    error.wrappedValue = nil
                    Task.detached(priority: .background) { await retryHandler() }
                }
            case .nonRetryable:
                Button("Dismiss") {
                    error.wrappedValue = nil
                }
            }
        } else {
            Button("Dismiss") {
                error.wrappedValue = nil
            }
        }
    }
}

@MainActor
struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    @MainActor
    static var defaultValue: ErrorHandler = AlertErrorHandler()
}

extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}

extension View {
    @MainActor
    func emittingError(
        _ error: Binding<BackendError?>,
        retryHandler: @MainActor @Sendable @escaping () async -> Void = { }
    ) -> some View {
        modifier(ErrorEmittingViewModifier(
            error: error,
            retryHandler: retryHandler
        ))
    }
}

@MainActor
struct ErrorEmittingViewModifier: ViewModifier {
    @Environment(\.errorHandler) var handler

    @Binding var error: BackendError?
    var retryHandler: @Sendable () async -> Void

    func body(content: Content) -> some View {
        handler.handle(
            $error,
            in: content,
            retryHandler: retryHandler
        )
    }
}
