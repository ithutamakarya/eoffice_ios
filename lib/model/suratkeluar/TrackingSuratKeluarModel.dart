class TrackingSuratKeluarModel {
  final List<TrackingSuratKeluar> trackingSuratKeluar;

  TrackingSuratKeluarModel({
    this.trackingSuratKeluar
  });

  factory TrackingSuratKeluarModel.fromJson(List<dynamic> parsedJson) {

    List<TrackingSuratKeluar> trackingSuratKeluar = new List<TrackingSuratKeluar>();
    trackingSuratKeluar = parsedJson.map((i)=>TrackingSuratKeluar.fromJson(i)).toList();

    return new TrackingSuratKeluarModel(
        trackingSuratKeluar: trackingSuratKeluar
    );
  }
}

class TrackingSuratKeluar{
  final int id;
  final String no_surat;
  final String surat_at;
  final String perihal;
  final String versi_akhir;
  PembuatAwal pembuat_awal;

  TrackingSuratKeluar({
    this.id,
    this.no_surat,
    this.surat_at,
    this.perihal,
    this.versi_akhir,
    this.pembuat_awal
  }) ;

  factory TrackingSuratKeluar.fromJson(Map<String, dynamic> json){

    return new TrackingSuratKeluar(
      id: json['id'],
      no_surat: json['no_surat'],
      surat_at: json['surat_at'],
      perihal: json['perihal'],
      versi_akhir: json['versi_akhir'],
      pembuat_awal: PembuatAwal.fromJson(json['pembuat_awal']),
    );
  }
}

class PembuatAwal{
  String name;

  PembuatAwal({this.name});

  factory PembuatAwal.fromJson(Map<String, dynamic> parsedJson){
    return PembuatAwal(
        name : parsedJson['name']
    );
  }
}