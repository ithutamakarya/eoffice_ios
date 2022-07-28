class MemoMasukModel {
  final List<MemoMasukList> memoMasuk;

  MemoMasukModel({
    this.memoMasuk
  });

  factory MemoMasukModel.fromJson(List<dynamic> parsedJson) {

    List<MemoMasukList> memoMasuk = new List<MemoMasukList>();
    memoMasuk = parsedJson.map((i)=>MemoMasukList.fromJson(i)).toList();

    return new MemoMasukModel(
        memoMasuk: memoMasuk
    );
  }
}

class MemoMasukList{
  final int id;
  final String catatan;
  final String status;
  final String read_at;
  final String satker_penerima;
  final String satker_dari;
  Masuk masuk;

  MemoMasukList({
    this.id,
    this.catatan,
    this.status,
    this.read_at,
    this.satker_penerima,
    this.satker_dari,
    this.masuk
  }) ;

  factory MemoMasukList.fromJson(Map<String, dynamic> json){

    return new MemoMasukList(
        id: json['id'],
        catatan: json['catatan'],
        status: json['status'],
        read_at: json['read_at'],
        satker_penerima: json['satker_penerima'],
        satker_dari: json['satker_dari'],
        masuk: Masuk.fromJson(json['masuk'])
    );
  }

}

class Masuk{
  final int id;
  final String no_surat;
  final String batas_at;

  Masuk({
    this.id,
    this.batas_at,
    this.no_surat
  });

  factory Masuk.fromJson(Map<String, dynamic> json){

    return new Masuk(
        id: json['id'],
        batas_at: json['batas_at'],
        no_surat: json['no_surat']
    );
  }

}