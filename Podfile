# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'DemoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  #pod 'Eureka'
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'xcode12'
  pod 'AP_PaySDK', '2.6.12'
  pod 'Alamofire'
#  pod 'MLeaksFinder'
  #pod 'AP_PaySDK', '2.1.6'
#pod 'AP_PaySDK', '2.4.30'
  pod 'NVActivityIndicatorView', '4.8.0'
#  pod 'Material'
#  pod 'IQKeyboardManager'
#  pod 'IQKeyboardManagerSwift'

  # For xcode 13.3
  # Fix issue of type of id<NSCopying> _Nonnull
#  pod 'FBRetainCycleDetector'

  # Fix fishhook issue
#  pod 'MLeaksFinder', :configurations => ['Debug']
#    post_install do |installer|
#        ## Fix for XCode 12.5
#        find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
#          "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
#        ## Fix for XCode 13.0
#          find_and_replace("Pods/FBRetainCycleDetector/fishhook/fishhook.c",
#          "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;", "if (i < (sizeof(indirect_symbol_bindings) / sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }")
#    end
end

target 'DemoApp-Objc' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'AP_PaySDK', '2.6.12'
  pod 'Alamofire'
  # pod 'AP_PaySDK', '2.1.6'
# pod 'AP_PaySDK', '2.4.30'
  pod 'NVActivityIndicatorView', '4.8.0'
#  pod 'Material'
  pod 'IQKeyboardManager'
  #pod 'IQKeyboardManagerSwift'
  
  # For xcode 13.3
  # Fix issue of type of id<NSCopying> _Nonnull
#  pod 'FBRetainCycleDetector'

end
#
#def find_and_replace(dir, findstr, replacestr)
#  Dir[dir].each do |name|
#      text = File.read(name)
#      replace = text.gsub(findstr,replacestr)
#      if text != replace
#          puts "Fix: " + name
#          File.open(name, "w") { |file| file.puts replace }
#          STDOUT.flush
#      end
#  end
#  Dir[dir + '*/'].each(&method(:find_and_replace))
#end
