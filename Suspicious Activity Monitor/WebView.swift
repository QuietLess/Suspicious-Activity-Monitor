//
//  WebView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 20.12.2024.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    //livefeed aslında bize bir web sekmesi gösteriyor. livefeed local ağ'da yayınlandığı için biz kameramızı görüyoruz.
    //bu da livefeed'in kamerayı gösterebilmesi için yazdığım webview kısmı.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        //update yok
    }
}
