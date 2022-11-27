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
        VStack(spacing: 10) {
            HStack {
                Text("Status: \(viewModel.locationStatus?.rawValue ?? 0)")
                Spacer()
            }
            
            HStack {
                if let location = viewModel.location {
                    Text("Current location \(location.coordinate.latitude) - \(location.coordinate.longitude)")
                }
                Spacer()
            }
            
            Spacer()
        }.onAppear {
            viewModel.loadLocation()
        }
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
