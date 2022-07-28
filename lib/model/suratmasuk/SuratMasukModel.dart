class SuratMasukModel {
  final List<SuratMasukList> suratMasuk;

  SuratMasukModel({
    this.suratMasuk
  });

  factory SuratMasukModel.fromJson(List<dynamic> parsedJson) {

    List<SuratMasukList> suratMasuk = new List<SuratMasukList>();
    suratMasuk = parsedJson.map((i)=>SuratMasukList.fromJson(i)).toList();

    return new SuratMasukModel(
        suratMasuk: suratMasuk
    );
  }
}

class SuratMasukList{
  final int id;
  final String no_surat;
  final String mail_type;
  final String mailer_name;
  final String batas_at;
  final String untuk;
  final String perihal;
  final List<Disposisi> disposisiList;

  SuratMasukList({
    this.id,
    this.no_surat,
    this.mail_type,
    this.mailer_name,
    this.batas_at,
    this.untuk,
    this.perihal,
    this.disposisiList
  }) ;

  factory SuratMasukList.fromJson(Map<String, dynamic> json){

    var listDisposisi = json['disposisi'] as List;
    List<Disposisi> disposisi = listDisposisi.map((a) => Disposisi.fromJson(a)).toList();

    return new SuratMasukList(
        id: json['id'],
        no_surat: json['no_surat'],
        mail_type: json['mail_type'],
        mailer_name: json['mailer_name'],
        batas_at: json['batas_at'],
        untuk: json['untuk'],
        perihal: json['perihal'],
        disposisiList: disposisi
    );
  }

}

class Sifat{
  int id;
  String code;
  String name;
  bool status;
  String created_at;
  String updated_at;

  Sifat({this.id, this.code, this.name, this. status, this.created_at, this.updated_at});

  factory Sifat.fromJson(Map<String, dynamic> parsedJson){
    return Sifat(
      id: parsedJson['id'],
      code : parsedJson['code'],
      name : parsedJson['name'],
      status : parsedJson['status'],
      created_at : parsedJson['created_at'],
      updated_at : parsedJson['updated_at']
    );
  }

}

class Jenis{
  int id;
  int parent_id;
  String code;
  String name;
  int user_id;
  int order;
  String notif;
  bool disposisi;
  bool status;
  String created_at;
  String updated_at;

  Jenis({this.id, this.parent_id, this.code, this.name, this.user_id, this.order, this.notif, this.disposisi, this.status, this.created_at, this.updated_at});

  factory Jenis.fromJson(Map<String, dynamic> parsedJson){
    return Jenis(
        id: parsedJson['id'],
        parent_id: parsedJson['parent_id'],
        code : parsedJson['code'],
        name : parsedJson['name'],
        user_id : parsedJson['user_id'],
        order : parsedJson['order'],
        notif : parsedJson['notif'],
        disposisi : parsedJson['disposisi'],
        status : parsedJson['status'],
        created_at : parsedJson['created_at'],
        updated_at : parsedJson['updated_at']
    );
  }
}

class Satker{
  int id;
  String code;
  String name;
  bool status;
  String created_at;
  String updated_at;

  Satker({this.id, this.code, this.name, this. status, this.created_at, this.updated_at});

  factory Satker.fromJson(Map<String, dynamic> parsedJson){
    return Satker(
        id: parsedJson['id'],
        code : parsedJson['code'],
        name : parsedJson['name'],
        status : parsedJson['status'],
        created_at : parsedJson['created_at'],
        updated_at : parsedJson['updated_at']
    );
  }
}

class File {
  final int id;
  final String name;
  final String size;
  final int masuk_id;
  final String deleted_at;
  final String created_at;
  final String updated_at;
  final String path;

  File({this.id, this.name, this.size, this.masuk_id, this.deleted_at, this.created_at, this.updated_at, this.path});

  factory File.fromJson(Map<String, dynamic> parsedJson){
    return File(
        id: parsedJson['id'],
        name: parsedJson['name'],
        size: parsedJson['size'],
        masuk_id: parsedJson['masuk_id'],
        deleted_at: parsedJson['deleted_at'],
        created_at: parsedJson['created_at'],
        updated_at: parsedJson['updated_at'],
        path: parsedJson['path']
    );
  }
}

class Disposisi {
  final int id;

  Disposisi({this.id});

  factory Disposisi.fromJson(Map<String, dynamic> parsedJson){
    return Disposisi(
      id: parsedJson['id']
    );
  }
}
