import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/unfollow_club.dart';

// Mock repository
class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late UnfollowClub usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = UnfollowClub(mockRepository);
  });

  const clubId = '123';

  test('should return Right(unit) when unfollow succeeds', () async {
    // Arrange
    when(
      () => mockRepository.unfollowClub(clubId),
    ).thenAnswer((_) async => const Right(unit));

    // Act
    final result = await usecase(const UnfollowClubParams(clubId: clubId));

    // Assert
    expect(result, const Right(unit));
    verify(() => mockRepository.unfollowClub(clubId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when unfollow fails', () async {
    // Arrange
    final failure = ServerFailure();
    when(
      () => mockRepository.unfollowClub(clubId),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(const UnfollowClubParams(clubId: clubId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.unfollowClub(clubId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
