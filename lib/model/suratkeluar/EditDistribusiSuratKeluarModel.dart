class EditDistribusiSuratKeluarModel{
  Dis dis;
  VersiFiles versi_files;
  int countttd;

  EditDistribusiSuratKeluarModel({
    this.dis,
    this.versi_files,
    this.countttd
  });

  factory EditDistribusiSuratKeluarModel.fromJson(Map<String, dynamic> parsedJson){

    return EditDistribusiSuratKeluarModel(

        dis: Dis.fromJson(parsedJson['dis']),
        versi_files: VersiFiles.fromJson(parsedJson['versi_files']),
        countttd: parsedJson['countttd']
    );
  }
}



class Dis{
  int id;
  bool status;
  String approve_at;
  String group;
  String batas_at;
  SatkerDetail satker_detail;
  Keluar keluar;

  Dis({
    this.id,
    this.status,
    this.approve_at,
    this.group,
    this.batas_at,
    this.keluar,
    this.satker_detail
  });

  factory Dis.fromJson(Map<String, dynamic> parsedJson){
    return Dis(
      id: parsedJson['id'],
      status : parsedJson['status'],
      approve_at : parsedJson['approve_at'],
      group : parsedJson['group'],
      batas_at : parsedJson['batas_at'],
      satker_detail: SatkerDetail.fromJson(parsedJson['satker_detail']),
      keluar: Keluar.fromJson(parsedJson['keluar']),
    );
  }

}

class SatkerDetail{
  int id;
  String name;
  int user_id;

  SatkerDetail({
    this.id,
    this.name,
    this.user_id
  });

  factory SatkerDetail.fromJson(Map<String, dynamic> json){

    return SatkerDetail(
      id: json['id'],
      name: json['name'],
      user_id: json['user_id']
    );
  }
}

class Keluar{
  int id;
  String no_surat;
  String surat_at;
  String pengirim;
  String perihal;
  String isi;
  List<JSONPDF> json_pdf;
  String kepada;
  String catatan;

  Keluar({
    this.id,
    this.no_surat,
    this.surat_at,
    this.pengirim,
    this.perihal,
    this.isi,
    this.json_pdf,
    this.kepada,
    this.catatan
  });

  factory Keluar.fromJson(Map<String, dynamic> json){

    var listJsonPdf = json['json_pdf'] as List;
    List<JSONPDF> json_pdf = listJsonPdf.map((i) => JSONPDF.fromJson(i)).toList();

    return Keluar(
      id: json['id'],
      no_surat: json['no_surat'],
      surat_at: json['surat_at'],
      pengirim: json['pengirim'],
      perihal: json['perihal'],
      isi: json['isi'],
      json_pdf: json_pdf,
      kepada: json['kepada'],
      catatan: json['catatan'],
    );
  }
}

class JSONPDF{
  String name;
  String path;

  JSONPDF({
    this.name,
    this.path
  });

  factory JSONPDF.fromJson(Map<String, dynamic> json){
    return JSONPDF(
        name: json['name'],
        path: json['path']
    );
  }
}

class VersiFiles{
  int id;
  String name;
  String path;

  VersiFiles({
    this.id, this.name, this.path
  });

  factory VersiFiles.fromJson(Map<String, dynamic> parsedJson){
    return VersiFiles(
      id: parsedJson['id'],
      name : parsedJson['name'],
      path : parsedJson['path'],
    );
  }

}