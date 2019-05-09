Pod::Spec.new do |s|
  s.name             = 'SwiftCSP'
  s.version          = '0.9.7'
  s.license          = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.summary          = 'A Constraint Satisfaction Problem Solver in Pure Swift'
  s.homepage         = 'https://github.com/davecom/SwiftCSP'
  s.social_media_url = 'https://twitter.com/davekopec'
  s.authors          = { 'David Kopec' => 'david@oaksnow.com' }
  s.source           = { :git => 'https://github.com/davecom/SwiftCSP.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'Sources/SwiftCSP/*.swift'
  s.requires_arc = true
end
