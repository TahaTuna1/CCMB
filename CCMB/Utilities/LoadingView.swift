


// 21/04/2023 Loading View


import SwiftUI


struct LoadingView: View{ // Show loading view until the fetching is complete. Need to add isLoading.
    var body: some View{
        
            ProgressView() // New way SwiftUI. Title optional
                .progressViewStyle(CircularProgressViewStyle(tint: .mint))
            
        
    }
}
