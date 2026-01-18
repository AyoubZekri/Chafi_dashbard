import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/NavigationBarcontroller.dart';
import '../../core/constant/imageassets.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationBarcontrollerImp>();

    return Container(
      width: 280,
      color: Colors.white,
      child: Obx(() {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
            const SizedBox(height: 30),

            ...List.generate(controller.screens.length, (index) {
              final screen = controller.screens[index];
              final isExpanded = controller.expandedIndex.value == index;
              final isSelected = controller.currentPage.value == index;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      screen['subPages'].isNotEmpty
                          ? controller.toggleExpand(index)
                          : controller.changePage(index);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.only(left: 15, right: 15),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isSelected
                                ? const Color(0xFF034D82).withOpacity(0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                screen['icon'],
                                size: 20,
                                color: isSelected
                                    ? const Color(0xFF034D82)
                                    : const Color(0xFF9E9E9E),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: Text(
                                  screen['name'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF034D82)
                                        : const Color(0xFF6B6B6B),
                                  ),
                                ),
                              ),

                              if (screen['subPages'].isNotEmpty)
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 18,
                                  color: const Color(0xFF9E9E9E),
                                ),
                            ],
                          ),
                        ),

                        // 🔵 Indicator ملتصق بآخر Sidebar
                        Positioned(
                          left: Get.locale == Locale("ar") ? -2 : null,
                          right: Get.locale == Locale("fr") ? -2 : null,

                          top: 2.5,
                          bottom: 2.5,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF034D82)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SubPages
                  if (isExpanded)
                    ...screen['subPages'].asMap().entries.map((entry) {
                      final subIndex = entry.key;
                      final sub = entry.value;
                      final isSubSelected =
                          controller.currentSubIndex.value == subIndex &&
                          isSelected;

                      return InkWell(
                        onTap: () {
                          controller.changePage(index);
                          controller.changeSubPage(
                            subIndex,
                            () => sub['page'](),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSubSelected
                                ? const Color(0xFF034D82).withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                sub['icon'],
                                size: 18,
                                color: isSubSelected
                                    ? const Color(0xFF034D82)
                                    : const Color(0xFF9E9E9E),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                sub['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSubSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSubSelected
                                      ? const Color(0xFF034D82)
                                      : const Color(0xFF6B6B6B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              );
            }),
          ],
        );
      }),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationBarcontrollerImp controller = Get.put(
      NavigationBarcontrollerImp(),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Row(
        children: [
          const SidebarWidget(),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: Obx(() {
                    if (controller.currentSubPage.value != null) {
                      return controller.currentSubPage.value!();
                    }

                    final screen =
                        controller.screens[controller.currentPage.value];
                    return screen['page'] != null
                        ? screen['page']()
                        : const SizedBox();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  void changeLang(String code) {
    Get.updateLocale(Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Spacer(),

          /// Language Menu
          PopupMenuButton<String>(
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: changeLang,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ar', child: Text("العربية")),
              const PopupMenuItem(value: 'fr', child: Text("Français")),
            ],
            child: Icon(Icons.language, color: Colors.grey.shade700),
          ),

          const SizedBox(width: 20),

          /// Profile Dropdown Menu
          PopupMenuButton(
            offset: const Offset(0, 50),
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                      ),
                      title: const Text(
                        "John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D596C),
                        ),
                      ),
                      subtitle: const Text(
                        "Admin",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const Divider(color: Color.fromARGB(255, 216, 216, 216)),
                  ],
                ),
              ),
              // خيارات القائمة
              _buildProfileItem(Icons.person_outline, "reest password"),
              _buildProfileItem(Icons.power_settings_new, "Log Out"),
            ],
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء عناصر القائمة بشكل موحد
  PopupMenuItem _buildProfileItem(
    IconData icon,
    String title, {
    String? badge,
  }) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6F6B7D), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF6F6B7D), fontSize: 15),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
