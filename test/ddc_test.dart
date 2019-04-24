import 'package:test/test.dart';
import 'package:ddc/ddc.dart';

class DataProviderTest {}

const DataProviderTag = Tag<DataProviderTest>();
const GlobalDataProviderTag = Tag<DataProviderTest>(singleton: true);


void main() {
  test('resolve new instance', () {
    final builder = getDiBuilder();
    builder.register(DataProviderTag, (dc, args) => DataProviderTest());

    final dc = builder.build();

    final x = dc.resolve(DataProviderTag);
    expect(x, isNotNull);

    final y = dc.resolve(DataProviderTag);
    expect(y, isNotNull);

    expect(identical(x, y), false);
  });

  test('resolve singleton', () {
    final builder = getDiBuilder();
    builder.register(GlobalDataProviderTag, (dc, args) => DataProviderTest());

    final dc = builder.build();

    final x = dc.resolve(GlobalDataProviderTag);
    final y = dc.resolve(GlobalDataProviderTag);

    expect(x, isNotNull);
    expect(identical(x, y), true);
  });

  test('resolve with argument', () {
    const IntTag = Tag<int>();

    final builder = getDiBuilder();
    builder.register(IntTag, (dc, argument) {
      expect(dc, isNotNull);
      expect(argument is int, true);
      return argument as int;
    });

    final dc = builder.build();

    expect(dc.resolve(IntTag, 3), equals(3));
    expect(dc.resolve(IntTag, 123), equals(123));
  });

  test('put ready instance', () {
    final x = DataProviderTest();

    final builder = getDiBuilder();
    builder.put(GlobalDataProviderTag, x);

    final dc = builder.build();

    final y = dc.resolve(GlobalDataProviderTag);
    expect(identical(x, y), true);
  });

  test('different factories for the same type', () {
    const XIntTag = Tag<int>(id: 'xint');
    const YIntTag = Tag<int>(id: 'yint');
    expect(identical(XIntTag, YIntTag), false);

    const xvalue = 1;
    const yvalue = 2;

    final builder = getDiBuilder();
    builder.register(XIntTag, (dc, args) => xvalue);
    builder.register(YIntTag, (dc, args) => yvalue);

    final dc = builder.build();

    final x = dc.resolve(XIntTag);
    expect(x, equals(xvalue));

    final y = dc.resolve(YIntTag);
    expect(y, equals(yvalue));
  });

  test('object creators', () {
    final builder = getDiBuilder();
    builder.register(DataProviderTag, (dc, args) => DataProviderTest());

    final dc = builder.build();

    final dataProviderCreator = dc.creator(DataProviderTag);
    expect(dataProviderCreator, isNotNull);
    expect(dataProviderCreator is Function, true);

    final dp = dataProviderCreator();
    expect(dp, isNotNull);
  });

  test('creator with argument', () {
    const reference = 5;
    const IntTag = Tag<int>();

    final builder = getDiBuilder();
    builder.register(IntTag, (dc, args) {
      expect(dc, isNotNull);
      expect(args is int, true);
      return args as int;
    });

    final dc = builder.build();

    final creator = dc.creator(IntTag);
    final value = creator(reference);

    expect(value, equals(reference));
  });
}
