.PHONY: gen

gen:
	fvm flutter pub run build_runner clean
	fvm flutter pub run build_runner build --delete-conflicting-outputs

autogen:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs
