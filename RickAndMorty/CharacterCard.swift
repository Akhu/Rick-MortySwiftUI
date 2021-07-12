//
//  CharacterCard.swift
//  RickAndMorty
//
//  Created by Anthony Da Cruz on 12/01/2021.
//

import SwiftUI

struct CharacterCard: View {
    let imageUrl: String
    var body: some View {
        VStack {
        AsyncImage(url: URL(string: imageUrl)!)
            .aspectRatio(contentMode: .fill)
        }.clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}

struct CharacterCard_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCard(imageUrl: "https://gopix.jrmbx.ovh/random?hashtags=goat:ibex&width=400&height=600")
    }
}
