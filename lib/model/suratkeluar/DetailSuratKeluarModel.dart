class DetailSuratKeluarModel{
  DetailSurat detail_surat;

  DetailSuratKeluarModel({
    this.detail_surat
  });

  factory DetailSuratKeluarModel.fromJson(Map<String, dynamic> parsedJson){

    return DetailSuratKeluarModel(
      detail_surat: DetailSurat.fromJson(parsedJson['detail_surat']),
    );
  }
}



class DetailSurat{
  int id;
  String active_at;
  int sifat_id;
  int jeni_id;
  String code;
  String no_surat;
  String surat_at;
  String pengirim;
  String mail_type;
  String mailer_name;
  String perihal;
  String isi;
  int user_id;
  bool draft;
  String mengetahui;
  String deleted_at;
  String created_at;

  DetailSurat({
    this.id,
    this.active_at,
    this.sifat_id,
    this.jeni_id,
    this.code,
    this.no_surat,
    this.surat_at,
    this.pengirim,
    this.mail_type,
    this.mailer_name,
    this.perihal,
    this.isi,
    this.user_id,
    this.draft,
    this.mengetahui,
    this.deleted_at,
    this.created_at
  });

  factory DetailSurat.fromJson(Map<String, dynamic> parsedJson){
    return DetailSurat(
      id: parsedJson['id'],
      active_at : parsedJson['active_at'],
      sifat_id : parsedJson['sifat_id'],
      jeni_id : parsedJson['jeni_id'],
      code : parsedJson['code'],
      no_surat : parsedJson['no_surat'],
      surat_at : parsedJson['surat_at'],
      pengirim : parsedJson['pengirim'],
      mail_type : parsedJson['mail_type'],
      mailer_name : parsedJson['mailer_name'],
      perihal : parsedJson['perihal'],
      isi : parsedJson['isi'],
      user_id : parsedJson['user_id'],
      draft : parsedJson['draft'],
      mengetahui : parsedJson['mengetahui'],
      deleted_at : parsedJson['deleted_at'],
      created_at : parsedJson['created_at'],
    );
  }

}