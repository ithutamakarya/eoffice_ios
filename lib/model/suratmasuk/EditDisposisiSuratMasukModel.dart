class EditDisposisiSuratMasukModel{
  int hitung;
  Disposisi disposisi;
  List<Mengetahui> mengetahui;
  final List<String> status;

  EditDisposisiSuratMasukModel({this.hitung, this.disposisi, this.mengetahui, this.status});

  factory EditDisposisiSuratMasukModel.fromJson(Map<String, dynamic> parsedJson){

    var listMengetahui = parsedJson['mengetahui'] as List;
    List<Mengetahui> mengetahui = listMengetahui.map((i) => Mengetahui.fromJson(i)).toList();

    var statusFromJson  = parsedJson['status'];
    List<String> statusList = statusFromJson.cast<String>();

    return EditDisposisiSuratMasukModel(
        hitung: parsedJson['hitung'],
        disposisi: Disposisi.fromJson(parsedJson['disposisi']),
        mengetahui: mengetahui,
        status: statusList

    );
  }
}



class Disposisi{
  String status;
  String satker_dari;
  String batas_at;
  int parent_id;
  String tanggapan;
  Masuk masuk;

  Disposisi({
    this.status,
    this.satker_dari,
    this.batas_at,
    this.masuk,
    this.parent_id,
    this.tanggapan
  });

  factory Disposisi.fromJson(Map<String, dynamic> parsedJson){
    return Disposisi(
        status: parsedJson['status'],
        satker_dari : parsedJson['satker_dari'],
        batas_at : parsedJson['batas_at'],
        masuk: Masuk.fromJson(parsedJson['masuk']),
        parent_id : parsedJson['parent_id'],
        tanggapan : parsedJson['tanggapan']
    );
  }

}

class Masuk{
  String no_surat;
  String surat_at;
  String catatan;
  String perihal;
  List<Files> files;

  Masuk({
    this.catatan,
    this.no_surat,
    this.surat_at,
    this.perihal,
    this.files
  });

  factory Masuk.fromJson(Map<String, dynamic> json){

    var listFiles = json['files'] as List;
    List<Files> files = listFiles.map((i) => Files.fromJson(i)).toList();

    return Masuk(
        no_surat: json['no_surat'],
        surat_at: json['surat_at'],
        catatan: json['catatan'],
        perihal: json['perihal'],
        files: files
    );
  }
}

class Files{
  String name;
  String path;

  Files({
    this.name,
    this.path
  });

  factory Files.fromJson(Map<String, dynamic> json){

    return Files(
        name: json['name'],
        path: json['path']
    );
  }
}

class Mengetahui{
  int id;
  String name;
  List<Child> child;

  Mengetahui({
    this.id,
    this.name,
    this.child
  });

  factory Mengetahui.fromJson(Map<String, dynamic> json){

    if (json['child'] != null) {

      var listChild = json['child'] as List;
      List<Child> child = listChild.map((i) => Child.fromJson(i)).toList();

      return Mengetahui(
        id: json['id'],
        name: json['name'],
        child: child,
      );
    } else {
      return Mengetahui(
        id: json['id'],
        name: json['name']
      );
    }
  }
}

class Child{
  int id;
  String name;
  List<Childs> childs;

  Child({this.id, this.name, this.childs});

  factory Child.fromJson(Map<String, dynamic> parsedJson){

    if (parsedJson['child'] != null) {

      var listChilds = parsedJson['child'] as List;
      List<Childs> childs = listChilds.map((i) => Childs.fromJson(i)).toList();

      return Child(
          id: parsedJson['id'],
          name : parsedJson['name'],
          childs: childs
      );

    } else {

      return Child(
          id: parsedJson['id'],
          name : parsedJson['name']
      );

    }
  }
}

class Childs{
  int id;
  String name;
  List<Childss> childss;

  Childs({this.id, this.name, this.childss});

  factory Childs.fromJson(Map<String, dynamic> parsedJson){

    if (parsedJson['child'] != null) {

      var listChildss = parsedJson['child'] as List;
      List<Childss> childss = listChildss.map((i) => Childss.fromJson(i)).toList();

      return Childs(
          id: parsedJson['id'],
          name : parsedJson['name'],
          childss: childss
      );

    } else {

      return Childs(
          id: parsedJson['id'],
          name : parsedJson['name']
      );

    }
  }

}

class Childss{
  int id;
  String name;

  Childss({this.id, this.name});

  factory Childss.fromJson(Map<String, dynamic> parsedJson){

    return Childss(
        id: parsedJson['id'],
        name : parsedJson['name']
    );
  }

}