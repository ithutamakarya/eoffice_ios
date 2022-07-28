class DetailMemoKeluarModel{
  DetailSurat detail_surat;
  final List<String> mengetahuiList;

  DetailMemoKeluarModel({
    this.detail_surat,
    this.mengetahuiList
  });

  factory DetailMemoKeluarModel.fromJson(Map<String, dynamic> parsedJson){
    var mengetahuiFromJson  = parsedJson['mengetahui'];
    List<String> mengetahuiList = mengetahuiFromJson.cast<String>();
    return DetailMemoKeluarModel(
        detail_surat: DetailSurat.fromJson(parsedJson['detail_surat']),
        mengetahuiList: mengetahuiList
    );

  }
}

class DetailSurat{
  int id;
  String active_at;
  String code;
  String no_surat;
  String surat_at;
  String mailer_name;
  String perihal;
  String catatan;
  String batas_at;
  String sifat_surat;
  String jenis_surat;
  String untuk;
  final List<Files> filesListFiles;

  DetailSurat({
    this.id,
    this.active_at,
    this.code,
    this.no_surat,
    this.surat_at,
    this.mailer_name,
    this.perihal,
    this.catatan,
    this.batas_at,
    this.sifat_surat,
    this.jenis_surat,
    this.untuk,
    this.filesListFiles
  });

  factory DetailSurat.fromJson(Map<String, dynamic> parsedJson){

    var listFiles = parsedJson['files'] as List;
    List<Files> filesFiles = listFiles.map((i) => Files.fromJson(i)).toList();


    return DetailSurat(
        id: parsedJson['id'],
        active_at : parsedJson['active_at'],
        code : parsedJson['code'],
        no_surat : parsedJson['no_surat'],
        surat_at : parsedJson['surat_at'],
        mailer_name : parsedJson['mailer_name'],
        perihal : parsedJson['perihal'],
        catatan : parsedJson['catatan'],
        batas_at : parsedJson['batas_at'],
        sifat_surat : parsedJson['sifat_surat'],
        jenis_surat : parsedJson['jenis_surat'],
        untuk : parsedJson['untuk'],
        filesListFiles: filesFiles
    );
  }
}

class Files {
  final int id;
  final String name;
  final String path;

  Files({
    this.id,
    this.name,
    this.path
  });

  factory Files.fromJson(Map<String, dynamic> parsedJson){
    return Files(
        id: parsedJson['id'],
        name: parsedJson['name'],
        path: parsedJson['path']
    );
  }
}