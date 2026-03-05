import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
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
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
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
            _buildRadio('連売', 0, _viewModel.salesMethod, (v) => _viewModel.setSalesMethod(v!)),
            _buildRadio('単売', 1, _viewModel.salesMethod, (v) => _viewModel.setSalesMethod(v!)),
            _buildRadio('一括', 2, _viewModel.salesMethod, (v) => _viewModel.setSalesMethod(v!)),
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
                _buildRadio('制限なし', 0, _viewModel.inactivityMode, (v) => _viewModel.setInactivityMode(v!)),
                _buildRadio('制限する', 1, _viewModel.inactivityMode, (v) => _viewModel.setInactivityMode(v!)),
              ],
            ),
          ),
          FormRow(
            label: '制限する',
            content: _buildTextField(
              _viewModel.inactivitySeconds,
              onChanged: (v) => _viewModel.setInactivitySeconds(v),
              enabled: _viewModel.inactivityMode == 1,
            ),
            showInfo: false,
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
              onChanged: (v) => _viewModel.setConsumptionTax(v),
            ),
          ),
          FormRow(
            label: '軽減税率',
            content: _buildTextField(
              _viewModel.reducedTax,
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
                _buildRadio('西暦', 0, _viewModel.eraMode, (v) => _viewModel.setEraMode(v!)),
                _buildRadio('和暦', 1, _viewModel.eraMode, (v) => _viewModel.setEraMode(v!)),
              ],
            ),
          ),
          FormRow(
            label: '和暦基準年',
            content: _buildTextField(
              _viewModel.eraBaseYear,
              onChanged: (v) => _viewModel.setEraBaseYear(v),
            ),
          ),
          FormRow(
            label: '和暦マーク',
            content: _buildTextField(
              _viewModel.eraMark,
              onChanged: (v) => _viewModel.setEraMark(v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String label, int value, int groupValue, ValueChanged<int?> onChanged) {
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

  Widget _buildTextField(String initialValue, {ValueChanged<String>? onChanged, bool enabled = true}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      style: TextStyle(fontSize: 13.sp),
    );
  }
}
