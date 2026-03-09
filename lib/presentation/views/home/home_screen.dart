import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/responsive_utils.dart';
import 'view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSalesMethodSection(),
                            SizedBox(height: 24.h),
                            _buildTaxRateSection(),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildInactivitySection(),
                            SizedBox(height: 24.h),
                            _buildEraSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalesMethodSection() {
    return FormCard(
      title: '販売方式',
      child: FormRow(
        label: '販売方式',
        content: Row(
          children: [
            _buildRadio(
              '連売',
              0,
              _viewModel.salesMethod,
              (v) => _viewModel.setSalesMethod(v!),
            ),
            _buildRadio(
              '単売',
              1,
              _viewModel.salesMethod,
              (v) => _viewModel.setSalesMethod(v!),
            ),
            _buildRadio(
              '一括',
              2,
              _viewModel.salesMethod,
              (v) => _viewModel.setSalesMethod(v!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInactivitySection() {
    return FormCard(
      title: '無操作時間',
      child: Column(
        children: [
          FormRow(
            label: '無操作時間',
            content: Row(
              children: [
                _buildRadio(
                  '制限なし',
                  0,
                  _viewModel.inactivityMode,
                  (v) => _viewModel.setInactivityMode(v!),
                ),
                _buildRadio(
                  '制限する',
                  1,
                  _viewModel.inactivityMode,
                  (v) => _viewModel.setInactivityMode(v!),
                ),
              ],
            ),
          ),
          FormRow(
            label: '制限する',
            enabled: _viewModel.inactivityMode == 1,
            content: _viewModel.inactivityMode == 1
                ? _buildDropdown(
                    value:
                        _viewModel.inactivityOptions.contains(
                          _viewModel.inactivitySeconds,
                        )
                        ? _viewModel.inactivitySeconds
                        : _viewModel.inactivityOptions.first,
                    items: _viewModel.inactivityOptions,
                    onChanged: (v) => _viewModel.setInactivitySeconds(v!),
                    suffix: '秒',
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      '10 ～ 90 秒',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
            showInfoIcon: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTaxRateSection() {
    return FormCard(
      title: '税率',
      child: Column(
        children: [
          FormRow(
            label: '消費税率',
            content: _buildTextField(
              _viewModel.consumptionTax,
              hintText: '0 ～ 99 %',
              onChanged: (v) => _viewModel.setConsumptionTax(v),
            ),
          ),
          FormRow(
            label: '軽減税率',
            content: _buildTextField(
              _viewModel.reducedTax,
              hintText: '0 ～ 99 %',
              onChanged: (v) => _viewModel.setReducedTax(v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEraSection() {
    return FormCard(
      title: '印字年号',
      child: Column(
        children: [
          FormRow(
            label: '印字年号',
            content: Row(
              children: [
                _buildRadio(
                  '西暦',
                  0,
                  _viewModel.eraMode,
                  (v) => _viewModel.setEraMode(v!),
                ),
                _buildRadio(
                  '和暦',
                  1,
                  _viewModel.eraMode,
                  (v) => _viewModel.setEraMode(v!),
                ),
              ],
            ),
          ),
          FormRow(
            label: '和暦基準年',
            enabled: _viewModel.eraMode == 1,
            content: _buildTextField(
              _viewModel.eraBaseYear,
              hintText: '20 [10 ～ 90]',
              onChanged: (v) => _viewModel.setEraBaseYear(v),
              enabled: _viewModel.eraMode == 1,
            ),
          ),
          FormRow(
            label: '和暦マーク',
            enabled: _viewModel.eraMode == 1,
            content: _buildTextField(
              _viewModel.eraMark,
              hintText: 'A ～ Z',
              onChanged: (v) => _viewModel.setEraMark(v),
              enabled: _viewModel.eraMode == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(
    String label,
    int value,
    int groupValue,
    ValueChanged<int?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF0F1ED2),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151)),
        ),
        SizedBox(width: 12.w),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? suffix,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          initialSelection: value,
          width: constraints.maxWidth,
          dropdownMenuEntries: items
              .map(
                (e) => DropdownMenuEntry(
                  value: e,
                  label: '$e${suffix ?? ''}',
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                      TextStyle(fontSize: 13.sp),
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      return const Color(0xFF3A3A3A);
                    }),
                  ),
                ),
              )
              .toList(),
          onSelected: onChanged,
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          textStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF374151)),
          trailingIcon: Icon(
            Icons.keyboard_arrow_down,
            size: 18.sp,
            color: const Color(0xFF3A3A3A),
          ),
          selectedTrailingIcon: Icon(
            Icons.keyboard_arrow_up,
            size: 18.sp,
            color: const Color(0xFF3A3A3A),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            elevation: WidgetStateProperty.all(4),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String initialValue, {
    String? hintText,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return AppTextField(
      initialValue: initialValue,
      hintText: hintText,
      onChanged: onChanged,
      enabled: enabled,
      validator: ValidationHelper.fromHint(hintText),
    );
  }
}
