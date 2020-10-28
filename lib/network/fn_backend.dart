import 'package:local_fiscal_service/kkt/field.dart';
import 'package:local_fiscal_service/kkt/fn_record.dart';
import 'package:local_fiscal_service/network/fn_state.dart';

abstract class FnBackend {
  // void registerListener(FnBackendListener listener);
  FnRecord processRecord(FnRecord record);
  String getFnNumber();
  String getKktNumber();
  bool isOnline();
  int getRemainedTicketCount();
  List<Field> getCounters();
  FnState getFnState();
  List<FnRecord> getDocumentsInQueue();
  void verifyPin(int pin);
  String makeToken();
}