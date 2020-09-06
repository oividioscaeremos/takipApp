import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryBuilder {
  final String API_ROOT = "https://api.trakt.tv/";
  final String EX_SHOW = "shows/";
  final String EX_SEASONS = "seasons/";
  final String EX_EPISODES = "episodes/";
  final String SEARCH = "search/";
  final String FIELDS_INIT = "&fields=";
  final String QUERY_INIT = "?query=";
  final String PAGE = "&page=";
  final String LIMIT = "&limit=";
  final String SHOW = "show/";
  final Map<String, String> defaultHeaders = {
    "trakt-api-key": "",
    "content-type": "application/json",
    "trakt-api-version": "2"
  };

  String show;
  String season;
  String episode;
  bool isExtended;
  String api_call;

  QueryBuilder({this.show, this.season, this.episode, this.isExtended}) {
    api_call = API_ROOT;
    if (this.show != null) {
      api_call += EX_SHOW + this.show + "/";
    }
    if (this.season != null) {
      if (this.season == "") {
        api_call += EX_SEASONS + "/";
      } else {
        api_call += EX_SEASONS + this.season + "/";
      }
    }
    if (this.episode != null) {
      if (this.episode == "") {
        api_call += EX_EPISODES + "/";
      } else {
        api_call += EX_EPISODES + this.episode + "/";
      }
    }
    if (this.isExtended) {
      api_call += "?extended=full";
    }
  }

  QueryBuilder.search({String show, int page, int limit, List<String> fields}) {
    api_call = API_ROOT.toString() + SEARCH + SHOW + QUERY_INIT + show;
    if (page != null) {
      api_call += PAGE + page.toString();
    }
    if (limit != null) {
      api_call += LIMIT + limit.toString();
    }
    if (fields.length != 0) {
      api_call += FIELDS_INIT;
      fields.forEach((fieldReq) {
        api_call += fieldReq;
      });
    }
  }

  Future<String> getResponse() async {
    print("Query is = ${api_call}");
    final response = await http.get(api_call, headers: defaultHeaders);
    return response.body;
  }
}
