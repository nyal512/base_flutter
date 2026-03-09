import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/option_1_view_model.dart';

class Option1Screen extends StatefulWidget {
  const Option1Screen({super.key});

  @override
  State<Option1Screen> createState() => _Option1ScreenState();
}

class _Option1ScreenState extends State<Option1Screen> with SingleTickerProviderStateMixin {
  late final Option1ViewModel _viewModel;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<Option1ViewModel>()..init();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Column(
          children: [
            // TabBar
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(24.w),
              child: Container(
                width: 300.w, // Approximate width for two tabs
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: const Color(0xFF374151),
                  unselectedLabelColor: const Color(0xFF9CA3AF),
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Option1/2'),
                    Tab(text: 'Option2/2'),
                  ],
                ),
              ),
            ),
            
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(), // Match design, disable swipe if needed
                children: [
                  _buildTab1Content(),
                  _buildTab2Content(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab1Content() {
    // Tab 1 contains options 1-39 in a 3-column grid
    final items = _viewModel.options.sublist(0, 39);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Expanded(child: _buildColumn(items.sublist(0, 13))), // 1-13
               SizedBox(width: 16.w),
               Expanded(child: _buildColumn(items.sublist(13, 26))), // 14-26
               SizedBox(width: 16.w),
               Expanded(child: _buildColumn(items.sublist(26, 39))), // 27-39
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildTab2Content() {
    // Tab 2 contains options 40-64 in a 2-column grid (or 3-column with empty space)
    final items = _viewModel.options.sublist(39, 64); // 25 items
    
    // Creating 3 columns for consistency, the last one might be partially filled or empty
    final col1 = items.length >= 13 ? items.sublist(0, 13) : items;
    final col2 = items.length > 13 ? items.sublist(13, items.length >= 26 ? 26 : items.length) : <OptionItem>[];
    final col3 = items.length > 26 ? items.sublist(26, items.length) : <OptionItem>[];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Expanded(child: _buildColumn(col1)),
               SizedBox(width: 16.w),
               Expanded(child: _buildColumn(col2)),
               SizedBox(width: 16.w),
               Expanded(child: _buildColumn(col3)),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildColumn(List<OptionItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          
          return Container(
            decoration: BoxDecoration(
              border: isLast 
                  ? null 
                  : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                // Label part
                Container(
                  width: 180.w, // Fixed width for label part to match design
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB), // Light grey background
                    border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF374151),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Switch part
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    alignment: Alignment.centerLeft,
                    child: item.isSwitchable 
                      ? AppSwitch(
                          value: item.isEnabled,
                          onChanged: (val) => _viewModel.toggleOption(item.id - 1, val),
                        )
                      : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
