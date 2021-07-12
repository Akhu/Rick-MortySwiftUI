//
//  NetworkImage.swift
//  RickAndMorty
//
//  Created by Anthony Da Cruz on 12/01/2021.
//
import Foundation
import SwiftUI

final class Loader: ObservableObject {
    
    var task: URLSessionDataTask!
    @Published var loadStatus:String = "no"
    @Published var data: Data? = nil
    
    init(urlRequest: URLRequest){
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data,urlResponse,error in
            DispatchQueue.main.async {
                self.data = data
            }
            
            if(self.data != nil) {
                DispatchQueue.main.async {
                    self.loadStatus = "loaded"
                }
            }
        })
        task.resume()
    }
    
    init(_ url: URL) {
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            DispatchQueue.main.async {
                self.data = data
            }
        })
        task.resume()
    }
    deinit {
        task.cancel()
    }
}

let placeholder = UIImage(systemName: "photo")!

public struct AsyncImage: View {
    public init(url: URL) {
        self.imageLoader = Loader(url)
    }
    
    public init(urlRequest: URLRequest){
        self.imageLoader = Loader(urlRequest: urlRequest)
    }
    
    @ObservedObject private var imageLoader: Loader
    
    var image: UIImage? {
        return imageLoader.data.flatMap(UIImage.init)
    }
    public var body: some View {
            Image(uiImage: image ?? placeholder)
    }
}
