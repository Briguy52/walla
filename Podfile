# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
inhibit_all_warnings!
use_frameworks!

target 'Walla' do
pod 'Firebase', '>= 2.5.0'
pod 'SlackTextViewController', ' >= 1.5.2'
pod 'RxSwift', '>= 1.8.1'
pod 'RxCocoa', '>= 1.8.1'
pod 'FirebaseRxSwiftExtensions', '>= 0.6'
pod "Lock", "~> 1.22"
pod "Lock-Facebook", "~> 2.2"
pod "JWTDecode", "~> 1.0"
pod "SimpleKeychain", "~> 0.3"
pod "MBProgressHUD", "~> 0.9"
pod 'Alamofire', '~> 3.0'
pod 'SnapKit'

end

post_install do |installer|
    installer.pods_project.build_configurations.each { |bc|
        bc.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    }
end