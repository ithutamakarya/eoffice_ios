class TrackingSuratMasukModel {
  final List<TrackingSuratMasuk> trackingSuratMasukModel;

  TrackingSuratMasukModel({
    this.trackingSuratMasukModel
  });

  factory TrackingSuratMasukModel.fromJson(List<dynamic> parsedJson) {

    List<TrackingSuratMasuk> trackingSuratMasukModel = new List<TrackingSuratMasuk>();
    trackingSuratMasukModel = parsedJson.map((i)=>TrackingSuratMasuk.fromJson(i)).toList();

    return new TrackingSuratMasukModel(
        trackingSuratMasukModel: trackingSuratMasukModel
    );
  }
}

class TrackingSuratMasuk{
  final int id;
  final String no_surat;
  final String surat_at;
  final String perihal;
  final String batas_at;
  final List<Disposisi> disposisiList;

  TrackingSuratMasuk({
    this.id,
    this.no_surat,
    this.surat_at,
    this.perihal,
    this.batas_at,
    this.disposisiList
  }) ;

  factory TrackingSuratMasuk.fromJson(Map<String, dynamic> json){

    var listDisposisi = json['disposisi'] as List;
    List<Disposisi> disposisi = listDisposisi.map((a) => Disposisi.fromJson(a)).toList();

    return new TrackingSuratMasuk(
        id: json['id'],
        no_surat: json['no_surat'],
        surat_at: json['surat_at'],
        perihal: json['perihal'],
        batas_at: json['batas_at'],
        disposisiList: disposisi
    );
  }

}

class Disposisi {
  final int id;
  final String satker_dari;

  Disposisi({
    this.id,
    this.satker_dari
  });

  factory Disposisi.fromJson(Map<String, dynamic> parsedJson){
    return Disposisi(
        id: parsedJson['id'],
        satker_dari: parsedJson['satker_dari']
    );
  }
}