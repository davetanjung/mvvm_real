part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late InternationalViewModel intlVM;

  final weightController = TextEditingController();
  final countrySearchController = TextEditingController();
  final courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];

  String selectedCourier = "jne";
  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  String? selectedCountryId;

  @override
  void initState() {
    super.initState();
    intlVM = Provider.of<InternationalViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (intlVM.provinceList.status == Status.notStarted) {
        intlVM.getProvinceList();
      }
    });

    // Listen to search field changes
    countrySearchController.addListener(() {
      final searchText = countrySearchController.text;
      intlVM.getCountryList(searchText);
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    countrySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("International Shipping")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // -------------------------------------------------------
                // INPUT CARD
                // -------------------------------------------------------
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Courier & Weight Row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions
                                    .map((c) => DropdownMenuItem(
                                        value: c, child: Text(c.toUpperCase())))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => selectedCourier = v ?? "jne"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Weight (grams)",
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        
                        // ========== ORIGIN SECTION ==========
                        const Text(
                          "Origin",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            // Province Dropdown
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (_, vm, __) {
                                  if (vm.provinceList.status == Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (vm.provinceList.status == Status.error) {
                                    return Text(
                                      vm.provinceList.message ?? "Error",
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  }

                                  final provinces = vm.provinceList.data ?? [];
                                  if (provinces.isEmpty) {
                                    return const Text('No provinces');
                                  }

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Select province'),
                                    items: provinces
                                        .map((p) => DropdownMenuItem<int>(
                                              value: p.id,
                                              child: Text(p.name ?? ''),
                                            ))
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) {
                                        vm.getCityOriginList(newId);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // City Dropdown
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (_, vm, __) {
                                  if (vm.cityOriginList.status == Status.notStarted) {
                                    return const Text(
                                      'Select province first',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.error) {
                                    return Text(
                                      vm.cityOriginList.message ?? 'Error',
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  }

                                  if (vm.cityOriginList.status == Status.completed) {
                                    final cities = vm.cityOriginList.data ?? [];

                                    if (cities.isEmpty) {
                                      return const Text(
                                        'No cities',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      );
                                    }

                                    // Validate selected value
                                    final validIds = cities.map((c) => c.id).toSet();
                                    final validValue = validIds.contains(selectedCityOriginId)
                                        ? selectedCityOriginId
                                        : null;

                                    return DropdownButton<int>(
                                      isExpanded: true,
                                      value: validValue,
                                      hint: const Text('Select city'),
                                      items: cities
                                          .map((c) => DropdownMenuItem<int>(
                                                value: c.id,
                                                child: Text(c.name ?? ''),
                                              ))
                                          .toList(),
                                      onChanged: (newId) {
                                        setState(() {
                                          selectedCityOriginId = newId;
                                        });
                                      },
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        
                        // ========== DESTINATION SECTION ==========
                        const Text(
                          "Destination Country",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Country Search with Dropdown
                        Consumer<InternationalViewModel>(
                          builder: (_, vm, __) {
                            final countries = vm.countryList.data ?? [];
                            final isLoading = vm.countryList.status == Status.loading;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: countrySearchController,
                                  decoration: InputDecoration(
                                    labelText: "Search country",
                                    hintText: "Type to search (e.g., malaysia)",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : (countrySearchController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  countrySearchController.clear();
                                                  setState(() {
                                                    selectedCountryId = null;
                                                  });
                                                },
                                              )
                                            : null),
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                
                                // Dropdown results
                                if (countrySearchController.text.isNotEmpty && countries.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                    ),
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: countries.length,
                                      itemBuilder: (context, index) {
                                        final country = countries[index];
                                        final isSelected = selectedCountryId == country.countryId;
                                        
                                        return ListTile(
                                          title: Text(country.countryName ?? "-"),
                                          selected: isSelected,
                                          selectedTileColor: Colors.blue.shade50,
                                          onTap: () {
                                            setState(() {
                                              selectedCountryId = country.countryId;
                                              countrySearchController.text = country.countryName ?? "";
                                            });
                                          },
                                          trailing: isSelected
                                              ? const Icon(Icons.check, color: Colors.blue)
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                                
                                // Helper text
                                if (countrySearchController.text.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0, left: 12),
                                    child: Text(
                                      "Type to search for countries",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                
                                if (countrySearchController.text.isNotEmpty && 
                                    countries.isEmpty && 
                                    !isLoading)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0, left: 12),
                                    child: Text(
                                      "No countries found",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCityOriginId == null ||
                                  selectedCountryId == null ||
                                  weightController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please complete all fields"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final weight =
                                  int.tryParse(weightController.text) ?? 0;
                              if (weight <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Weight must be greater than 0"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              intlVM.checkInternationalShipmentCost(
                                origin: selectedCityOriginId!.toString(),
                                originType: "city",
                                destination: selectedCountryId!,
                                destinationType: "country",
                                weight: weight,
                                courier: selectedCourier,
                              );
                            },
                            child: const Text("Check Cost"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Results Card
                Card(
                  color: Colors.white,
                  child: Consumer<InternationalViewModel>(
                    builder: (_, vm, __) {
                      switch (vm.internationalCostList.status) {
                        case Status.loading:
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );

                        case Status.error:
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              vm.internationalCostList.message ?? "Error",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );

                        case Status.completed:
                          final list = vm.internationalCostList.data ?? [];
                          if (list.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("No cost data available"),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (_, i) => InternationalCardCost(list[i]),
                          );

                        default:
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("Select origin, destination and check cost"),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          Consumer<InternationalViewModel>(
            builder: (_, vm, __) => vm.isLoading
                ? Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}