import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

import "../database.dart";
import "../main.dart";

class HomeScreen extends StatelessWidget {
  final String searchWord;
  final List<DictionaryData> searchResult;

  const HomeScreen(
      {super.key, required this.searchWord, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    Widget body;

    final locale = AppLocalizations.of(context);

    if (currentDictionaryPath == null) {
      body = Center(child: Text(locale!.addDictionary));
    } else {
      if (searchWord == "") {
        body = Center(child: Text(locale!.startToSearch));
      } else {
        body = Center(child: SearchResult(searchResult: searchResult));
      }
    }

    return body;
  }
}

class SearchResult extends StatelessWidget {
  final List<DictionaryData> searchResult;

  const SearchResult({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    final resultWidgets = <Widget>[];

    for (var word in searchResult) {
      resultWidgets.add(ListTile(
          title: Text(word.key),
          trailing: IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () async {
              await flutterTts.speak(word.key);
            },
          ),
          onTap: () async {
            String content = await dictReader!.readOne(word.blockOffset,
                word.startOffset, word.endOffset, word.compressedSize);

            if (content.startsWith("@@@LINK=")) {
              // 8: remove @@@LINK=
              // content.length - 3: remove \r\n\x00
              word = await dictionary!.getOffset(
                  content.substring(8, content.length - 3).trimRight());
              content = await dictReader!.readOne(word.blockOffset,
                  word.startOffset, word.endOffset, word.compressedSize);
            }

            if (context.mounted) {
              context
                  .push("/word", extra: {"content": content, "word": word.key});
            }
          }));
    }

    return ListView(
      children: resultWidgets,
    );
  }
}
