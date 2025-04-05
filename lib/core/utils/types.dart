import 'package:authorio/core/utils/pair.dart';
import 'package:authorio/core/utils/result.dart';
import 'package:authorio/domain/entities/author_entity.dart';

typedef AuthorPageResult = Result<Pair<String?, List<AuthorEntity>>>;
