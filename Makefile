project:
	rm -rf Pods && bundle exec pod install && open WorldpayCSE.xcworkspace

reset_project:
	rm -rf WorldpayCSE.xcodeproj WorldpayCSE.xcworkspace && xcodegen

carthage_bootstrap:
	carthage bootstrap --use-xcframeworks --no-use-binaries --platform iOS