import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/bloc/music_bloc.dart';
import 'package:torrentsearch/bloc/torrent_bloc.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/widgets/ExceptionWidget.dart';
import 'package:torrentsearch/widgets/LoadingWidget.dart';
import 'package:torrentsearch/widgets/Thumbnail.dart';

class Torrent extends StatefulWidget {
  @override
  _TorrentState createState() => _TorrentState();
}

class _TorrentState extends State<Torrent> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  final DatabaseHelper databaseHelper = DatabaseHelper();
  final Preferences pref = Preferences();

  TorrentBloc _torrentBloc;
  PreferenceProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _torrentBloc,
          child: BlocBuilder<TorrentBloc, TorrentState>(
            builder: (BuildContext context, TorrentState state) {
              if (state is TorrentHomeRecentLoaded) {
                return _buildBody(context, data: state.data, loading: false);
              } else if (state is TorrentError) {
                return ExceptionWidget(state.exception);
              } else {
                return _buildBody(context);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _torrentBloc = TorrentBloc();
    _provider = Provider.of<PreferenceProvider>(context);
    _torrentBloc.add(TorrentHomeRecent(_provider.baseUrl));
  }

  ListView _buildBody(BuildContext context,
      {RecentResponse data, bool loading = true}) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _buildSearch(context),
        _buildHeader(
          "Movies",
          () {
            Navigator.pushNamed(context, "/allrecents", arguments: true);
          },
        ),
        loading
            ? _buildRecent(context, null)
            : data.movies.length > 0
                ? _buildRecent(context, data.movies, loading: false)
                : ExceptionWidget(NoContentFoundException()),
        _buildHeader(
          "TV Shows",
          () {
            Navigator.pushNamed(context, "/allrecents", arguments: false);
          },
        ),
        loading
            ? _buildRecent(context, null)
            : data.shows.length > 0
                ? _buildRecent(context, data.shows, loading: false)
                : ExceptionWidget(NoContentFoundException()),
        SizedBox(height: 70.0),
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accentColor = theme.accentColor;
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    );
    final Color fillColor = theme.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: "Search Torrent Here",
              prefixIcon: Icon(
                Icons.search,
                color: accentColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _textEditingController.clear();
                },
                color: accentColor,
              ),
              contentPadding: EdgeInsets.all(10.0),
              border: inputBorder,
              focusedBorder: inputBorder,
            ),
            cursorColor: accentColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (term) {
              if (_textEditingController.text != "") {
                databaseHelper.insert(
                    history: History(_textEditingController.text));
                Navigator.pushNamed(context, "/result",
                    arguments: _textEditingController.text);
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              label: Text(
                "SEARCH",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.public,
                color: Colors.white,
              ),
              onPressed: () {
                if (_textEditingController.text != "") {
                  databaseHelper.insert(
                      history: History(_textEditingController.text));
                  Navigator.pushNamed(context, "/result",
                      arguments: _textEditingController.text);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: Text(
                "SETTINGS",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, "/settings");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRecent(BuildContext context, List<RecentInfo> list,
      {bool loading = true}) {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);
    final String baseUrl = preferenceProvider.baseUrl;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double height = mediaQueryData.size.height;

    return Container(
        height: height * 0.35,
        child: loading
            ? LoadingWidget()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Thumbnail(list[index], width: width * 0.40);
                },
              ));
  }

  Widget _buildHeader(String header, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 16),
            textAlign: TextAlign.left,
          ),
          Spacer(),
          InkWell(
            child: Text(
              "View all",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                letterSpacing: 1.0,
              ),
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
