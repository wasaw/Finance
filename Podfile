# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'Finance' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Finance

pod 'Firebase'
pod 'FirebaseAuth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'SwiftLint'
pod 'DGCharts'
     
  target 'FinanceUnitTests' do
    inherit! :search_paths
   # pod 'Firebase'
  end
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end