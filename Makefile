check-coverage:
	@dart pub global run full_coverage -i main.dart && flutter test --coverage && flutter pub global run test_cov_console --pass=40

report-coverage:
	@dart pub global run full_coverage -i main.dart && flutter test --coverage && flutter pub global run test_cov_console
