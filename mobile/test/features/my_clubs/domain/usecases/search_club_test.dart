import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/search_club.dart';

// Mock repository
class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late SearchClub usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = SearchClub(mockRepository);
  });

  final allClubs = [
    Club(
      id: 'arsenal',
      name: 'Arsenal',
      league: League.EPL,
      short: 'ARS',
      description: '',
      isFollowed: false,
      logoUrl: "https://example.com/arsenal.png",
    ),
    Club(
      id: "st.george",
      name: "St George",
      description: "",
      isFollowed: true,
      short: "STG",
      league: League.ETH,
      logoUrl: "https://example.com/stgeorge.png",
    ),
    Club(
      id: 'chelsea',
      name: 'Chelsea',
      league: League.EPL,
      short: 'CHE',
      description: '',
      isFollowed: false,
      logoUrl: "https://example.com/chelsea.png",
    ),
  ];

  test('should return clubs matching the query', () async {
    // Arrange
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Right(allClubs));

    // Act
    final result = await usecase('s');

    // Assert
    expect(result.isRight(), true);
    result.fold((_) => null, (clubs) {
      expect(clubs.length, 3); // Arsenal & Barcelona
      expect(clubs.any((c) => c.name == 'Arsenal'), true);
      expect(clubs.any((c) => c.name == 'St George'), true);
      expect(clubs.any((c) => c.name == 'Chelsea'), true);
    });

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list if no club matches query', () async {
    // Arrange
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Right(allClubs));

    // Act
    final result = await usecase('madrid');

    // Assert
    expect(result.isRight(), true);
    result.fold((_) => null, (clubs) {
      expect(clubs.isEmpty, true);
    });

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure if repository fails', () async {
    // Arrange
    final failure = ServerFailure();
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase('arsenal');

    // Assert
    expect(result, Left(failure));

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
