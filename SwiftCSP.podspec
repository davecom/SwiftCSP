Pod::Spec.new do |s|
  s.name             = 'SwiftCSP'
  s.version          = '0.9.9'
  s.license          = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.summary          = 'A Constraint Satisfaction Problem Solver in Pure Swift'
  s.homepage         = 'https://github.com/davecom/SwiftCSP'
  s.social_media_url = 'https://twitter.com/davekopec'
  s.authors          = { 'David Kopec' => 'david@oaksnow.com' }
  s.source           = { :git => 'https://github.com/davecom/SwiftCSP.git', :tag => s.version }
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6']
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'Sources/SwiftCSP/*.swift'
  s.requires_arc = true
end
