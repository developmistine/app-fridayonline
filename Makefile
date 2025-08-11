delpod:
	sudo rm -f ios/Podfile.lock | sudo arch -x86_64 gem install ffi

clean:
	flutter clean | flutter pub get

release:
	flutter run --release

