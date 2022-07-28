class DisposisiSuratModel {
  final List<DisposisiSurat> disposisiSurat;

  DisposisiSuratModel({
    this.disposisiSurat
  });

  factory DisposisiSuratModel.fromJson(List<dynamic> parsedJson) {

    List<DisposisiSurat> disposisiSurat = new List<DisposisiSurat>();
    disposisiSurat = parsedJson.map((i)=>DisposisiSurat.fromJson(i)).toList();

    return new DisposisiSuratModel(
        disposisiSurat: disposisiSurat
    );
  }
}

class DisposisiSurat{
  final int id;
  final int masuk_id;
  final String status;
  final String read_at;
  final String satker_penerima;
  final String satker_dari;
  final String batas_at;
  Masuk masuk;

  DisposisiSurat({
    this.id,
    this.masuk_id,
    this.status,
    this.read_at,
    this.satker_penerima,
    this.satker_dari,
    this.batas_at,
    this.masuk
  }) ;

  factory DisposisiSurat.fromJson(Map<String, dynamic> json){

    return new DisposisiSurat(
        id: json['id'],
        masuk_id: json['masuk_id'],
        status: json['status'],
        read_at: json['read_at'],
        satker_penerima: json['satker_penerima'],
        satker_dari: json['satker_dari'],
        batas_at: json['batas_at'],
        masuk: Masuk.fromJson(json['masuk'])
    );
  }

}

class Masuk{
  int id;
  String no_surat;
  String perihal;

  Masuk({
    this.id,
    this.no_surat,
    this.perihal
  });

  factory Masuk.fromJson(Map<String, dynamic> json){
    return Masuk(
        id: json['id'],
        no_surat: json['no_surat'],
        perihal: json['perihal']
    );
  }
}