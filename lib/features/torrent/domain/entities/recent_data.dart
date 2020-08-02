//import 'package:equatable/equatable.dart';
//import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';
//
//class RecentDataWithImdb extends Equatable {
//  final List<Torrent> list;
//  final Imdb imdbInfo;
//
//  const RecentDataWithImdb(this.list, this.imdbInfo);
//
//  @override
//  List<Object> get props => [list, imdbInfo];
//}
//
//class Imdb {
//  const Imdb({
//    this.title,
//    this.year,
//    this.rated,
//    this.released,
//    this.runtime,
//    this.genre,
//    this.director,
//    this.writer,
//    this.actors,
//    this.plot,
//    this.language,
//    this.country,
//    this.awards,
//    this.poster,
//    this.ratings,
//    this.metascore,
//    this.imdbRating,
//    this.imdbVotes,
//    this.imdbId,
//    this.type,
//    this.dvd,
//    this.boxOffice,
//    this.production,
//    this.website,
//    this.response,
//  });
//
//  final String title;
//  final String year;
//  final String rated;
//  final String released;
//  final String runtime;
//  final String genre;
//  final String director;
//  final String writer;
//  final String actors;
//  final String plot;
//  final String language;
//  final String country;
//  final String awards;
//  final String poster;
//  final List<dynamic> ratings;
//  final String metascore;
//  final String imdbRating;
//  final String imdbVotes;
//  final String imdbId;
//  final String type;
//  final String dvd;
//  final String boxOffice;
//  final String production;
//  final String website;
//  final String response;
//
//  factory Imdb.fromJson(Map<String, dynamic> json) => Imdb(
//        title: json["Title"] as String,
//        year: json["Year"] as String,
//        rated: json["Rated"] as String,
//        released: json["Released"] as String,
//        runtime: json["Runtime"] as String,
//        genre: json["Genre"] as String,
//        director: json["Director"] as String,
//        writer: json["Writer"] as String,
//        actors: json["Actors"] as String,
//        plot: json["Plot"] as String,
//        language: json["Language"] as String,
//        country: json["Country"] as String,
//        awards: json["Awards"] as String,
//        poster: json["Poster"] as String,
//        ratings: List<dynamic>.from(
//            (json["Ratings"] as List<dynamic>).map((x) => x)),
//        metascore: json["Metascore"] as String,
//        imdbRating: json["imdbRating"] as String,
//        imdbVotes: json["imdbVotes"] as String,
//        imdbId: json["imdbID"] as String,
//        type: json["Type"] as String,
//        dvd: json["DVD"] as String,
//        boxOffice: json["BoxOffice"] as String,
//        production: json["Production"] as String,
//        website: json["Website"] as String,
//        response: json["Response"] as String,
//      );
//
//  Map<String, dynamic> toJson() => {
//        "Title": title,
//        "Year": year,
//        "Rated": rated,
//        "Released": released,
//        "Runtime": runtime,
//        "Genre": genre,
//        "Director": director,
//        "Writer": writer,
//        "Actors": actors,
//        "Plot": plot,
//        "Language": language,
//        "Country": country,
//        "Awards": awards,
//        "Poster": poster,
//        "Ratings": List<dynamic>.from(ratings.map((x) => x)),
//        "Metascore": metascore,
//        "imdbRating": imdbRating,
//        "imdbVotes": imdbVotes,
//        "imdbID": imdbId,
//        "Type": type,
//        "DVD": dvd,
//        "BoxOffice": boxOffice,
//        "Production": production,
//        "Website": website,
//        "Response": response,
//      };
//}
