import '../../../../core/viewmodel/base_view_model.dart';

class TimeSlot {
  String startHour;
  String startMinute;
  String endHour;
  String endMinute;

  TimeSlot({
    this.startHour = '00',
    this.startMinute = '00',
    this.endHour = '00',
    this.endMinute = '00',
  });
}

class SummaryTimeViewModel extends BaseViewModel {
  final List<TimeSlot> _timeSlots = List.generate(24, (_) => TimeSlot());
  int? _selectedSlotIndex;

  List<TimeSlot> get timeSlots => _timeSlots;
  int? get selectedSlotIndex => _selectedSlotIndex;

  void setSelectedSlot(int? index) {
    _selectedSlotIndex = index;
    notifyListeners();
  }

  void updateSlot(int index, {String? sh, String? sm, String? eh, String? em}) {
    if (sh != null) _timeSlots[index].startHour = sh;
    if (sm != null) _timeSlots[index].startMinute = sm;
    if (eh != null) _timeSlots[index].endHour = eh;
    if (em != null) _timeSlots[index].endMinute = em;
    notifyListeners();
  }

  void onSave() {
    setLoading(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }
}
