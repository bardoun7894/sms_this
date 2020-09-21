class data {
  bool status;
  String msg;
  Bills bills;

  data({this.status, this.msg, this.bills});

  data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    bills = json['Bills'] != null ? new Bills.fromJson(json['Bills']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.bills != null) {
      data['Bills'] = this.bills.toJson();
    }
    return data;
  }
}

class Bills {
  List<Facture> facture;

  Bills({this.facture});

  Bills.fromJson(Map<String, dynamic> json) {
    if (json['facture'] != null) {
      facture = new List<Facture>();
      json['facture'].forEach((v) {
        facture.add(new Facture.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.facture != null) {
      data['facture'] = this.facture.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Facture {
  int id;
  String homeId;
  String statut;
  String price;
  Null userId;
  Null time;
  Null description;
  String smsSend;
  String smsSendDate;
  String createdAt;
  String updatedAt;
  Home home;

  Facture(
      {this.id,
        this.homeId,
        this.statut,
        this.price,
        this.userId,
        this.time,
        this.description,
        this.smsSend,
        this.smsSendDate,
        this.createdAt,
        this.updatedAt,
        this.home});

  Facture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    homeId = json['home_id'];
    statut = json['statut'];
    price = json['price'];
    userId = json['user_id'];
    time = json['time'];
    description = json['description'];
    smsSend = json['sms_send'];
    smsSendDate = json['sms_send_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['home_id'] = this.homeId;
    data['statut'] = this.statut;
    data['price'] = this.price;
    data['user_id'] = this.userId;
    data['time'] = this.time;
    data['description'] = this.description;
    data['sms_send'] = this.smsSend;
    data['sms_send_date'] = this.smsSendDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.home != null) {
      data['home'] = this.home.toJson();
    }
    return data;
  }
}

class Home {
  int id;
  String streetId;
  String number;
  String landlord;
  String phone;
  String debt;
  String wallet;
  String createdAt;
  String updatedAt;

  Home(
      {this.id,
        this.streetId,
        this.number,
        this.landlord,
        this.phone,
        this.debt,
        this.wallet,
        this.createdAt,
        this.updatedAt});

  Home.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    streetId = json['street_id'];
    number = json['number'];
    landlord = json['landlord'];
    phone = json['phone'];
    debt = json['debt'];
    wallet = json['wallet'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['street_id'] = this.streetId;
    data['number'] = this.number;
    data['landlord'] = this.landlord;
    data['phone'] = this.phone;
    data['debt'] = this.debt;
    data['wallet'] = this.wallet;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}