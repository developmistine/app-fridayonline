import 'dart:convert';

MarketMainPageModel marketMainPageModelFromJson(String str) => MarketMainPageModel.fromJson(json.decode(str));

String marketMainPageModelToJson(MarketMainPageModel data) => json.encode(data.toJson());

class MarketMainPageModel {
    MarketMainPageModel({
        this.token,
        this.device,
        this.customerId,
        this.userType,
        this.tagId,
        this.tagCode,
        required this.content,
    });

    dynamic token;
    dynamic device;
    dynamic customerId;
    dynamic userType;
    dynamic tagId;
    dynamic tagCode;
    List<Content> content;

    factory MarketMainPageModel.fromJson(Map<String, dynamic> json) => MarketMainPageModel(
        token: json["Token"],
        device: json["Device"],
        customerId: json["CustomerID"],
        userType: json["UserType"],
        tagId: json["TagID"],
        tagCode: json["TagCode"],
        content: json["Content"] == null ? [] : List<Content>.from(json["Content"].map((x) => Content.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Token": token,
        "Device": device,
        "CustomerID": customerId,
        "UserType": userType,
        "TagID": tagId,
        "TagCode": tagCode,
        "Content": List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class Content {
    Content({
        required this.categorySuggest,
        required this.banner,
        required this.favoriteData,
        required this.couponData,
        required this.flashSale,
        required this.productRecommend,
        required this.bestSeller,
    });

    List<CategorySuggest> categorySuggest;
    List<Banner> banner;
    List<dynamic> favoriteData;
    List<dynamic> couponData;
    List<dynamic> flashSale;
    List<ProductRecommend> productRecommend;
    List<dynamic> bestSeller;

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        categorySuggest: json["CategorySuggest"] == null ? [] : List<CategorySuggest>.from(json["CategorySuggest"].map((x) => CategorySuggest.fromJson(x))),
        banner: json["Banner"] == null ? [] : List<Banner>.from(json["Banner"].map((x) => Banner.fromJson(x))),
        favoriteData: json["FavoriteData"] == null ? [] : List<dynamic>.from(json["FavoriteData"].map((x) => x)),
        couponData: json["CouponData"] == null ? [] : List<dynamic>.from(json["CouponData"].map((x) => x)),
        flashSale: json["FlashSale"] == null ? [] : List<dynamic>.from(json["FlashSale"].map((x) => x)),
        productRecommend: json["ProductRecommend"] == null ? [] : List<ProductRecommend>.from(json["ProductRecommend"].map((x) => ProductRecommend.fromJson(x))),
        bestSeller: json["BestSeller"] == null ? [] : List<dynamic>.from(json["BestSeller"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "CategorySuggest": List<dynamic>.from(categorySuggest.map((x) => x.toJson())),
        "Banner": List<dynamic>.from(banner.map((x) => x.toJson())),
        "FavoriteData": List<dynamic>.from(favoriteData.map((x) => x)),
        "CouponData": List<dynamic>.from(couponData.map((x) => x)),
        "FlashSale": List<dynamic>.from(flashSale.map((x) => x)),
        "ProductRecommend": List<dynamic>.from(productRecommend.map((x) => x.toJson())),
        "BestSeller": List<dynamic>.from(bestSeller.map((x) => x)),
    };
}

class Banner {
    Banner({
        required this.bannerIndex,
        required this.bannerId,
        required this.bannerValues,
        required this.bannerName,
        required this.bannerImg,
        required this.bannerType,
        required this.bannerActionType,
    });

    String bannerIndex;
    String bannerId;
    String bannerValues;
    String bannerName;
    String bannerImg;
    String bannerType;
    String bannerActionType;

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        bannerIndex: json["BannerIndex"] ?? "",
        bannerId: json["BannerID"] ?? "",
        bannerValues: json["BannerValues"] ?? "",
        bannerName: json["BannerName"] ?? "",
        bannerImg: json["BannerImg"] ?? "",
        bannerType: json["BannerType"] ?? "",
        bannerActionType: json["BannerActionType"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "BannerIndex": bannerIndex,
        "BannerID": bannerId,
        "BannerValues": bannerValues,
        "BannerName": bannerName,
        "BannerImg": bannerImg,
        "BannerType": bannerType,
        "BannerActionType": bannerActionType,
    };
}

class CategorySuggest {
    CategorySuggest({
        required this.categoryLevel,
        required this.categoryIndex,
        required this.categoryId,
        required this.categoryName,
        this.categoryImg,
        required this.contentValue,
        required this.contentValueType,
    });

    String categoryLevel;
    String categoryIndex;
    String categoryId;
    String categoryName;
    dynamic categoryImg;
    String contentValue;
    String contentValueType;

    factory CategorySuggest.fromJson(Map<String, dynamic> json) => CategorySuggest(
        categoryLevel: json["CategoryLevel"] ?? "",
        categoryIndex: json["CategoryIndex"] ?? "",
        categoryId: json["CategoryID"] ?? "",
        categoryName: json["CategoryName"] ?? "",
        categoryImg: json["CategoryImg"],
        contentValue: json["ContentValue"] ?? "",
        contentValueType: json["ContentValueType"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "CategoryLevel": categoryLevel,
        "CategoryIndex": categoryIndex,
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "CategoryImg": categoryImg,
        "ContentValue": contentValue,
        "ContentValueType": contentValueType,
    };
}

class ProductRecommend {
    ProductRecommend({
        required this.productRecommendIndex,
        required this.billCode,
        required this.billNameThai,
        required this.billNameEng,
        required this.reqularprice,
        required this.specialprice,
        this.scoreStar,
        this.scoreLike,
        required this.urlImg,
        required this.profitPerPcs,
        required this.isInStore,
    });

    String productRecommendIndex;
    String billCode;
    String billNameThai;
    String billNameEng;
    String reqularprice;
    String specialprice;
    dynamic scoreStar;
    dynamic scoreLike;
    String urlImg;
    String profitPerPcs;
    String isInStore;

    factory ProductRecommend.fromJson(Map<String, dynamic> json) => ProductRecommend(
        productRecommendIndex: json["ProductRecommendIndex"] ?? "",
        billCode: json["BillCode"] ?? "",
        billNameThai: json["BillNameThai"] ?? "",
        billNameEng: json["BillNameEng"] ?? "",
        reqularprice: json["Reqularprice"] ?? "",
        specialprice: json["Specialprice"] ?? "",
        scoreStar: json["ScoreStar"],
        scoreLike: json["ScoreLike"],
        urlImg: json["UrlImg"] ?? "",
        profitPerPcs: json["ProfitPerPcs"] ?? "",
        isInStore: json["IsInStore"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "ProductRecommendIndex": productRecommendIndex,
        "BillCode": billCode,
        "BillNameThai": billNameThai,
        "BillNameEng": billNameEng,
        "Reqularprice": reqularprice,
        "Specialprice": specialprice,
        "ScoreStar": scoreStar,
        "ScoreLike": scoreLike,
        "UrlImg": urlImg,
        "ProfitPerPcs": profitPerPcs,
        "IsInStore": isInStore,
    };
}
