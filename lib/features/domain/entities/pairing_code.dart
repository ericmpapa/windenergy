import "package:equatable/equatable.dart";

enum PairingStatus{ valid, invalid}

class PairingCode extends Equatable{
  final int turbineId;
  final String codeHash;
  final PairingStatus status;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? validatedAt;

  const PairingCode({
    this.turbineId = 0,
    this.codeHash = "",
    this.status = PairingStatus.invalid,
    this.expiresAt,
    this.createdAt,
    this.validatedAt
  });

  @override
  List<Object?> get props => [turbineId, codeHash, createdAt];
}