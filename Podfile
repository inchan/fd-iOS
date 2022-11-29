# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
platform :ios, '14.0'

def pods
    use_frameworks!
    # RX
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'NSObject+Rx'
    
    # Networking
    pod 'Alamofire'
    pod 'RxAlamofire'
    
    # UI
    pod 'SDWebImage', '~> 4.x'
    pod 'Toaster'
    
    # Extensions
    pod 'SwifterSwift'    
end

target 'App' do
  pods
end

target 'AppTests' do
  pods
end
