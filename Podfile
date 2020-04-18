platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Stocks' do
  # generic coordinator implementation for MVVM-RX architecture
  pod 'RxFlow', "2.7.0"
  # Best websocket implementation out there
  pod 'Starscream', '~> 4.0.0'
  # Uber dependency injection solution with compile time safety
  pod 'NeedleFoundation', '~> 0.13.0'
  # Json object wrapper to avoid temproray mapping objects
  pod 'W','0.1.0'
  
  target 'StocksTests' do
     inherit! :search_paths

     pod 'Quick'
     pod 'Nimble'
   end
end
