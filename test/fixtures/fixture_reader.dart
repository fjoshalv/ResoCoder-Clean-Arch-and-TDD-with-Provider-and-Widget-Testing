import 'dart:io';

const _fixturesPath = 'test/fixtures';
String fixture(String name) => File('$_fixturesPath/$name').readAsStringSync();
