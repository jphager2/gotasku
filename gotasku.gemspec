files = Dir.glob(Dir.pwd + '/**/*.rb')
files.collect! {|file| file.sub(Dir.pwd + '/', '')}
files -= files.select {|file| file =~ /scripts/}
files.push('LICENSE', 'README.md', 'rakefile', 'bin/gotasku')

Gem::Specification.new do |s|
  s.name        = 'gotasku'
  s.version     = '0.0.0'
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/gotasku'
  s.summary     = 'Downloads SGFs of go problems'
  s.description = 'A gem to download SGFs of go problems'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'
end
