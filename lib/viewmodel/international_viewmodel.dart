import 'package:flutter/material.dart';
import 'package:mvvm_real/model/model.dart';
import 'package:mvvm_real/data/response/api_response.dart';
import 'package:mvvm_real/data/response/status.dart';
import 'package:mvvm_real/repository/home_repository.dart';
import 'package:mvvm_real/repository/international_repository.dart';

class InternationalViewModel with ChangeNotifier {
  // pakai multiple repository supaya di page cuma ttp apply 1 viewmodel
  final _internationalRepo = InternationalRepository();
  final _homeRepo = HomeRepository();

  // ========== PROVINCE LIST ==========
  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();

  void setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    setProvinceList(ApiResponse.loading());

    _homeRepo
        .fetchProvinceList()
        .then((value) => setProvinceList(ApiResponse.completed(value)))
        .onError((error, _) => setProvinceList(ApiResponse.error(error.toString())));
  }

  // ========== CITY LIST (ORIGIN) ==========
  final Map<int, List<City>> _cityCache = {};

  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();

  void setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  Future getCityOriginList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityOriginList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }

    setCityOriginList(ApiResponse.loading());

    _homeRepo.fetchCityList(provId).then((value) {
      _cityCache[provId] = value;
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }


  ApiResponse<List<InternationalDestination>> countryList =
      ApiResponse.notStarted();

  void setCountryList(ApiResponse<List<InternationalDestination>> response) {
    countryList = response;
    notifyListeners();
  }

  Future getCountryList(String search) async {

    setCountryList(ApiResponse.loading());

    _internationalRepo
        .fetchCountryList(search)
        .then((value) => setCountryList(ApiResponse.completed(value)))
        .onError((error, _) {
          if (error.toString().contains('422') || error.toString().contains('cannot be blank')) {
            setCountryList(ApiResponse.completed([]));
          } else {
            setCountryList(ApiResponse.error(error.toString()));
          }
        });
  }

  // ========== INTERNATIONAL COST ==========
  ApiResponse<List<InternationalCost>> internationalCostList =
      ApiResponse.notStarted();

  void setInternationalCostList(
      ApiResponse<List<InternationalCost>> response) {
    internationalCostList = response;
    notifyListeners();
  }

  Future checkInternationalShipmentCost({
    required String origin,
    required String originType,
    required String destination,
    required String destinationType,
    required int weight,
    required String courier,
  }) async {
    setLoading(true);
    setInternationalCostList(ApiResponse.loading());

    _internationalRepo
        .checkInternationalShipmentCost(
          origin: origin,
          originType: originType,
          destination: destination,
          destinationType: destinationType,
          weight: weight,
          courier: courier,
        )
        .then((value) {
          setInternationalCostList(ApiResponse.completed(value));
          setLoading(false);
        })
        .onError((error, _) {
          setInternationalCostList(ApiResponse.error(error.toString()));
          setLoading(false);
        });
  }

  bool isLoading = false;
  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
}