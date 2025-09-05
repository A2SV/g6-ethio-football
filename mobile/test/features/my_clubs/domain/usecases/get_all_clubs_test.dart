import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/core/usecase.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/get_all_clubs.dart';

// Mock repository
class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late GetAllClubs usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = GetAllClubs(mockRepository);
  });

  final tClubs = [
    Club(
      id: '1',
      name: 'Arsenal',
      league: League.EPL,
      short: 'ARS',
      description: 'Top club',
      isFollowed: false,
      logoUrl: "https://example.com/arsenal.png",
    ),
    Club(
      id: '2',
      name: 'Real Madrid',
      league: League.EPL,
      short: 'RMA',
      description: 'Spanish giant',
      isFollowed: true,
      logoUrl: "https://example.com/realmadrid.png",
    ),
  ];

  test(
    'should return list of clubs when repository.getAllClubs succeeds',
    () async {
      // Arrange
      when(
        () => mockRepository.getAllClubs(),
      ).thenAnswer((_) async => Right(tClubs));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tClubs));
      verify(() => mockRepository.getAllClubs()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository.getAllClubs fails', () async {
    // Arrange
    final failure = ServerFailure();
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
