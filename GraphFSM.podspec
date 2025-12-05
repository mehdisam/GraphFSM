Pod::Spec.new do |s|
  s.name             = 'GraphFSM'
  s.version          = '1.0.2'  # Bump version for re-release
  s.summary          = 'Graph-first, event-driven finite state machine library for Swift.'

  s.description      = <<-DESC
GraphFSM is a lightweight Swift library for defining finite state machines with separate graph and runtime.
It allows you to define state machines as graphs first, then create runtime instances that follow those graphs.
Features include: event-driven transitions, state validation, and easy integration with SwiftUI and Combine.
                       DESC

  s.homepage         = 'https://github.com/mehdisam/GraphFSM'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mehdi Samadi' => 'you@example.com' }  # Use your real name/email
  s.source           = {
    :git => 'https://github.com/mehdisam/GraphFSM.git',
    :tag => s.version.to_s
  }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_versions = ['5.5']  # ADD THIS LINE - crucial!

  s.source_files = 'Sources/GraphFSM/**/*.swift'
  s.requires_arc = true

  # Optional but recommended
  s.frameworks = 'Foundation'
end
