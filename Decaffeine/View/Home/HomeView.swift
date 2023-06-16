//
//  HomeView.swift
//  Decaffeine
//
//  Created by JunHyuk Lim on 29/1/2023.
//

import SwiftUI

struct HomeView: View {
    //MARK: - PROPERTIES
    @State var hasTapped : Bool = false
    @EnvironmentObject var sharedDataViewModel : ShareDataViewModel
    
    @State var isPresenting = false
    
    let maximumCaffeinePerDay : Double = 400
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack{
                Text("DECAF")
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        header
                            .padding(.vertical,12)
                            .padding(.horizontal, 32)
                        
                        Spacer()
                            .frame(maxHeight: 32)
                        
                        coffeeListImage
                        
                        VStack{
                            coffeeCountText
                                .padding(.bottom, 10)
                            
                            coffeeProgressBar
                        }
                        .padding(.horizontal, 32)
                        
                        addNewButton
                            .padding(.vertical, 20)
                            .padding(.horizontal, 32)
                    }
                    
                }
            }
        }
    }
    
    //MARK: - COMPONENTS
    
    //HEADER
    fileprivate var header : some View {
        HStack(alignment: .center) {
            Text("Today,")
                .font(.system(size: 32))
                .fontWeight(.bold)
            
            Text(dateFormatter.string(from: Date()))
                .font(.system(size: 32))
                .fontWeight(.light)
            
            Spacer()
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    fileprivate var coffeeListImage : some View {
        VStack{
            if sharedDataViewModel.selectedBeverages.filter({ calendar.isDate($0.registerDate, inSameDayAs: Date()) }).isEmpty {
                noList
                    .frame(height: 400)
                    .padding(.vertical, 10)
            } else {
                TabView{
                    ForEach(sharedDataViewModel.selectedBeverages) { item in
                        BeverageCardView(beverageName: item.name, beverageImageName: item.imageName)
                    }
                }
                .frame(height: 400)
                .tabViewStyle(PageTabViewStyle())
            }
        }
    }
    
    
    //COFFEE LIST DETAIL
    fileprivate var noList : some View {
        VStack(spacing: 8){
            Image("noList")
            
            Text(sharedDataViewModel.numberOfBeveragesForToday() == 0 ? "You haven't had any coffee yet" : "You have no coffee history for this day")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("mainColor"))
            
            //Coffee Shot & Caffeine Content
            Text(sharedDataViewModel.numberOfBeveragesForToday() == 0 ? "Create your caffeine history" : "Add your first coffee for the day")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundColor(Color("mainColor").opacity(0.6))
        }
    }
    
    
    //COFFEE COUNT TEXT
    fileprivate var coffeeCountText : some View {
        HStack{
            Text("You've had \(sharedDataViewModel.numberOfBeveragesForToday()) coffees")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color("mainColor").opacity(0.8))
            
            Spacer()
        }
    }
    
    //PROGRESS BAR
    fileprivate var coffeeProgressBar : some View {
        VStack{
            HStack{
                Text("Today's Caffeine")
                
                Spacer()
                
                HStack{
                    Text("\(String(format: "%.1f", sharedDataViewModel.totalCaffeineForToday()))")
                    //                       .foregroundColor(sharedDataViewModel.totalCaffeineForToday < maximumCaffeinePerDay ? Color("mainColor") : Color.red)
                    Text("/ \(String(format: "%.1f", maximumCaffeinePerDay))mg")
                    
                }
                
            }
            //
            //            ProgressBar(todayIntake: Double(sharedDataViewModel.totalCaffeineForToday()) , totalIntake: Double(maximumCaffeinePerDay))
        }
    }
    
    //BUTTON
    fileprivate var addNewButton : some View {
        NavigationLink {
            BeverageSelectView()
        } label: {
            Text("+ Add New Caffeine")
        }
        .buttonStyle(ActiveButtonStyle())
    }
}


//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ShareDataViewModel())
    }
}
