import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../data/model/UsersModel.dart';

class UserFeedbackDialog extends StatelessWidget {
  final List<UserFeedback> feedback;
  final List<Map<String, dynamic>> options;

  const UserFeedbackDialog({
    super.key,
    required this.feedback,
    required this.options,
  });

  IconData _getIcon(int type) {
    switch (type) {
      case 1:
        return Icons.thumb_up_alt_outlined;
      case 2:
        return Icons.lightbulb_outline;
      case 3:
        return Icons.rocket_launch_outlined;
      case 4:
        return Icons.edit_note_outlined;
      case 5:
        return Icons.verified_user_outlined;
      default:
        return Icons.feedback_outlined;
    }
  }

  Color _getColor(int type) {
    switch (type) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "user_opinion".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.typography,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 15),
            if (feedback.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Icon(
                      Icons.feedback_outlined,
                      size: 60,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "no_feedback_yet".tr,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: feedback.length,
                  itemBuilder: (context, index) {
                    final f = feedback[index];
                    final option = options.firstWhere(
                      (opt) => opt['id'] == f.type,
                      orElse: () => {"name": "Unknown"},
                    );
                    final color = _getColor(f.type);
                    final icon = _getIcon(f.type);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: color.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: color, size: 24),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: color.darken(0.2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f.createdAt
                                      .toString()
                                      .substring(0, 16)
                                      .replaceAll('T', ' '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.typography,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text("close".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsv = HSVColor.fromColor(this);
    final res = hsv.withValue((hsv.value - amount).clamp(0.0, 1.0));
    return res.toColor();
  }
}
