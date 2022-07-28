class DetailTrackingSuratMasukModel {
  final List<DetailTrackingSuratMasuk> detailTrackingSuratMasuk;

  DetailTrackingSuratMasukModel({
    this.detailTrackingSuratMasuk
  });

  factory DetailTrackingSuratMasukModel.fromJson(List<dynamic> parsedJson) {

    List<DetailTrackingSuratMasuk> detailTrackingSuratMasuk = new List<DetailTrackingSuratMasuk>();
    detailTrackingSuratMasuk = parsedJson.map((i)=>DetailTrackingSuratMasuk.fromJson(i)).toList();

    return new DetailTrackingSuratMasukModel(
        detailTrackingSuratMasuk: detailTrackingSuratMasuk
    );
  }
}

class DetailTrackingSuratMasuk{
  final int id;
  final String read_at;
  final String status;
  final String satker_penerima;
  final List<Child> childList;
  final String tanggapan;

  DetailTrackingSuratMasuk({
    this.id,
    this.read_at,
    this.status,
    this.satker_penerima,
    this.childList,
    this.tanggapan
  }) ;

  factory DetailTrackingSuratMasuk.fromJson(Map<String, dynamic> json){

    var list = json['child'] as List;
    List<Child> childs = list.map((i) => Child.fromJson(i)).toList();

    return new DetailTrackingSuratMasuk(
        id: json['id'],
        read_at: json['read_at'],
        status: json['status'],
        satker_penerima: json['satker_penerima'],
        childList: childs,
        tanggapan: json['tanggapan']
    );
  }

}

class Child {
  int id;
  final String satker_penerima;

  Child({this.id, this.satker_penerima});

  factory Child.fromJson(Map<String, dynamic> parsedJson){
    return Child(
        id: parsedJson['id'],
        satker_penerima: parsedJson['satker_penerima']
    );
  }
}