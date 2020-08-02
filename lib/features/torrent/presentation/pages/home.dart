import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/routes/routes.gr.dart';
import 'package:torrentsearch/features/torrent/data/database/database_helper.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchEditingController =
      TextEditingController(text: "");
//  TorrentBloc torrentBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    if (torrentBloc == null) {
//      torrentBloc = sl<TorrentBloc>();
//      torrentBloc.add(const GetRecentEvent());
//    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final Color accentColor = themeData.accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Torrent Search",
          style: textTheme.headline5.copyWith(
            color: themeData.accentColor,
//                  fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => ExtendedNavigator.of(context).push("/settings"),
            color: accentColor,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => ExtendedNavigator.of(context).push("/history"),
            color: accentColor,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => ExtendedNavigator.of(context).push("/favourite"),
            color: accentColor,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                _buildSearch(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: RaisedButton.icon(
                    label: Text(
                      "SEARCH",
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                    ),
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      if (_searchEditingController.text != "") {
                        ExtendedNavigator.of(context).push(
                          "/result",
                          arguments: TorrentResultArguments(
                            query: _searchEditingController.text,
                          ),
                        );
                      }
                    },
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    final theme = Theme.of(context);
    final accentColor = theme.accentColor;
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    );
    final fillColor = theme.brightness == Brightness.dark
        ? const Color(0xff424242)
        : Colors.black12;
    final decoration = InputDecoration(
      filled: true,
      fillColor: fillColor,
      hintText: "Search Torrent Here",
      prefixIcon: Icon(
        Icons.search,
        color: accentColor,
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _searchEditingController.clear();
        },
        color: accentColor,
      ),
      contentPadding: const EdgeInsets.all(10.0),
      border: inputBorder,
      focusedBorder: inputBorder,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _searchEditingController,
        decoration: decoration,
        cursorColor: accentColor,
        keyboardType: TextInputType.text,
        maxLines: 1,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.search,
        onSubmitted: (term) {
          if (_searchEditingController.text != "") {
            DatabaseHelper()
                .insert(history: History(_searchEditingController.text));
            ExtendedNavigator.of(context).push("/result",
                arguments: TorrentResultArguments(
                    query: _searchEditingController.text));
          }
        },
      ),
    );
  }

//  Widget _buildHeader(String title, Function() onTap) {
//    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
//          fontWeight: FontWeight.bold,
//          fontSize: 18.0,
//        );
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 10.0),
//      child: Row(
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
//          Text(title, style: textStyle),
//          const Spacer(),
//          GestureDetector(
//            onTap: onTap,
//            child: Text(
//              "View All",
//              style: textStyle,
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  @override
  void dispose() {
    _searchEditingController.dispose();
//    torrentBloc.dispose();
    super.dispose();
  }
}
