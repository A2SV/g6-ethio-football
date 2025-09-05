import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/domain/usecases/filter_clubs.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository
class MockMyClubsRepository extends Mock implements MyClubsRepository {}

void main() {
  late FilterClub usecase;
  late MockMyClubsRepository mockRepository;

  setUp(() {
    mockRepository = MockMyClubsRepository();
    usecase = FilterClub(mockRepository);
  });

  const allClubs = [
    Club(
      id: '1',
      name: 'Arsenal',
      league: League.EPL,
      short: 'ARS',
      description: '',
      isFollowed: false,
      logoUrl: "https://example.com/arsenal.png",
    ),
    Club(
      id: '2',
      name: 'Chelsea',
      league: League.EPL,
      short: 'CHE',
      description: '',
      isFollowed: false,
      logoUrl: "https://example.com/chelsea.png",
    ),
  ];

  test('should return filtered list of clubs for a given league', () async {
    // Arrange
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Right(allClubs));

    // Act
    final result = await usecase.call(league: League.EPL);

    // Assert
    expect(result.isRight(), true);

    result.fold((_) => null, (clubs) {
      expect(clubs.length, 2);
      expect(clubs.every((c) => c.league == League.EPL), true);
    });

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return all clubs if league is null', () async {
    // Arrange
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Right(allClubs));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isRight(), true);
    result.fold((_) => null, (clubs) {
      expect(clubs.length, allClubs.length);
    });

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure if repository fails', () async {
    // Arrange
    final failure = Failure(message: 'Unable to fetch clubs');
    when(
      () => mockRepository.getAllClubs(),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase.call(league: League.EPL);

    // Assert
    expect(result.isLeft(), true);
    result.fold((f) => expect(f, failure), (_) => null);

    verify(() => mockRepository.getAllClubs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
