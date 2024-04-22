import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Initialize untuk mendapatkan format tanggal lokal
  static Future initialize() async {
    await initializeDateFormatting();
  }

  /// mengembalikan dateformat berdasarkan local date format
  /// isi [tanggal] dengan DateTime atau TimeStamp
  /// [format] default =  dd MMMM yyyy , hasil : 12 Juni 2002
  static String? dateFormat(dynamic tanggal,
      {String format = 'dd MMMM yyyy',
      String locale = 'id',
      Duration? addDuration}) {
    String? hasil;

    DateTime? date = toDateTime(tanggal);
    if (date != null) {
      if (addDuration != null) {
        date = date.add(addDuration);
      }
      hasil = DateFormat(format, locale).format(date).toString();
    }
    return hasil;
  }

  static String? dateLogFormat(dynamic tanggal,
      {String format = 'dd/MM/yyyy',
      String locale = 'id',
      Duration? addDuration}) {
    String? hasil;
    DateTime now = DateTime.now();
    DateTime? dtanggal = tanggal;
    if (dtanggal != null) {
      if (addDuration != null) {
        dtanggal = dtanggal.add(addDuration);
      }
      if (dateFormat(dtanggal) == dateFormat(now)) {
        hasil = dateFormat(dtanggal, format: "HH:mm a", locale: locale);
      } else if (dateFormat(now.add(const Duration(days: -1))) ==
          dateFormat(dtanggal)) {
        hasil = dateFormat(dtanggal, format: "dd MMM", locale: locale);
      } else {
        hasil = dateFormat(dtanggal, format: format, locale: locale);
      }
    }
    return hasil;
  }

  static String? mailFormat(dynamic tanggal,
      {String locale = 'id', Duration? addDuration}) {
    String? hasil;
    DateTime now = DateTime.now();
    DateTime? dtanggal = toDateTime(tanggal);
    if (dtanggal != null) {
      // Jika ada perbedaan jam
      if (addDuration != null) {
        dtanggal = dtanggal.add(addDuration);
      }
      // Kalo hari ini
      if (dateFormat(dtanggal) == dateFormat(now)) {
        hasil = dateFormat(dtanggal, format: "HH:mm", locale: locale);
        // Kalo tahun ini
      } else if (dateFormat(now, format: 'yyyy') ==
          dateFormat(dtanggal, format: 'yyyy')) {
        hasil = dateFormat(dtanggal, format: "dd MMMM", locale: locale);
        // kalo tahun lalu
      } else {
        hasil = dateFormat(dtanggal, format: 'dd/MM/yyyy', locale: locale);
      }
    }
    return hasil;
  }

  static String? dateChatFormat(dynamic tanggal,
      {String format = 'dd/MM/yyyy', String locale = 'id'}) {
    String? hasil;
    DateTime now = DateTime.now();
    if (tanggal != null) {
      if (dateFormat(tanggal) == dateFormat(now)) {
        hasil = 'Hari ini';
      } else if (dateFormat(now.add(const Duration(days: -1))) ==
          dateFormat(tanggal)) {
        hasil = 'Kemarin';
      } else {
        hasil = dateFormat(tanggal, format: format, locale: locale);
      }
    }
    return hasil;
  }

  /// Mengembalikan Durasi perbandingan antara [tanggala] dan [tanggalb]
  /// Isi [tanggala] maupun [tanggalb] dengan DateTime ataupun TimeStamp
  static Duration differenceTime(dynamic tanggalAwal, dynamic tanggalAkhir) {
    DateTime awal, akhir;

    if (tanggalAwal is DateTime) {
      awal = tanggalAwal;
    } else {
      return const Duration(milliseconds: 0);
    }

    if (tanggalAkhir is DateTime) {
      akhir = tanggalAkhir;
    } else {
      return const Duration(milliseconds: 0);
    }

    Duration duration = akhir.difference(awal);
    return duration;
  }

  static DateTime? toDateTime(dynamic tanggal) {
    if (tanggal is String) {
      return DateTime.tryParse(tanggal);
    }
    if (tanggal is DateTime) {
      return tanggal;
    }
    return null;
  }
}
