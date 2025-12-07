part of 'widgets.dart';

void showCostDetailSheet(BuildContext context, Costs cost) {
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
            // ---- DRAG HANDLE ----
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),

            // ---- NAME ----
            buildInternationalDetailRow("Nama Kurir", cost.name),

            const SizedBox(height: 8),

            // ---- CODE ----
            buildInternationalDetailRow("Code", cost.code),

            const SizedBox(height: 8),

            // ---- SERVICE ----
            buildInternationalDetailRow("Service", cost.service),

            const SizedBox(height: 8),

            // ---- DESCRIPTION ----
            buildInternationalDetailRow("Description", cost.description),

            const SizedBox(height: 8),

            // ---- COST ----
            buildInternationalDetailRow("Cost", cost.cost != null ? "Rp${cost.cost}" : "-"),

            const SizedBox(height: 8),

            // ---- ESTIMATION ----
            buildInternationalDetailRow("Estimation", cost.etd != null ? "${cost.etd} hari" : "-"),

            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

Widget buildInternationalDetailRow(String label, dynamic value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      const Text(
        " : ",
        style: TextStyle(fontSize: 16),
      ),
      Expanded(
        child: Text(
          value?.toString() ?? "-",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}
