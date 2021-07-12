//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Anthony Da Cruz on 12/01/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var apiData: RickMortyAPI
    let colors: [Color] = [.red, .green, .blue, .orange, .white, .pink]
    
    var body: some View {
        if apiData.isFetching || apiData.fetchedCharacterList.count == 0 {
            VStack {
                ProgressView()
            }.onAppear(perform: {
                apiData.fetchRickMortyCharacterList()
            })
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 75) {
                    ForEach(apiData.fetchedCharacterList, id: \.self) { character in
                        ZStack {
                        GeometryReader { geo in
                            CharacterCard(imageUrl: character.image!)
                                    .frame(width: 230, height: 350)
                                    .rotation3DEffect(
                                        Angle(degrees: Double((geo.frame(in: .global).minX - 40)) / -20),
                                        axis: (x: 0.0, y: 15.0, z: -0.0),
                                        anchor: .center,
                                        anchorZ: 1.0,
                                        perspective: 1.0
                                    )
                            
                        }
                        .frame(width: 230, height: 350, alignment: .center)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 15)
                        }
                    }
                }
                .padding(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(apiData: RickMortyAPI())
    }
}
