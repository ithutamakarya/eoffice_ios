class MemoKeluarModel {
  final List<MemoKeluarList> memoKeluar;

  MemoKeluarModel({
    this.memoKeluar
  });

  factory MemoKeluarModel.fromJson(List<dynamic> parsedJson) {

    List<MemoKeluarList> memoKeluar = new List<MemoKeluarList>();
    memoKeluar = parsedJson.map((i)=>MemoKeluarList.fromJson(i)).toList();

    return new MemoKeluarModel(
        memoKeluar: memoKeluar
    );
  }
}

class MemoKeluarList{
  final int id;
  final String no_surat;
  final String surat_at;
  final String mail_type;
  final String mailer_name;
  final String batas_at;
  final String untuk;

  MemoKeluarList({
    this.id,
    this.no_surat,
    this.surat_at,
    this.mail_type,
    this.mailer_name,
    this.batas_at,
    this.untuk
  }) ;

  factory MemoKeluarList.fromJson(Map<String, dynamic> json){

    return new MemoKeluarList(
        id: json['id'],
        no_surat: json['no_surat'],
        surat_at: json['surat_at'],
        mail_type: json['mail_type'],
        mailer_name: json['mailer_name'],
        batas_at: json['batas_at'],
        untuk: json['untuk']
    );
  }

}