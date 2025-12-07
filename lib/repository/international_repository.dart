import 'package:mvvm_real/data/network/network_api_service.dart';
import 'package:mvvm_real/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir
class InternationalRepository {
  // NetworkApiServices hanya perlu 1 instance sehingga tidak perlu ganti service selama aplikasi berjalan
  final _apiServices = NetworkApiServices();

  // https://rajaongkir.komerce.id/api/v1/destination/international-destination?search=malaysia&limit=20&offset=0
  Future<List<InternationalDestination>> fetchCountryList(String search) async {

    final response = await _apiServices.getApiResponse(
      'destination/international-destination?search=$search&limit=20',
    );

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => InternationalDestination.fromJson(e)).toList();
  }

  Future<List<InternationalCost>> checkInternationalShipmentCost({
    required String origin,
    required String originType,
    required String destination,
    required String destinationType,
    required int weight,
    required String courier,
  }) async {
    final response = await _apiServices.postApiResponse(
      'calculate/international-cost',
      {
        "origin": origin,
        "origin_type": originType,
        "destination": destination,
        "destination_type": destinationType,
        "weight": weight.toString(),
        "courier": courier,
      },
    );

    // validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // extract data
    final data = response['data'];
    if (data is! List) return [];

    // parse JSON ke model
    return data
        .map<InternationalCost>((e) => InternationalCost.fromJson(e))
        .toList();
  }

}
