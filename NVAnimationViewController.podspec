Pod::Spec.new do |s|

s.name         = "NVAnimationViewController"
s.version      = "0.1.7"
s.summary      = "Add animation at navigtionbar when view controller is scrolled."
s.description  = "You can set image and two button and add anything in AnimationViewController's tableview."
s.homepage     = "https://github.com/YangChing/AnimationViewController"
s.license      = "MIT"
s.author       = { "Feng YangChing" => "stormy.petrel@msa.hinet.net" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/YangChing/NVAnimationViewController.git", :tag => "0.1.7" }
s.source_files  = "NVAnimationViewController", "NVAnimationViewController/**/*.swift"
s.resources = 'NVAnimationViewController/**/*.{xib,png}'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }

end
