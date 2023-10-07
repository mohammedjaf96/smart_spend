import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartspend/model_pages/categoryModel.dart';
import 'package:smartspend/model_pages/movementsModel.dart';
import 'package:sqflite/sqflite.dart';

import '../model_pages/initNotifications.dart';

class mainController extends GetxController {

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    getDateFormat();
    getCategoryFromSql();
  }


  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
  }




  static Database? _db;
  Future<Database?> get db async {
    if(_db == null){
      _db = await initDb();
      return _db;
    }else{
      return _db;
    }
  }


  /// this function to create database
  initDb()async{
    String dbPath = await getDatabasesPath();
    String path = join(dbPath,'smartspend.db');
    Database myDb = await openDatabase(
        path, // this path for database in device
        onCreate: onCreate, // this for query to create tables
        version: 1, // this version i need it in future, i well change it when i update the table columns
        onUpgrade: onUpgrade // this working when i change the version
    );
    return myDb;
  }


  /// -------------------------------

  /// this function to create tables
  onCreate(Database db, int version){
    db.execute('''
    create table "category" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "name" TEXT , 
    "image" TEXT , 
    "type" TEXT , 
    "lastpost" TEXT , 
    "maxbudget" REAL DEFAULT 0.0 , 
    "currentbudget" REAL DEFAULT 0.0 , 
    "create" TEXT 
    )
    ''');
    db.execute('''
    create table "movements" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "catagoryid" INTEGER DEFAULT 0 , 
    "amount" REAL DEFAULT 0.0 , 
    "note" TEXT , 
    "type" TEXT , 
    "create" TEXT 
    )
    ''');
    print('create done');
  }
  /// this function to update tables
  onUpgrade(Database db, int oldVersion, int newVersion){
    db.execute('''
    create table "category" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "name" TEXT , 
    "type" TEXT , 
    "image" TEXT , 
    "maxbudget" REAL DEFAULT 0.0 , 
    "currentbudget" REAL DEFAULT 0.0 , 
    "create" TEXT 
    )
    ''');
    db.execute('''
    create table "movements" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "catagoryid" INTEGER DEFAULT 0 , 
    "amount" REAL DEFAULT 0.0 , 
    "create" TEXT 
    )
    ''');
    print('update done');
  }

  /// -------------------------------



  /// for read category and movements from mysqlLite
  RxList categoriesList = [].obs;
  getCategoryFromSql()async{
    Database? myDb = await db;
    List<Map<String,dynamic>> maps = await myDb!.query("category");
    categoriesList.value = List.generate(maps.length, (i) {
      return categoryModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        image: maps[i]['image'],
        create: maps[i]['create'],
        maxbudget: maps[i]['maxbudget'],
        lastpost: maps[i]['lastpost'],
        currentbudget: maps[i]['currentbudget'],
        type: maps[i]['type'] ?? '',
      );
    }).reversed.toList();
  }




  /// post and patch and delete from Category and movements
  postCategories(sql)async{
    Database? myDb = await db;
    int response = await myDb!.insert("category", sql);
    await getCategoryFromSql();
    return response;
  }


  /// this function to delete category from mysql lite
  deleteCategory(String wher,id)async{
    Database? myDb = await db;
    await myDb!.delete("category",where: 'id = ?',whereArgs: [id]);
    await getCategoryFromSql();
    Get.back();
  }

  /// post and delete and get and patch the movements
  postMovement(sql,categoryModel category)async{
    /// in here i check if current budget of category is == or > max budget
    if(category.type == 'income'){
      Database? myDb = await db;
      int response = await myDb!.insert("movements", sql);
      /// in here i patch the current budget of category
      if(response != 0){
        categoryModel newCategory = categoryModel(id: category.id,name: category.name, image: category.image, create: category.create, maxbudget: category.maxbudget, type: category.type, currentbudget: (category.currentbudget + sql['amount']) ,lastpost: DateTime.now().toString());
        int res = await myDb.update("category",newCategory.toMap(),where: "id = ?",whereArgs: [category.id]);
        await getCategoryFromSql();
        await getMovment();
        return res;
      }else{
        return response;
      }
    }else{
      if(category.currentbudget == category.maxbudget || category.currentbudget > category.maxbudget){
        Get.snackbar('تنبيه', 'لقد وصلت الى الحد الاقصى للقسم سيتم الاضافه و حسابها من ضمن الصرفيات الاضافيه',
            titleText: Text('تنبيه',textAlign: TextAlign.right,
              style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),messageText:
            Text('لقد وصلت الى الحد الاقصى للقسم سيتم الاضافه و حسابها من ضمن الصرفيات الاضافيه',textAlign: TextAlign.right,
              style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),));
      }else{}
      Database? myDb = await db;
      int response = await myDb!.insert("movements", sql);
      /// in here i patch the current budget of category
      if(response != 0){
        categoryModel newCategory = categoryModel(id: category.id,name: category.name, image: category.image, create: category.create, maxbudget: category.maxbudget, type: category.type, currentbudget: (category.currentbudget + sql['amount']) ,lastpost: DateTime.now().toString());
        int res = await myDb.update("category",newCategory.toMap(),where: "id = ?",whereArgs: [category.id]);
        await getCategoryFromSql();
        await getMovment();
        return res;
      }else{
        return response;
      }
    }


  }

  List<movementsModel> movmentsList = [];
  getMovment()async{
    Database? myDb = await db;
    List<Map<String,dynamic>> maps = await myDb!.query("movements");
    movmentsList = List.generate(maps.length, (i) {
      return movementsModel(
          id: maps[i]['id'],
          catagoryid: maps[i]['catagoryid'],
          amount: maps[i]['amount'],
          create: maps[i]['create'],
          note: maps[i]['note'],
        type: maps[i]['type']
      );
    }).reversed.toList();
    update();
  }



  showSnakBar(title,des){
    Get.snackbar(title, des,
        titleText: Text(title,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),messageText:
        Text(des,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),));
  }









  /// set DateFormat in SharedPreferences
  List<String> formatList = ['yyyy-mm-dd','dd-mm-yyyy','yyyy-mm','mm-dd','dd-mm'];
  RxString dateFormat = 'yyyy-mm-dd'.obs;
  saveDateFormat(format) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    dateFormat.value = format;
    perf.setString('dateFormat', format);
  }
  getDateFormat() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    if(perf.getString('dateFormat') != null){
      dateFormat.value = perf.getString('dateFormat')!;
    }
  }
  selectDateFormat(Widget widget){
    Get.bottomSheet(
      widget,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      elevation: 5,
    );
  }
}