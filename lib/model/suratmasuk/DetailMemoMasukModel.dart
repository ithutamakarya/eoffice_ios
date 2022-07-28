class DetailMemoMasukModel{
  Disposisi disposisi;

  DetailMemoMasukModel({
    this.disposisi
  });

  factory DetailMemoMasukModel.fromJson(Map<String, dynamic> parsedJson){
    return DetailMemoMasukModel(
        disposisi: Disposisi.fromJson(parsedJson['disposisi'])
    );

  }
}

class Disposisi{
  String satker_dari;
  Masuk masuk;

  Disposisi({
    this.satker_dari,
    this.masuk
  });

  factory Disposisi.fromJson(Map<String, dynamic> parsedJson){

    return Disposisi(
      satker_dari: parsedJson['satker_dari'],
      masuk: Masuk.fromJson(parsedJson['masuk']),
    );
  }
}

class Masuk{
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

  Masuk({
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

  factory Masuk.fromJson(Map<String, dynamic> parsedJson){

    var listFiles = parsedJson['files'] as List;
    List<Files> filesFiles = listFiles.map((i) => Files.fromJson(i)).toList();


    return Masuk(
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
    this.path});

  factory Files.fromJson(Map<String, dynamic> parsedJson){
    return Files(
        id: parsedJson['id'],
        name: parsedJson['name'],
        path: parsedJson['path']
    );
  }
}