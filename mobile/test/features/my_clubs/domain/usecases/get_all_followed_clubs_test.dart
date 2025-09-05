import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/core/usecase.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/get_all_followed_clubs.dart';

// Mock repository
class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late GetAllFollowedClubs usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = GetAllFollowedClubs(mockRepository);
  });

  final tFollowedClubs = [
    Club(
      id: '1',
      name: 'Manchester United',
      league: League.ETH,
      short: 'MANU',
      description: 'Catalan club',
      isFollowed: true,
      logoUrl: "https://example.com/manutd.png",
    ),
    Club(
      id: '2',
      name: 'Liverpool',
      league: League.EPL,
      short: 'LIV',
      description: 'English club',
      isFollowed: true,
      logoUrl: "https://example.com/liverpool.png",
    ),
  ];

  test(
    'should return list of followed clubs when repository succeeds',
    () async {
      // Arrange
      when(
        () => mockRepository.getAllFollowedClubs(),
      ).thenAnswer((_) async => Right(tFollowedClubs));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tFollowedClubs));
      verify(() => mockRepository.getAllFollowedClubs()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository fails', () async {
    // Arrange
    final failure = ServerFailure();
    when(
      () => mockRepository.getAllFollowedClubs(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getAllFollowedClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
