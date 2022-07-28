class DetailTrackingSuratKeluarModel {
  final List<DetailTrackingSuratKeluar> detailTrackingSuratKeluar;

  DetailTrackingSuratKeluarModel({
    this.detailTrackingSuratKeluar
  });

  factory DetailTrackingSuratKeluarModel.fromJson(List<dynamic> parsedJson) {

    List<DetailTrackingSuratKeluar> detailTrackingSuratKeluar = new List<DetailTrackingSuratKeluar>();
    detailTrackingSuratKeluar = parsedJson.map((i)=>DetailTrackingSuratKeluar.fromJson(i)).toList();

    return new DetailTrackingSuratKeluarModel(
        detailTrackingSuratKeluar: detailTrackingSuratKeluar
    );
  }
}

class DetailTrackingSuratKeluar{
  final int id;
  final String tanggapan;
  final bool status;
  final String updated_at;
  final String group;
  Satker satker;

  DetailTrackingSuratKeluar({
    this.id,
    this.tanggapan,
    this.status,
    this.updated_at,
    this.group,
    this.satker,
  }) ;

  factory DetailTrackingSuratKeluar.fromJson(Map<String, dynamic> json){

    return new DetailTrackingSuratKeluar(
        id: json['id'],
        tanggapan: json['tanggapan'],
        status: json['status'],
        updated_at: json['updated_at'],
        group: json['group'],
        satker: Satker.fromJson(json['satker'])
    );
  }

}

class Satker{
  int id;
  String name;

  Satker({
    this.id,
    this.name
  });

  factory Satker.fromJson(Map<String, dynamic> parsedJson){
    return Satker(
        id: parsedJson['id'],
        name : parsedJson['name']
    );
  }
}