Pod::Spec.new do |s|
  s.name         = "MWMarqueeView"
  s.version      = "0.0.1"
  s.summary      = "跑马灯实现."
  #s.description  = <<-"A customized select list view."
  #                 "A customized select list view."
  s.homepage     = "https://github.com/fishmwei/MWMarqueeView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "fishmwei" => "fishmwei@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/fishmwei/MWMarqueeView.git", :tag => "0.0.1" }
  s.source_files  = "MWMarqueeView", "MWMarqueeView/*.{h,m,png}"
  s.requires_arc = true
end
