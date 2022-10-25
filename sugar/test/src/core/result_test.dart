import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {
  group('Success', () {
    test('map same type', () => expect(Success<int, String>(1).map((val) => val + 1), Success<int, String>(2)));

    test('map different type', () => expect(Success<int, DateTime>(1).map((val) => val.toString()), Success<String, DateTime>('1')));

    test('mapFailure', () => expect(Success<String, int>('1').mapFailure((val) => 404), Success<String, int>('1')));


    test('bind success, same type', () => expect(Success<int, String>(1).bind((val) => Success(val + 1)), Success<int, String>(2)));

    test('bind success, different type', () => expect(Success<int, DateTime>(1).bind((val) => Success(val.toString())), Success<String, DateTime>('1')));

    test('bind failure', () => expect(Success<int, String>(1).bind((_) => Failure<int, String>('value')), Failure<int, String>('value')));

    test('bindFailure', () => expect(Success<String, int>('1').bindFailure((val) => Failure(404)), Success<String, int>('1')));


    test('pipe success, same type', () async => expect(await Success<int, String>(1).pipe((val) async => Success(val + 1)), Success<int, String>(2)));

    test('pipe success, different type', () async => expect(await Success<int, DateTime>(1).pipe((val) async => Success(val.toString())), Success<String, DateTime>('1')));

    test('pipe failure', () async => expect(await Success<int, String>(1).pipe((_) async => Failure<int, String>('value')), Failure<int, String>('value')));

    test('pipeFailure', () async => expect(await Success<String, int>('1').pipeFailure((val) async => Failure(404)), Success<String, int>('1')));


    test('success', () => expect(Success(1).success, const Some(1)));

    test('failure', () => expect(Success<int, String>(1).failure, const None<String>()));


    group('equality', () {
      test('identical', () {
        final success = Success(1);
        expect(success, success);
      });

      test('other success, exact same type', () => expect(Success<int, String>(1), Success<int, String>(1)));

      test('other success, covariant type', () => expect(Success<int, String>(1), Success<num, String>(1)));

      test('other success, contravariant type', () => expect(Success<num, String>(1), Success<int, String>(1)));

      test('other success, different failure type', () => expect(Success<int, DateTime>(1), Success<int, String>(1)));

      test('other success, deep equality', () => expect(Success<List<int>, String>([1]), Success<List<int>, String>([1])));

      test('other success, different value', () => expect(Success<int, String>(1), isNot(Success<int, String>(2))));

      test('failure', () => expect(Success(1), isNot(Failure(1))));
    });

    group('hash', () {
      test('identical', () {
        final success = Success(1).hashCode;
        expect(success, success);
      });

      test('other success, exact same type', () => expect(Success<int, String>(1).hashCode, Success<int, String>(1).hashCode));

      test('other success, covariant type', () => expect(Success<int, String>(1).hashCode, Success<num, String>(1).hashCode));

      test('other success, contravariant type', () => expect(Success<num, String>(1).hashCode, Success<int, String>(1).hashCode));

      test('other success, different failure type', () => expect(Success<int, DateTime>(1).hashCode, Success<int, String>(1).hashCode));

      test('other success, deep equality', () => expect(Success<List<int>, String>([1]).hashCode, Success<List<int>, String>([1]).hashCode));

      test('other success, different value', () => expect(Success<int, String>(1).hashCode, isNot(Success<int, String>(2))));

      test('failure', () => expect(Success(1).hashCode, Failure(1).hashCode));
    });

    test('toString', () => expect(Success(1).toString(), 'Success(1)'));
  });

  group('Failure', () {
    test('map', () => expect(Failure<int, String>('1').map((val) => 404), Failure<int, String>('1')));
    
    test('mapFailure same type', () => expect(Failure<String, int>(1).mapFailure((val) => val + 1), Failure<String, int>(2)));

    test('mapFailure different type', () => expect(Failure<DateTime, int>(1).mapFailure((val) => val.toString()), Failure<DateTime, String>('1')));


    test('bind', () => expect(Failure<String, int>(1).bind((val) => Success('value')), Failure<String, int>(1)));

    test('bindFailure failure, same type', () => expect(Failure<String, int>(1).bindFailure((val) => Failure(val + 1)), Failure<String, int>(2)));

    test('bindFailure failure, different type', () => expect(Failure<DateTime, int>(1).bindFailure((val) => Failure(val.toString())), Failure<DateTime, String>('1')));

    test('bindFailure Success', () => expect(Failure<String, int>(1).bindFailure((_) => Success<String, int>('value')), Success<String, int>('value')));


    test('pipe', () async => expect(await Failure<String, int>(1).pipe((val) async => Success('value')), Failure<String, int>(1)));

    test('pipeFailure failure, same type', () async => expect(await Failure<String, int>(1).pipeFailure((val) async => Failure(val + 1)), Failure<String, int>(2)));

    test('pipeFailure failure, different type', () async => expect(await Failure<DateTime, int>(1).pipeFailure((val) async => Failure(val.toString())), Failure<DateTime, String>('1')));

    test('pipeFailure success', () async => expect(await Failure<String, int>(1).pipeFailure((_) async => Success<String, int>('value')), Success<String, int>('value')));


    test('success', () => expect(Failure<String, int>(1).success, const None<String>()));

    test('failure', () => expect(Failure(1).failure, const Some(1)));


    group('equality', () {
      test('identical', () {
        final failure = Failure(1);
        expect(failure, failure);
      });

      test('other failure, exact same type', () => expect(Failure<String, int>(1), Failure<String, int>(1)));

      test('other failure, covariant type', () => expect(Failure<String, int>(1), Failure<String, num>(1)));

      test('other failure, contravariant type', () => expect(Failure<String, num>(1), Failure<String, int>(1)));

      test('other failure, different failure type', () => expect(Failure<DateTime, int>(1), Failure<DateTime, int>(1)));

      test('other failure, deep equality', () => expect(Failure<String, List<int>>([1]), Failure<String, List<int>>([1])));

      test('other failure, different value', () => expect(Failure<String, int>(1), isNot(Failure<String, int>(2))));

      test('success', () => expect(Failure(1), isNot(Success(1))));
    });

    group('hash', () {
      test('identical', () {
        final failure = Success(1).hashCode;
        expect(failure, failure);
      });

      test('other failure, exact same type', () => expect(Failure<String, int>(1).hashCode, Failure<String, int>(1).hashCode));

      test('other failure, covariant type', () => expect(Failure<String, int>(1).hashCode, Success<num, String>(1).hashCode));

      test('other failure, contravariant type', () => expect(Success<num, String>(1).hashCode, Failure<String, int>(1).hashCode));

      test('other failure, different failure type', () => expect(Failure<DateTime, int>(1).hashCode, Failure<DateTime, int>(1).hashCode));

      test('other failure, deep equality', () => expect(Failure<String, List<int>>([1]).hashCode, Failure<String, List<int>>([1]).hashCode));

      test('other failure, different value', () => expect(Failure<String, int>(1).hashCode, isNot(Failure<String, int>(2))));

      test('success', () => expect(Failure(1).hashCode, Success(1).hashCode));
    });

    test('toString', () => expect(Failure(1).toString(), 'Failure(1)'));
  });

}
