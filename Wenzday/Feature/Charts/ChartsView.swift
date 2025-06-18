//
//  ChartsView.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI
import WebKit

struct ChartsView: View {
    @State private var webViewStore = WebViewStore()
    @State private var isLoading = false
    @State private var canGoBack = false
    @State private var canGoForward = false

    private let defaultURL = "https://example.com/"

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top navigation bar
                topNavigationBar

                // WebView
                WebViewRepresentable(
                    webViewStore: webViewStore,
                    url: defaultURL,
                    isLoading: $isLoading,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward
                )
                .clipped()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            loadDefaultURL()
        }
    }

    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack(spacing: 16) {
            // Title
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)

                Text("Dashboard")
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            Spacer()

            // Navigation buttons
            HStack(spacing: 12) {
                // Back button
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(canGoBack ? .primary : .secondary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(.regularMaterial)
                        )
                }
                .disabled(!canGoBack)

                // Forward button
                Button(action: goForward) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(canGoForward ? .primary : .secondary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(.regularMaterial)
                        )
                }
                .disabled(!canGoForward)

                // Refresh button
                Button(action: refresh) {
                    Image(
                        systemName: isLoading ? "stop.fill" : "arrow.clockwise"
                    )
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.blue)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(.regularMaterial)
                    )
                    .rotationEffect(.degrees(isLoading ? 0 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isLoading)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }

    // MARK: - Helper Methods
    private func loadDefaultURL() {
        webViewStore.loadURL(defaultURL)
    }

    private func refresh() {
        if isLoading {
            webViewStore.stopLoading()
        } else {
            webViewStore.reload()
        }
    }

    private func goBack() {
        webViewStore.goBack()
    }

    private func goForward() {
        webViewStore.goForward()
    }
}

// MARK: - WebView Store
class WebViewStore: ObservableObject {
    @Published var webView: WKWebView

    init() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
    }

    func loadURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }

    func reload() {
        webView.reload()
    }

    func stopLoading() {
        webView.stopLoading()
    }

    func goBack() {
        webView.goBack()
    }

    func goForward() {
        webView.goForward()
    }
}

// MARK: - WebView Representable
struct WebViewRepresentable: UIViewRepresentable {
    let webViewStore: WebViewStore
    let url: String
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = webViewStore.webView
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update navigation states
        DispatchQueue.main.async {
            self.canGoBack = uiView.canGoBack
            self.canGoForward = uiView.canGoForward
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebViewRepresentable

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation!
        ) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
        {
            parent.isLoading = false
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            parent.isLoading = false
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            parent.isLoading = false
        }
    }
}

#Preview {
    ChartsView()
}
