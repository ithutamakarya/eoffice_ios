class DetailTrackingSuratMasukNew{
  final int id;
  final String satker_name;
  final String satker_dari;
  final String catatan_pengirim;
  final String catatan_sendiri;
  final String status;
  final String read;
  final String tgl_disposisi;
  final String tgl_batas;
  final String tgl_tanggapan;
  final List<Childs> childs;

  DetailTrackingSuratMasukNew({
    this.id,
    this.satker_name,
    this.satker_dari,
    this.catatan_pengirim,
    this.catatan_sendiri,
    this.status,
    this.read,
    this.tgl_disposisi,
    this.tgl_batas,
    this.tgl_tanggapan,
    this.childs
  });

  factory DetailTrackingSuratMasukNew.fromJson(Map<String, dynamic> json){

    var listChilds = json['child'] as List;
    List<Childs> childs = listChilds.map((a) => Childs.fromJson(a)).toList();

    return DetailTrackingSuratMasukNew(
        id: json['id'],
        satker_name: json['satker_name'],
        satker_dari: json['satker_dari'],
        catatan_pengirim: json['catatan_pengirim'],
        catatan_sendiri: json['catatan_sendiri'],
        status: json['status'],
        read: json['read'],
        tgl_disposisi: json['tgl_disposisi'],
        tgl_batas: json['tgl_batas'],
        tgl_tanggapan: json['tgl_tanggapan'],
        childs: childs

    );
  }
}

class Childs{
  final int id;
  final String satker_name;
  final String satker_dari;
  final String catatan_pengirim;
  final String catatan_sendiri;
  final String status;
  final String read;
  final String tgl_disposisi;
  final String tgl_batas;
  final String tgl_tanggapan;
  final List<DetailCatatan> detail_catatan;
  final List<Child> child;

  Childs({
    this.id,
    this.satker_name,
    this.satker_dari,
    this.catatan_pengirim,
    this.catatan_sendiri,
    this.status,
    this.read,
    this.tgl_disposisi,
    this.tgl_batas,
    this.tgl_tanggapan,
    this.detail_catatan,
    this.child
  }) ;

  factory Childs.fromJson(Map<String, dynamic> json){

    var listChild = json['child'] as List;
    List<Child> child = listChild.map((a) => Child.fromJson(a)).toList();

    var listDetailCatatan = json['detail_catatan'] as List;
    List<DetailCatatan> detail_catatan = listDetailCatatan.map((a) => DetailCatatan.fromJson(a)).toList();

    return new Childs(
        id: json['id'],
        satker_name: json['satker_name'],
        satker_dari: json['satker_dari'],
        catatan_pengirim: json['catatan_pengirim'],
        catatan_sendiri: json['catatan_sendiri'],
        status: json['status'],
        read: json['read'],
        tgl_disposisi: json['tgl_disposisi'],
        tgl_batas: json['tgl_batas'],
        tgl_tanggapan: json['tgl_tanggapan'],
        detail_catatan: detail_catatan,
        child: child
    );
  }

}

class Child{
  final int id;
  final String satker_name;
  final String satker_dari;
  final String catatan_pengirim;
  final String catatan_sendiri;
  final String status;
  final String read;
  final String tgl_disposisi;
  final String tgl_batas;
  final String tgl_tanggapan;
  final List<DetailCatatan> detail_catatan;
  final List<Child> child;

  Child({
    this.id,
    this.satker_name,
    this.satker_dari,
    this.catatan_pengirim,
    this.catatan_sendiri,
    this.status,
    this.read,
    this.tgl_disposisi,
    this.tgl_batas,
    this.tgl_tanggapan,
    this.detail_catatan,
    this.child
  }) ;

  factory Child.fromJson(Map<String, dynamic> json){

    var listChild = json['child'] as List;
    List<Child> child = listChild.map((a) => Child.fromJson(a)).toList();

    var listDetailCatatan = json['detail_catatan'] as List;
    List<DetailCatatan> detail_catatan = listDetailCatatan.map((a) => DetailCatatan.fromJson(a)).toList();

    return new Child(
        id: json['id'],
        satker_name: json['satker_name'],
        satker_dari: json['satker_dari'],
        catatan_pengirim: json['catatan_pengirim'],
        catatan_sendiri: json['catatan_sendiri'],
        status: json['status'],
        read: json['read'],
        tgl_disposisi: json['tgl_disposisi'],
        tgl_batas: json['tgl_batas'],
        tgl_tanggapan: json['tgl_tanggapan'],
        detail_catatan: detail_catatan,
        child: child
    );
  }

}

class DetailCatatan {
  final String penerima;
  final String catatan;
  final String tgl_kirim;

  DetailCatatan({
    this.penerima,
    this.catatan,
    this.tgl_kirim
  });

  factory DetailCatatan.fromJson(Map<String, dynamic> json){
    return new DetailCatatan(
        penerima: json['penerima'],
        catatan: json['catatan'],
        tgl_kirim: json['tgl_kirim']
    );
  }
}