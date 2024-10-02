import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
i0.MigrationStepWithVersion migrationSteps() {
  return (currentVersion, database) async {
    switch (currentVersion) {
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep() =>
    i0.VersionedSchema.stepByStepHelper(step: migrationSteps());
