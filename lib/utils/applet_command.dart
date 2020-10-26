class AppletCommand {
  const AppletCommand(this.code) : super();

  final int code;

  static const AppletCommand WRITE_ITEM = AppletCommand(2);
  static const AppletCommand READ_ITEM = AppletCommand(3);
  static const AppletCommand ENCRYPT_DATA = AppletCommand(5);
  static const AppletCommand SET_ENCRYPTION_KEY = AppletCommand(6);
  static const AppletCommand GET_ITEM_COUNT = AppletCommand(7);
  static const AppletCommand ERASE_ITEM = AppletCommand(8);
  static const AppletCommand ERASE_ALL_ITEMS = AppletCommand(9);
  static const AppletCommand PROCESS_ITEM = AppletCommand(10);
  static const AppletCommand CMAC_DATA = AppletCommand(13);
  static const AppletCommand SET_MAC_KEY = AppletCommand(14);
  static const AppletCommand SET_FN_NUMBER = AppletCommand(16);
  static const AppletCommand GET_FN_NUMBER = AppletCommand(17);
  static const AppletCommand GET_FREE_MEMORY = AppletCommand(18);
  static const AppletCommand GET_COUNTERS = AppletCommand(19);
  static const AppletCommand SET_COUNTERS = AppletCommand(20);
  static const AppletCommand HANDLE_DOCUMENT = AppletCommand(21);
  static const AppletCommand VERIFY_PIN = AppletCommand(22);
  static const AppletCommand READ_LAST_RESULT = AppletCommand(23);

  static const int GET_COUNTERS_P1_FIELDS = 0;
  static const int GET_COUNTERS_P1_STATE = 1;
  static const int GET_COUNTERS_P1_SHIFT_SUMMARY = 2;
  static const int GET_COUNTERS_P1_FN_SUMMARY = 3;
  static const int SET_COUNTERS_P1_FIELDS = 0;
  static const int SET_COUNTERS_P1_RESET = 1;
  static const int SET_COUNTERS_P1_FULL_RESET = 2;
}


// Original class:
// public enum AppletCommand {
//   WRITE_ITEM(2),
// READ_ITEM(3),
// ENCRYPT_DATA(5),
// SET_ENCRYPTION_KEY(6),
// GET_ITEM_COUNT(7),
// ERASE_ITEM(8),
// ERASE_ALL_ITEMS(9),
// PROCESS_ITEM(10),
// CMAC_DATA(13),
// SET_MAC_KEY(14),
// SET_FN_NUMBER(16),
// GET_FN_NUMBER(17),
// GET_FREE_MEMORY(18),
// GET_COUNTERS(19),
// SET_COUNTERS(20),
// HANDLE_DOCUMENT(21),
// VERIFY_PIN(22),
// READ_LAST_RESULT(23);
//
// public static final byte GET_COUNTERS_P1_FIELDS = 0;
// public static final byte GET_COUNTERS_P1_STATE = 1;
// public static final byte GET_COUNTERS_P1_SHIFT_SUMMARY = 2;
// public static final byte GET_COUNTERS_P1_FN_SUMMARY = 3;
// public static final byte SET_COUNTERS_P1_FIELDS = 0;
// public static final byte SET_COUNTERS_P1_RESET = 1;
// public static final byte SET_COUNTERS_P1_FULL_RESET = 2;
// public final int code;
//
// private AppletCommand(int code) {
//   this.code = code;
// }
// }