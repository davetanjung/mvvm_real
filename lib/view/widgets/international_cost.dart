part of 'widgets.dart';

class InternationalCardCost extends StatelessWidget {
  final InternationalCost cost;
  const InternationalCardCost(this.cost, {super.key});

  String rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return "-";
    return etd.replaceAll("day", "hari").replaceAll("days", "hari");
  }

  @override
  Widget build(BuildContext context) {
    final InternationalCost cost = this.cost;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue[800]!),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () => showInternationalCostDetailSheet(context, cost),
        title: Text(
          "${cost.name}: ${cost.service}",
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biaya: ${rupiahMoneyFormatter(cost.cost)}",
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "Estimasi sampai: ${formatEtd(cost.etd)}",
              style: TextStyle(color: Colors.green[800]),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.local_shipping, color: Colors.blue[800]),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// BOTTOM SHEET
// ----------------------------------------------------

void showInternationalCostDetailSheet(
    BuildContext context, InternationalCost cost) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue[50],
                  child: Icon(Icons.local_shipping, color: Colors.blue[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    cost.name ?? "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),

            buildDetailRow("Nama Kurir", cost.name),
            const SizedBox(height: 8),
            buildDetailRow("Code", cost.code),
            const SizedBox(height: 8),
            buildDetailRow("Service", cost.service),
            const SizedBox(height: 8),
            buildDetailRow("Description", cost.description),
            const SizedBox(height: 8),
            buildDetailRow("Cost", cost.cost != null ? "Rp${cost.cost}" : "-"),
            const SizedBox(height: 8),
            buildDetailRow("Estimation",
                cost.etd != null ? "${cost.etd} hari" : "-"),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

Widget buildDetailRow(String label, dynamic value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 16, color: Colors.grey)),
      const Text(" : ", style: TextStyle(fontSize: 16)),
      Expanded(
        child: Text(
          value?.toString() ?? "-",
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    ],
  );
}
