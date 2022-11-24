//
//  HomeView.swift
//  location
//
//  Created by Daniel Ferrer on 24/11/22.
//

import SwiftUI
import Factory

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel = Container.homeViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.homeViewModel.register { MockHomeViewModel() }
        HomeView()
    }
}
#endif
