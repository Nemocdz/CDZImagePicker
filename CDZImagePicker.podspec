Pod::Spec.new do |s|
  s.name         = "CDZImagePicker"
  s.version      = "1.0.0"
  s.summary      = "A beatiful Imagepickercontroller easy to use"
  s.homepage     = "https://github.com/Nemocdz/CDZImagePicker"
  s.license      = "MIT"
  s.authors      = { 'Nemocdz' => 'nemocdz@gmail.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Nemocdz/CDZImagePicker.git", :tag => s.version }
  s.source_files = 'CDZImagePicker', 'CDZImagePicker/**/*.{h,m}'
  s.requires_arc = true
end
