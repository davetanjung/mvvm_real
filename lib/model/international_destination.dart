part of 'model.dart';

class InternationalDestination extends Equatable {
  final String? countryId;
  final String? countryName;

  const InternationalDestination({this.countryId, this.countryName});

  factory InternationalDestination.fromJson(Map<String, dynamic> json) {
    return InternationalDestination(
      countryId: json['country_id'] as String?,
      countryName: json['country_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'country_id': countryId,
    'country_name': countryName,
  };

  @override
  List<Object?> get props => [countryId, countryName];
}
