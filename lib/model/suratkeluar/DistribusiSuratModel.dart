class DistribusiSuratModel {
  final List<DistribusiSuratList> distribusiSurat;

  DistribusiSuratModel({
    this.distribusiSurat
  });

  factory DistribusiSuratModel.fromJson(List<dynamic> parsedJson) {

    List<DistribusiSuratList> distribusiSurat = new List<DistribusiSuratList>();
    distribusiSurat = parsedJson.map((i)=>DistribusiSuratList.fromJson(i)).toList();

    return new DistribusiSuratModel(
        distribusiSurat: distribusiSurat
    );
  }
}

class DistribusiSuratList{
  final int id;
  final String read_at;
  SatkerFrom satker_from;
  Keluar keluar;
  Satker satker;

  DistribusiSuratList({
    this.id,
    this.read_at,
    this.satker_from,
    this.keluar,
    this.satker
  }) ;

  factory DistribusiSuratList.fromJson(Map<String, dynamic> json){

    return new DistribusiSuratList(
      id: json['id'],
      read_at: json['read_at'],
      satker_from: SatkerFrom.fromJson(json['satker_from']),
      keluar: Keluar.fromJson(json['keluar']),
      satker: Satker.fromJson(json['satker']),
    );
  }

}


class Keluar{
  int id;
  String no_surat;
  String surat_at;
  String perihal;
  String versi_akhir;
  String kepada;
  int jml_approve;

  Keluar({
    this.id,
    this.no_surat,
    this.surat_at,
    this.perihal,
    this.versi_akhir,
    this.kepada,
    this.jml_approve
  });

  factory Keluar.fromJson(Map<String, dynamic> json){

    return Keluar(
      id: json['id'],
      no_surat: json['no_surat'],
      surat_at: json['surat_at'],
      perihal: json['perihal'],
      versi_akhir: json['versi_akhir'],
      kepada: json['kepada'],
      jml_approve: json['jml_approve'],
    );
  }
}

class SatkerFrom{
  String name;

  SatkerFrom({
    this.name
  });

  factory SatkerFrom.fromJson(Map<String, dynamic> json){
    return SatkerFrom(
        name: json['name']
    );
  }
}

class Satker{
  String name;

  Satker({
    this.name
  });

  factory Satker.fromJson(Map<String, dynamic> json){
    return Satker(
        name: json['name']
    );
  }
}