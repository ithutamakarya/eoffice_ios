class DashboardChartModel{
  Last3MonthMasuk last3monthMasuk;
  Last3MonthKeluar last3monthKeluar;
  Last3MonthMemo last3monthMemo;
  JumlahUnread jmlUnread;
  List<FiveMasuk> fiveMasuk;
  List<FiveMemo> fiveMemo;
  List<FiveKeluar> fiveKeluar;
  List<Menu> menu;
  int jmlnotif;
  List<ListNotif> listnotif;

  DashboardChartModel({this.last3monthMasuk, this.last3monthKeluar, this.last3monthMemo, this.jmlUnread, this.fiveMasuk, this.fiveMemo, this.fiveKeluar, this.menu, this.jmlnotif, this.listnotif});

  factory DashboardChartModel.fromJson(Map<String, dynamic> parsedJson){

    var listFiveMasuk = parsedJson['fivemasuk'] as List;
    List<FiveMasuk> fiveMasuk = listFiveMasuk.map((i) => FiveMasuk.fromJson(i)).toList();

    var listFiveMemo = parsedJson['fivememo'] as List;
    List<FiveMemo> fiveMemo = listFiveMemo.map((i) => FiveMemo.fromJson(i)).toList();

    var listFiveKeluar = parsedJson['fivekeluar'] as List;
    List<FiveKeluar> fiveKeluar = listFiveKeluar.map((i) => FiveKeluar.fromJson(i)).toList();

    var listMenu = parsedJson['menu'] as List;
    List<Menu> menu = listMenu.map((i) => Menu.fromJson(i)).toList();

    var listNotif = parsedJson['listnotif'] as List;
    List<ListNotif> listnotif = listNotif.map((i) => ListNotif.fromJson(i)).toList();

    return DashboardChartModel(
      last3monthMasuk: Last3MonthMasuk.fromJson(parsedJson['last3monthMasuk']),
      last3monthKeluar: Last3MonthKeluar.fromJson(parsedJson['last3monthKeluar']),
      last3monthMemo: Last3MonthMemo.fromJson(parsedJson['last3monthMemo']),
      jmlUnread: JumlahUnread.fromJson(parsedJson['jmlUnread']),
      fiveMasuk: fiveMasuk,
      fiveMemo: fiveMemo,
      fiveKeluar: fiveKeluar,
      menu: menu,
      jmlnotif: parsedJson['jmlnotif'],
      listnotif: listnotif,

    );
  }
}



class Last3MonthMasuk{
  String minMaxmonth;
  List<Data> dataMasuk;

  Last3MonthMasuk({this.minMaxmonth, this.dataMasuk});

  factory Last3MonthMasuk.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<Data> dataMasuk = list.map((i) => Data.fromJson(i)).toList();

    return Last3MonthMasuk(
        minMaxmonth: parsedJson['minMaxmonth'],
        dataMasuk: dataMasuk
    );
  }
}

class Last3MonthMemo{
  String minMaxmonth;
  List<Data> dataMemo;

  Last3MonthMemo({this.minMaxmonth, this.dataMemo});

  factory Last3MonthMemo.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<Data> dataMemo = list.map((i) => Data.fromJson(i)).toList();

    return Last3MonthMemo(
        minMaxmonth: parsedJson['minMaxmonth'],
        dataMemo: dataMemo
    );
  }
}

class Last3MonthKeluar{
  String minMaxmonth;
  List<Data> dataKeluar;

  Last3MonthKeluar({this.minMaxmonth, this.dataKeluar});

  factory Last3MonthKeluar.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<Data> dataKeluar = list.map((i) => Data.fromJson(i)).toList();

    return Last3MonthKeluar(
        minMaxmonth: parsedJson['minMaxmonth'],
        dataKeluar: dataKeluar
    );
  }
}

class Data{
  String label;
  int value;

  Data({this.label, this.value});

  factory Data.fromJson(Map<String, dynamic> parsedJson){

    return Data(
        label: parsedJson['label'],
        value: parsedJson['value']
    );
  }
}

class FiveMasuk{
  int id;
  String created_at;
  Masuk masuk;
  int masuk_id;
  String satker_penerima;

  FiveMasuk({this.id, this.created_at, this.masuk, this.masuk_id, this.satker_penerima});

  factory FiveMasuk.fromJson(Map<String, dynamic> parsedJson){

    return FiveMasuk(
      id: parsedJson['id'],
      created_at: parsedJson['created_at'],
      masuk: Masuk.fromJson(parsedJson['masuk']),
      masuk_id: parsedJson['masuk_id'],
      satker_penerima: parsedJson['satker_penerima'],
    );
  }
}

class FiveMemo{
  int id;
  String created_at;
  Masuk masuk;
  int masuk_id;
  String satker_penerima;

  FiveMemo({this.id, this.created_at, this.masuk, this.masuk_id, this.satker_penerima});

  factory FiveMemo.fromJson(Map<String, dynamic> parsedJson){

    return FiveMemo(
      id: parsedJson['id'],
      created_at: parsedJson['created_at'],
      masuk: Masuk.fromJson(parsedJson['masuk']),
      masuk_id: parsedJson['masuk_id'],
      satker_penerima: parsedJson['satker_penerima'],
    );
  }
}

class FiveKeluar{
  int id;
  String created_at;
  Keluar keluar;
  int keluar_id;

  FiveKeluar({this.id, this.created_at, this.keluar, this.keluar_id});

  factory FiveKeluar.fromJson(Map<String, dynamic> parsedJson){

    return FiveKeluar(
      id: parsedJson['id'],
      created_at: parsedJson['created_at'],
      keluar: Keluar.fromJson(parsedJson['keluar']),
      keluar_id: parsedJson['keluar_id'],
    );
  }
}

class Masuk{
  String no_surat;

  Masuk({this.no_surat});

  factory Masuk.fromJson(Map<String, dynamic> parsedJson){

    return Masuk(
      no_surat: parsedJson['no_surat'],
    );
  }
}

class Keluar{
  String no_surat;
  String versi_akhir;

  Keluar({this.no_surat,this.versi_akhir});

  factory Keluar.fromJson(Map<String, dynamic> parsedJson){

    return Keluar(
      no_surat: parsedJson['no_surat'],
      versi_akhir: parsedJson['versi_akhir'],
    );
  }
}

class JumlahUnread{
  int dismasuk;
  int memo_masuk;
  int diskeluar;

  JumlahUnread({this.dismasuk, this.memo_masuk, this.diskeluar});

  factory JumlahUnread.fromJson(Map<String, dynamic> parsedJson){

    return JumlahUnread(
        dismasuk: parsedJson['dismasuk'],
        memo_masuk: parsedJson['memo_masuk'],
        diskeluar: parsedJson['diskeluar']
    );
  }
}

class Menu{
  String label;
  Child child;

  Menu({this.label, this.child});

  factory Menu.fromJson(Map<String, dynamic> parsedJson){

    return Menu(
      label: parsedJson['label'],
      child: Child.fromJson(parsedJson['child']),

    );
  }
}

class Child{
  Menus menu;

  Child({this.menu});

  factory Child.fromJson(Map<String, dynamic> parsedJson){

    return Child(
      menu: Menus.fromJson(parsedJson['menu']),
    );
  }
}

class Menus{
  String menu1;
  String menu2;
  String menu3;

  Menus({this.menu1, this.menu2, this.menu3});

  factory Menus.fromJson(Map<String, dynamic> parsedJson){

    return Menus(
      menu1: parsedJson['Menu1'],
      menu2: parsedJson['Menu2'],
      menu3: parsedJson['Menu3'],
    );
  }
}

class ListNotif{
  String id;
  String judul;
  String perihal;
  String masukke;
  String disposisiid;

  ListNotif({this.id, this.judul, this.perihal, this.masukke, this.disposisiid});

  factory ListNotif.fromJson(Map<String, dynamic> parsedJson){

    return ListNotif(
      id: parsedJson['id'],
      judul: parsedJson['judul'],
      perihal: parsedJson['perihal'],
      masukke: parsedJson['masukke'],
      disposisiid: parsedJson['disposisiid'],
    );
  }
}