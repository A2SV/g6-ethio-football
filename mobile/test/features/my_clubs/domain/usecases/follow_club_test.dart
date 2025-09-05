import 'package:dartz/dartz.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/follow_club.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';

class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late FollowClub usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = FollowClub(mockRepository);
  });

  const tClubId = '123';
  const tParams = FollowClubParams(clubId: tClubId);

  test(
    'should return Right(unit) when repository.followClub succeeds',
    () async {
      // Arrange
      when(
        () => mockRepository.followClub(tClubId),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRepository.followClub(tClubId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return Left(Failure) when repository.followClub fails',
    () async {
      // Arrange
      final failure = ServerFailure();
      when(
        () => mockRepository.followClub(tClubId),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.followClub(tClubId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
