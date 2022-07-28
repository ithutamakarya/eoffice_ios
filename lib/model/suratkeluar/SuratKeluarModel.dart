class SuratKeluarModel {
  final List<SuratKeluarList> suratKeluar;

  SuratKeluarModel({
    this.suratKeluar
  });

  factory SuratKeluarModel.fromJson(List<dynamic> parsedJson) {

    List<SuratKeluarList> suratKeluar = new List<SuratKeluarList>();
    suratKeluar = parsedJson.map((i)=>SuratKeluarList.fromJson(i)).toList();

    return new SuratKeluarModel(
        suratKeluar: suratKeluar
    );
  }
}

class SuratKeluarList{
  final int id;
  final String code;
  final String no_surat;
  final String surat_at;
  final String kepada;
  final String perihal;
  final String versi_akhir;

  SuratKeluarList({
    this.id,
    this.code,
    this.no_surat,
    this.surat_at,
    this.versi_akhir,
    this.perihal,
    this.kepada
  }) ;

  factory SuratKeluarList.fromJson(Map<String, dynamic> json){

    return new SuratKeluarList(
      id: json['id'],
      code: json['code'],
      no_surat: json['no_surat'],
      surat_at: json['surat_at'],
      versi_akhir: json['versi_akhir'],
      perihal: json['perihal'],
      kepada: json['kepada'],
    );
  }

}