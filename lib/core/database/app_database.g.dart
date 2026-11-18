// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, HouseholdRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('TZS'));
  static const VerificationMeta _currencySymbolMeta =
      const VerificationMeta('currencySymbol');
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
      'currency_symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('TSh'));
  static const VerificationMeta _timezoneMeta =
      const VerificationMeta('timezone');
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Africa/Dar_es_Salaam'));
  static const VerificationMeta _allowOverdraftMeta =
      const VerificationMeta('allowOverdraft');
  @override
  late final GeneratedColumn<bool> allowOverdraft = GeneratedColumn<bool>(
      'allow_overdraft', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_overdraft" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lowBalanceThresholdCentsMeta =
      const VerificationMeta('lowBalanceThresholdCents');
  @override
  late final GeneratedColumn<int> lowBalanceThresholdCents =
      GeneratedColumn<int>('low_balance_threshold_cents', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(2500000));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        name,
        description,
        address,
        currencyCode,
        currencySymbol,
        timezone,
        allowOverdraft,
        lowBalanceThresholdCents,
        isArchived,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
          _currencySymbolMeta,
          currencySymbol.isAcceptableOrUnknown(
              data['currency_symbol']!, _currencySymbolMeta));
    }
    if (data.containsKey('timezone')) {
      context.handle(_timezoneMeta,
          timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta));
    }
    if (data.containsKey('allow_overdraft')) {
      context.handle(
          _allowOverdraftMeta,
          allowOverdraft.isAcceptableOrUnknown(
              data['allow_overdraft']!, _allowOverdraftMeta));
    }
    if (data.containsKey('low_balance_threshold_cents')) {
      context.handle(
          _lowBalanceThresholdCentsMeta,
          lowBalanceThresholdCents.isAcceptableOrUnknown(
              data['low_balance_threshold_cents']!,
              _lowBalanceThresholdCentsMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      currencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}currency_symbol'])!,
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone'])!,
      allowOverdraft: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allow_overdraft'])!,
      lowBalanceThresholdCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}low_balance_threshold_cents'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class HouseholdRow extends DataClass implements Insertable<HouseholdRow> {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final String? address;
  final String currencyCode;
  final String currencySymbol;
  final String timezone;
  final bool allowOverdraft;
  final int lowBalanceThresholdCents;
  final bool isArchived;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const HouseholdRow(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.description,
      this.address,
      required this.currencyCode,
      required this.currencySymbol,
      required this.timezone,
      required this.allowOverdraft,
      required this.lowBalanceThresholdCents,
      required this.isArchived,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['timezone'] = Variable<String>(timezone);
    map['allow_overdraft'] = Variable<bool>(allowOverdraft);
    map['low_balance_threshold_cents'] =
        Variable<int>(lowBalanceThresholdCents);
    map['is_archived'] = Variable<bool>(isArchived);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      currencyCode: Value(currencyCode),
      currencySymbol: Value(currencySymbol),
      timezone: Value(timezone),
      allowOverdraft: Value(allowOverdraft),
      lowBalanceThresholdCents: Value(lowBalanceThresholdCents),
      isArchived: Value(isArchived),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory HouseholdRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      address: serializer.fromJson<String?>(json['address']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      timezone: serializer.fromJson<String>(json['timezone']),
      allowOverdraft: serializer.fromJson<bool>(json['allowOverdraft']),
      lowBalanceThresholdCents:
          serializer.fromJson<int>(json['lowBalanceThresholdCents']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'address': serializer.toJson<String?>(address),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'timezone': serializer.toJson<String>(timezone),
      'allowOverdraft': serializer.toJson<bool>(allowOverdraft),
      'lowBalanceThresholdCents':
          serializer.toJson<int>(lowBalanceThresholdCents),
      'isArchived': serializer.toJson<bool>(isArchived),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  HouseholdRow copyWith(
          {String? id,
          String? ownerId,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> address = const Value.absent(),
          String? currencyCode,
          String? currencySymbol,
          String? timezone,
          bool? allowOverdraft,
          int? lowBalanceThresholdCents,
          bool? isArchived,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      HouseholdRow(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        address: address.present ? address.value : this.address,
        currencyCode: currencyCode ?? this.currencyCode,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        timezone: timezone ?? this.timezone,
        allowOverdraft: allowOverdraft ?? this.allowOverdraft,
        lowBalanceThresholdCents:
            lowBalanceThresholdCents ?? this.lowBalanceThresholdCents,
        isArchived: isArchived ?? this.isArchived,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  HouseholdRow copyWithCompanion(HouseholdsCompanion data) {
    return HouseholdRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      address: data.address.present ? data.address.value : this.address,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      allowOverdraft: data.allowOverdraft.present
          ? data.allowOverdraft.value
          : this.allowOverdraft,
      lowBalanceThresholdCents: data.lowBalanceThresholdCents.present
          ? data.lowBalanceThresholdCents.value
          : this.lowBalanceThresholdCents,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('timezone: $timezone, ')
          ..write('allowOverdraft: $allowOverdraft, ')
          ..write('lowBalanceThresholdCents: $lowBalanceThresholdCents, ')
          ..write('isArchived: $isArchived, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerId,
      name,
      description,
      address,
      currencyCode,
      currencySymbol,
      timezone,
      allowOverdraft,
      lowBalanceThresholdCents,
      isArchived,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.description == this.description &&
          other.address == this.address &&
          other.currencyCode == this.currencyCode &&
          other.currencySymbol == this.currencySymbol &&
          other.timezone == this.timezone &&
          other.allowOverdraft == this.allowOverdraft &&
          other.lowBalanceThresholdCents == this.lowBalanceThresholdCents &&
          other.isArchived == this.isArchived &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdsCompanion extends UpdateCompanion<HouseholdRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> address;
  final Value<String> currencyCode;
  final Value<String> currencySymbol;
  final Value<String> timezone;
  final Value<bool> allowOverdraft;
  final Value<int> lowBalanceThresholdCents;
  final Value<bool> isArchived;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.timezone = const Value.absent(),
    this.allowOverdraft = const Value.absent(),
    this.lowBalanceThresholdCents = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.timezone = const Value.absent(),
    this.allowOverdraft = const Value.absent(),
    this.lowBalanceThresholdCents = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<HouseholdRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? address,
    Expression<String>? currencyCode,
    Expression<String>? currencySymbol,
    Expression<String>? timezone,
    Expression<bool>? allowOverdraft,
    Expression<int>? lowBalanceThresholdCents,
    Expression<bool>? isArchived,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (timezone != null) 'timezone': timezone,
      if (allowOverdraft != null) 'allow_overdraft': allowOverdraft,
      if (lowBalanceThresholdCents != null)
        'low_balance_threshold_cents': lowBalanceThresholdCents,
      if (isArchived != null) 'is_archived': isArchived,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? address,
      Value<String>? currencyCode,
      Value<String>? currencySymbol,
      Value<String>? timezone,
      Value<bool>? allowOverdraft,
      Value<int>? lowBalanceThresholdCents,
      Value<bool>? isArchived,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      timezone: timezone ?? this.timezone,
      allowOverdraft: allowOverdraft ?? this.allowOverdraft,
      lowBalanceThresholdCents:
          lowBalanceThresholdCents ?? this.lowBalanceThresholdCents,
      isArchived: isArchived ?? this.isArchived,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (allowOverdraft.present) {
      map['allow_overdraft'] = Variable<bool>(allowOverdraft.value);
    }
    if (lowBalanceThresholdCents.present) {
      map['low_balance_threshold_cents'] =
          Variable<int>(lowBalanceThresholdCents.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('timezone: $timezone, ')
          ..write('allowOverdraft: $allowOverdraft, ')
          ..write('lowBalanceThresholdCents: $lowBalanceThresholdCents, ')
          ..write('isArchived: $isArchived, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdMembersTable extends HouseholdMembers
    with TableInfo<$HouseholdMembersTable, HouseholdMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _linkedUserIdMeta =
      const VerificationMeta('linkedUserId');
  @override
  late final GeneratedColumn<String> linkedUserId = GeneratedColumn<String>(
      'linked_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('member'));
  static const VerificationMeta _avatarColorMeta =
      const VerificationMeta('avatarColor');
  @override
  late final GeneratedColumn<String> avatarColor = GeneratedColumn<String>(
      'avatar_color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#167D52'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        linkedUserId,
        displayName,
        email,
        phoneNumber,
        role,
        avatarColor,
        isActive,
        version,
        joinedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_members';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdMemberRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('linked_user_id')) {
      context.handle(
          _linkedUserIdMeta,
          linkedUserId.isAcceptableOrUnknown(
              data['linked_user_id']!, _linkedUserIdMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('avatar_color')) {
      context.handle(
          _avatarColorMeta,
          avatarColor.isAcceptableOrUnknown(
              data['avatar_color']!, _avatarColorMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdMemberRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      linkedUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linked_user_id']),
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      avatarColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_color'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HouseholdMembersTable createAlias(String alias) {
    return $HouseholdMembersTable(attachedDatabase, alias);
  }
}

class HouseholdMemberRow extends DataClass
    implements Insertable<HouseholdMemberRow> {
  final String id;
  final String householdId;
  final String? linkedUserId;
  final String displayName;
  final String? email;
  final String? phoneNumber;
  final String role;
  final String avatarColor;
  final bool isActive;
  final int version;
  final DateTime joinedAt;
  final DateTime? updatedAt;
  const HouseholdMemberRow(
      {required this.id,
      required this.householdId,
      this.linkedUserId,
      required this.displayName,
      this.email,
      this.phoneNumber,
      required this.role,
      required this.avatarColor,
      required this.isActive,
      required this.version,
      required this.joinedAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || linkedUserId != null) {
      map['linked_user_id'] = Variable<String>(linkedUserId);
    }
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['role'] = Variable<String>(role);
    map['avatar_color'] = Variable<String>(avatarColor);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HouseholdMembersCompanion toCompanion(bool nullToAbsent) {
    return HouseholdMembersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      linkedUserId: linkedUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedUserId),
      displayName: Value(displayName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      role: Value(role),
      avatarColor: Value(avatarColor),
      isActive: Value(isActive),
      version: Value(version),
      joinedAt: Value(joinedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory HouseholdMemberRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdMemberRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      linkedUserId: serializer.fromJson<String?>(json['linkedUserId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      email: serializer.fromJson<String?>(json['email']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      role: serializer.fromJson<String>(json['role']),
      avatarColor: serializer.fromJson<String>(json['avatarColor']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'linkedUserId': serializer.toJson<String?>(linkedUserId),
      'displayName': serializer.toJson<String>(displayName),
      'email': serializer.toJson<String?>(email),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'role': serializer.toJson<String>(role),
      'avatarColor': serializer.toJson<String>(avatarColor),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  HouseholdMemberRow copyWith(
          {String? id,
          String? householdId,
          Value<String?> linkedUserId = const Value.absent(),
          String? displayName,
          Value<String?> email = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          String? role,
          String? avatarColor,
          bool? isActive,
          int? version,
          DateTime? joinedAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      HouseholdMemberRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        linkedUserId:
            linkedUserId.present ? linkedUserId.value : this.linkedUserId,
        displayName: displayName ?? this.displayName,
        email: email.present ? email.value : this.email,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        role: role ?? this.role,
        avatarColor: avatarColor ?? this.avatarColor,
        isActive: isActive ?? this.isActive,
        version: version ?? this.version,
        joinedAt: joinedAt ?? this.joinedAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  HouseholdMemberRow copyWithCompanion(HouseholdMembersCompanion data) {
    return HouseholdMemberRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      linkedUserId: data.linkedUserId.present
          ? data.linkedUserId.value
          : this.linkedUserId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      role: data.role.present ? data.role.value : this.role,
      avatarColor:
          data.avatarColor.present ? data.avatarColor.value : this.avatarColor,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMemberRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('linkedUserId: $linkedUserId, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('role: $role, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      linkedUserId,
      displayName,
      email,
      phoneNumber,
      role,
      avatarColor,
      isActive,
      version,
      joinedAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdMemberRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.linkedUserId == this.linkedUserId &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.phoneNumber == this.phoneNumber &&
          other.role == this.role &&
          other.avatarColor == this.avatarColor &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.joinedAt == this.joinedAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdMembersCompanion extends UpdateCompanion<HouseholdMemberRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String?> linkedUserId;
  final Value<String> displayName;
  final Value<String?> email;
  final Value<String?> phoneNumber;
  final Value<String> role;
  final Value<String> avatarColor;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<DateTime> joinedAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HouseholdMembersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.linkedUserId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdMembersCompanion.insert({
    required String id,
    required String householdId,
    this.linkedUserId = const Value.absent(),
    required String displayName,
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime joinedAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        displayName = Value(displayName),
        joinedAt = Value(joinedAt);
  static Insertable<HouseholdMemberRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? linkedUserId,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? phoneNumber,
    Expression<String>? role,
    Expression<String>? avatarColor,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<DateTime>? joinedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (linkedUserId != null) 'linked_user_id': linkedUserId,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (role != null) 'role': role,
      if (avatarColor != null) 'avatar_color': avatarColor,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String?>? linkedUserId,
      Value<String>? displayName,
      Value<String?>? email,
      Value<String?>? phoneNumber,
      Value<String>? role,
      Value<String>? avatarColor,
      Value<bool>? isActive,
      Value<int>? version,
      Value<DateTime>? joinedAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdMembersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      linkedUserId: linkedUserId ?? this.linkedUserId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      avatarColor: avatarColor ?? this.avatarColor,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (linkedUserId.present) {
      map['linked_user_id'] = Variable<String>(linkedUserId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (avatarColor.present) {
      map['avatar_color'] = Variable<String>(avatarColor.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMembersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('linkedUserId: $linkedUserId, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('role: $role, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('category'));
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#167D52'));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _tracksConsumptionMeta =
      const VerificationMeta('tracksConsumption');
  @override
  late final GeneratedColumn<bool> tracksConsumption = GeneratedColumn<bool>(
      'tracks_consumption', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tracks_consumption" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _supplyTypeMeta =
      const VerificationMeta('supplyType');
  @override
  late final GeneratedColumn<String> supplyType = GeneratedColumn<String>(
      'supply_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        name,
        slug,
        iconName,
        colorHex,
        isDefault,
        isActive,
        tracksConsumption,
        supplyType,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('tracks_consumption')) {
      context.handle(
          _tracksConsumptionMeta,
          tracksConsumption.isAcceptableOrUnknown(
              data['tracks_consumption']!, _tracksConsumptionMeta));
    }
    if (data.containsKey('supply_type')) {
      context.handle(
          _supplyTypeMeta,
          supplyType.isAcceptableOrUnknown(
              data['supply_type']!, _supplyTypeMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      tracksConsumption: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}tracks_consumption'])!,
      supplyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_type'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategoryRow extends DataClass
    implements Insertable<ExpenseCategoryRow> {
  final String id;
  final String householdId;
  final String name;
  final String slug;
  final String iconName;
  final String colorHex;
  final bool isDefault;
  final bool isActive;
  final bool tracksConsumption;
  final String supplyType;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ExpenseCategoryRow(
      {required this.id,
      required this.householdId,
      required this.name,
      required this.slug,
      required this.iconName,
      required this.colorHex,
      required this.isDefault,
      required this.isActive,
      required this.tracksConsumption,
      required this.supplyType,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_active'] = Variable<bool>(isActive);
    map['tracks_consumption'] = Variable<bool>(tracksConsumption);
    map['supply_type'] = Variable<String>(supplyType);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      slug: Value(slug),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      isDefault: Value(isDefault),
      isActive: Value(isActive),
      tracksConsumption: Value(tracksConsumption),
      supplyType: Value(supplyType),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExpenseCategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      tracksConsumption: serializer.fromJson<bool>(json['tracksConsumption']),
      supplyType: serializer.fromJson<String>(json['supplyType']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isActive': serializer.toJson<bool>(isActive),
      'tracksConsumption': serializer.toJson<bool>(tracksConsumption),
      'supplyType': serializer.toJson<String>(supplyType),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExpenseCategoryRow copyWith(
          {String? id,
          String? householdId,
          String? name,
          String? slug,
          String? iconName,
          String? colorHex,
          bool? isDefault,
          bool? isActive,
          bool? tracksConsumption,
          String? supplyType,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      ExpenseCategoryRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        iconName: iconName ?? this.iconName,
        colorHex: colorHex ?? this.colorHex,
        isDefault: isDefault ?? this.isDefault,
        isActive: isActive ?? this.isActive,
        tracksConsumption: tracksConsumption ?? this.tracksConsumption,
        supplyType: supplyType ?? this.supplyType,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ExpenseCategoryRow copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      tracksConsumption: data.tracksConsumption.present
          ? data.tracksConsumption.value
          : this.tracksConsumption,
      supplyType:
          data.supplyType.present ? data.supplyType.value : this.supplyType,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('tracksConsumption: $tracksConsumption, ')
          ..write('supplyType: $supplyType, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      name,
      slug,
      iconName,
      colorHex,
      isDefault,
      isActive,
      tracksConsumption,
      supplyType,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategoryRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.isDefault == this.isDefault &&
          other.isActive == this.isActive &&
          other.tracksConsumption == this.tracksConsumption &&
          other.supplyType == this.supplyType &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategoryRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<bool> isDefault;
  final Value<bool> isActive;
  final Value<bool> tracksConsumption;
  final Value<String> supplyType;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.tracksConsumption = const Value.absent(),
    this.supplyType = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required String slug,
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.tracksConsumption = const Value.absent(),
    this.supplyType = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        name = Value(name),
        slug = Value(slug),
        createdAt = Value(createdAt);
  static Insertable<ExpenseCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<bool>? isDefault,
    Expression<bool>? isActive,
    Expression<bool>? tracksConsumption,
    Expression<String>? supplyType,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (isDefault != null) 'is_default': isDefault,
      if (isActive != null) 'is_active': isActive,
      if (tracksConsumption != null) 'tracks_consumption': tracksConsumption,
      if (supplyType != null) 'supply_type': supplyType,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? iconName,
      Value<String>? colorHex,
      Value<bool>? isDefault,
      Value<bool>? isActive,
      Value<bool>? tracksConsumption,
      Value<String>? supplyType,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      tracksConsumption: tracksConsumption ?? this.tracksConsumption,
      supplyType: supplyType ?? this.supplyType,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (tracksConsumption.present) {
      map['tracks_consumption'] = Variable<bool>(tracksConsumption.value);
    }
    if (supplyType.present) {
      map['supply_type'] = Variable<String>(supplyType.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('tracksConsumption: $tracksConsumption, ')
          ..write('supplyType: $supplyType, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdWalletsTable extends HouseholdWallets
    with TableInfo<$HouseholdWalletsTable, HouseholdWalletRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdWalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _totalContributionsCentsMeta =
      const VerificationMeta('totalContributionsCents');
  @override
  late final GeneratedColumn<int> totalContributionsCents =
      GeneratedColumn<int>('total_contributions_cents', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _totalExpensesCentsMeta =
      const VerificationMeta('totalExpensesCents');
  @override
  late final GeneratedColumn<int> totalExpensesCents = GeneratedColumn<int>(
      'total_expenses_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalAdjustmentsCentsMeta =
      const VerificationMeta('totalAdjustmentsCents');
  @override
  late final GeneratedColumn<int> totalAdjustmentsCents = GeneratedColumn<int>(
      'total_adjustments_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _availableBalanceCentsMeta =
      const VerificationMeta('availableBalanceCents');
  @override
  late final GeneratedColumn<int> availableBalanceCents = GeneratedColumn<int>(
      'available_balance_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastTransactionAtMeta =
      const VerificationMeta('lastTransactionAt');
  @override
  late final GeneratedColumn<DateTime> lastTransactionAt =
      GeneratedColumn<DateTime>('last_transaction_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        totalContributionsCents,
        totalExpensesCents,
        totalAdjustmentsCents,
        availableBalanceCents,
        version,
        lastTransactionAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_wallets';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdWalletRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('total_contributions_cents')) {
      context.handle(
          _totalContributionsCentsMeta,
          totalContributionsCents.isAcceptableOrUnknown(
              data['total_contributions_cents']!,
              _totalContributionsCentsMeta));
    }
    if (data.containsKey('total_expenses_cents')) {
      context.handle(
          _totalExpensesCentsMeta,
          totalExpensesCents.isAcceptableOrUnknown(
              data['total_expenses_cents']!, _totalExpensesCentsMeta));
    }
    if (data.containsKey('total_adjustments_cents')) {
      context.handle(
          _totalAdjustmentsCentsMeta,
          totalAdjustmentsCents.isAcceptableOrUnknown(
              data['total_adjustments_cents']!, _totalAdjustmentsCentsMeta));
    }
    if (data.containsKey('available_balance_cents')) {
      context.handle(
          _availableBalanceCentsMeta,
          availableBalanceCents.isAcceptableOrUnknown(
              data['available_balance_cents']!, _availableBalanceCentsMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('last_transaction_at')) {
      context.handle(
          _lastTransactionAtMeta,
          lastTransactionAt.isAcceptableOrUnknown(
              data['last_transaction_at']!, _lastTransactionAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdWalletRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdWalletRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      totalContributionsCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}total_contributions_cents'])!,
      totalExpensesCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_expenses_cents'])!,
      totalAdjustmentsCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_adjustments_cents'])!,
      availableBalanceCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}available_balance_cents'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      lastTransactionAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_transaction_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HouseholdWalletsTable createAlias(String alias) {
    return $HouseholdWalletsTable(attachedDatabase, alias);
  }
}

class HouseholdWalletRow extends DataClass
    implements Insertable<HouseholdWalletRow> {
  final String id;
  final String householdId;
  final int totalContributionsCents;
  final int totalExpensesCents;
  final int totalAdjustmentsCents;
  final int availableBalanceCents;
  final int version;
  final DateTime? lastTransactionAt;
  final DateTime? updatedAt;
  const HouseholdWalletRow(
      {required this.id,
      required this.householdId,
      required this.totalContributionsCents,
      required this.totalExpensesCents,
      required this.totalAdjustmentsCents,
      required this.availableBalanceCents,
      required this.version,
      this.lastTransactionAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['total_contributions_cents'] = Variable<int>(totalContributionsCents);
    map['total_expenses_cents'] = Variable<int>(totalExpensesCents);
    map['total_adjustments_cents'] = Variable<int>(totalAdjustmentsCents);
    map['available_balance_cents'] = Variable<int>(availableBalanceCents);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || lastTransactionAt != null) {
      map['last_transaction_at'] = Variable<DateTime>(lastTransactionAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HouseholdWalletsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdWalletsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      totalContributionsCents: Value(totalContributionsCents),
      totalExpensesCents: Value(totalExpensesCents),
      totalAdjustmentsCents: Value(totalAdjustmentsCents),
      availableBalanceCents: Value(availableBalanceCents),
      version: Value(version),
      lastTransactionAt: lastTransactionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTransactionAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory HouseholdWalletRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdWalletRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      totalContributionsCents:
          serializer.fromJson<int>(json['totalContributionsCents']),
      totalExpensesCents: serializer.fromJson<int>(json['totalExpensesCents']),
      totalAdjustmentsCents:
          serializer.fromJson<int>(json['totalAdjustmentsCents']),
      availableBalanceCents:
          serializer.fromJson<int>(json['availableBalanceCents']),
      version: serializer.fromJson<int>(json['version']),
      lastTransactionAt:
          serializer.fromJson<DateTime?>(json['lastTransactionAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'totalContributionsCents':
          serializer.toJson<int>(totalContributionsCents),
      'totalExpensesCents': serializer.toJson<int>(totalExpensesCents),
      'totalAdjustmentsCents': serializer.toJson<int>(totalAdjustmentsCents),
      'availableBalanceCents': serializer.toJson<int>(availableBalanceCents),
      'version': serializer.toJson<int>(version),
      'lastTransactionAt': serializer.toJson<DateTime?>(lastTransactionAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  HouseholdWalletRow copyWith(
          {String? id,
          String? householdId,
          int? totalContributionsCents,
          int? totalExpensesCents,
          int? totalAdjustmentsCents,
          int? availableBalanceCents,
          int? version,
          Value<DateTime?> lastTransactionAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      HouseholdWalletRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        totalContributionsCents:
            totalContributionsCents ?? this.totalContributionsCents,
        totalExpensesCents: totalExpensesCents ?? this.totalExpensesCents,
        totalAdjustmentsCents:
            totalAdjustmentsCents ?? this.totalAdjustmentsCents,
        availableBalanceCents:
            availableBalanceCents ?? this.availableBalanceCents,
        version: version ?? this.version,
        lastTransactionAt: lastTransactionAt.present
            ? lastTransactionAt.value
            : this.lastTransactionAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  HouseholdWalletRow copyWithCompanion(HouseholdWalletsCompanion data) {
    return HouseholdWalletRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      totalContributionsCents: data.totalContributionsCents.present
          ? data.totalContributionsCents.value
          : this.totalContributionsCents,
      totalExpensesCents: data.totalExpensesCents.present
          ? data.totalExpensesCents.value
          : this.totalExpensesCents,
      totalAdjustmentsCents: data.totalAdjustmentsCents.present
          ? data.totalAdjustmentsCents.value
          : this.totalAdjustmentsCents,
      availableBalanceCents: data.availableBalanceCents.present
          ? data.availableBalanceCents.value
          : this.availableBalanceCents,
      version: data.version.present ? data.version.value : this.version,
      lastTransactionAt: data.lastTransactionAt.present
          ? data.lastTransactionAt.value
          : this.lastTransactionAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdWalletRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('totalContributionsCents: $totalContributionsCents, ')
          ..write('totalExpensesCents: $totalExpensesCents, ')
          ..write('totalAdjustmentsCents: $totalAdjustmentsCents, ')
          ..write('availableBalanceCents: $availableBalanceCents, ')
          ..write('version: $version, ')
          ..write('lastTransactionAt: $lastTransactionAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      totalContributionsCents,
      totalExpensesCents,
      totalAdjustmentsCents,
      availableBalanceCents,
      version,
      lastTransactionAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdWalletRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.totalContributionsCents == this.totalContributionsCents &&
          other.totalExpensesCents == this.totalExpensesCents &&
          other.totalAdjustmentsCents == this.totalAdjustmentsCents &&
          other.availableBalanceCents == this.availableBalanceCents &&
          other.version == this.version &&
          other.lastTransactionAt == this.lastTransactionAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdWalletsCompanion extends UpdateCompanion<HouseholdWalletRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<int> totalContributionsCents;
  final Value<int> totalExpensesCents;
  final Value<int> totalAdjustmentsCents;
  final Value<int> availableBalanceCents;
  final Value<int> version;
  final Value<DateTime?> lastTransactionAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HouseholdWalletsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.totalContributionsCents = const Value.absent(),
    this.totalExpensesCents = const Value.absent(),
    this.totalAdjustmentsCents = const Value.absent(),
    this.availableBalanceCents = const Value.absent(),
    this.version = const Value.absent(),
    this.lastTransactionAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdWalletsCompanion.insert({
    required String id,
    required String householdId,
    this.totalContributionsCents = const Value.absent(),
    this.totalExpensesCents = const Value.absent(),
    this.totalAdjustmentsCents = const Value.absent(),
    this.availableBalanceCents = const Value.absent(),
    this.version = const Value.absent(),
    this.lastTransactionAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId);
  static Insertable<HouseholdWalletRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<int>? totalContributionsCents,
    Expression<int>? totalExpensesCents,
    Expression<int>? totalAdjustmentsCents,
    Expression<int>? availableBalanceCents,
    Expression<int>? version,
    Expression<DateTime>? lastTransactionAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (totalContributionsCents != null)
        'total_contributions_cents': totalContributionsCents,
      if (totalExpensesCents != null)
        'total_expenses_cents': totalExpensesCents,
      if (totalAdjustmentsCents != null)
        'total_adjustments_cents': totalAdjustmentsCents,
      if (availableBalanceCents != null)
        'available_balance_cents': availableBalanceCents,
      if (version != null) 'version': version,
      if (lastTransactionAt != null) 'last_transaction_at': lastTransactionAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdWalletsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<int>? totalContributionsCents,
      Value<int>? totalExpensesCents,
      Value<int>? totalAdjustmentsCents,
      Value<int>? availableBalanceCents,
      Value<int>? version,
      Value<DateTime?>? lastTransactionAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdWalletsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      totalContributionsCents:
          totalContributionsCents ?? this.totalContributionsCents,
      totalExpensesCents: totalExpensesCents ?? this.totalExpensesCents,
      totalAdjustmentsCents:
          totalAdjustmentsCents ?? this.totalAdjustmentsCents,
      availableBalanceCents:
          availableBalanceCents ?? this.availableBalanceCents,
      version: version ?? this.version,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (totalContributionsCents.present) {
      map['total_contributions_cents'] =
          Variable<int>(totalContributionsCents.value);
    }
    if (totalExpensesCents.present) {
      map['total_expenses_cents'] = Variable<int>(totalExpensesCents.value);
    }
    if (totalAdjustmentsCents.present) {
      map['total_adjustments_cents'] =
          Variable<int>(totalAdjustmentsCents.value);
    }
    if (availableBalanceCents.present) {
      map['available_balance_cents'] =
          Variable<int>(availableBalanceCents.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (lastTransactionAt.present) {
      map['last_transaction_at'] = Variable<DateTime>(lastTransactionAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdWalletsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('totalContributionsCents: $totalContributionsCents, ')
          ..write('totalExpensesCents: $totalExpensesCents, ')
          ..write('totalAdjustmentsCents: $totalAdjustmentsCents, ')
          ..write('availableBalanceCents: $availableBalanceCents, ')
          ..write('version: $version, ')
          ..write('lastTransactionAt: $lastTransactionAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContributionsTable extends Contributions
    with TableInfo<$ContributionsTable, ContributionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
      'member_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberNameMeta =
      const VerificationMeta('memberName');
  @override
  late final GeneratedColumn<String> memberName = GeneratedColumn<String>(
      'member_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contributionDateMeta =
      const VerificationMeta('contributionDate');
  @override
  late final GeneratedColumn<DateTime> contributionDate =
      GeneratedColumn<DateTime>('contribution_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        memberId,
        memberName,
        recordedBy,
        amountCents,
        contributionDate,
        description,
        status,
        idempotencyKey,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contributions';
  @override
  VerificationContext validateIntegrity(Insertable<ContributionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('member_name')) {
      context.handle(
          _memberNameMeta,
          memberName.isAcceptableOrUnknown(
              data['member_name']!, _memberNameMeta));
    } else if (isInserting) {
      context.missing(_memberNameMeta);
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('contribution_date')) {
      context.handle(
          _contributionDateMeta,
          contributionDate.isAcceptableOrUnknown(
              data['contribution_date']!, _contributionDateMeta));
    } else if (isInserting) {
      context.missing(_contributionDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContributionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContributionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_id'])!,
      memberName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_name'])!,
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      contributionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}contribution_date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ContributionsTable createAlias(String alias) {
    return $ContributionsTable(attachedDatabase, alias);
  }
}

class ContributionRow extends DataClass implements Insertable<ContributionRow> {
  final String id;
  final String householdId;
  final String memberId;
  final String memberName;
  final String recordedBy;
  final int amountCents;
  final DateTime contributionDate;
  final String? description;
  final String status;
  final String idempotencyKey;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ContributionRow(
      {required this.id,
      required this.householdId,
      required this.memberId,
      required this.memberName,
      required this.recordedBy,
      required this.amountCents,
      required this.contributionDate,
      this.description,
      required this.status,
      required this.idempotencyKey,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['member_id'] = Variable<String>(memberId);
    map['member_name'] = Variable<String>(memberName);
    map['recorded_by'] = Variable<String>(recordedBy);
    map['amount_cents'] = Variable<int>(amountCents);
    map['contribution_date'] = Variable<DateTime>(contributionDate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ContributionsCompanion toCompanion(bool nullToAbsent) {
    return ContributionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      memberId: Value(memberId),
      memberName: Value(memberName),
      recordedBy: Value(recordedBy),
      amountCents: Value(amountCents),
      contributionDate: Value(contributionDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      idempotencyKey: Value(idempotencyKey),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ContributionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContributionRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      memberName: serializer.fromJson<String>(json['memberName']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      contributionDate: serializer.fromJson<DateTime>(json['contributionDate']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'memberId': serializer.toJson<String>(memberId),
      'memberName': serializer.toJson<String>(memberName),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'amountCents': serializer.toJson<int>(amountCents),
      'contributionDate': serializer.toJson<DateTime>(contributionDate),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ContributionRow copyWith(
          {String? id,
          String? householdId,
          String? memberId,
          String? memberName,
          String? recordedBy,
          int? amountCents,
          DateTime? contributionDate,
          Value<String?> description = const Value.absent(),
          String? status,
          String? idempotencyKey,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      ContributionRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        memberId: memberId ?? this.memberId,
        memberName: memberName ?? this.memberName,
        recordedBy: recordedBy ?? this.recordedBy,
        amountCents: amountCents ?? this.amountCents,
        contributionDate: contributionDate ?? this.contributionDate,
        description: description.present ? description.value : this.description,
        status: status ?? this.status,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ContributionRow copyWithCompanion(ContributionsCompanion data) {
    return ContributionRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      memberName:
          data.memberName.present ? data.memberName.value : this.memberName,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      contributionDate: data.contributionDate.present
          ? data.contributionDate.value
          : this.contributionDate,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContributionRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('amountCents: $amountCents, ')
          ..write('contributionDate: $contributionDate, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      memberId,
      memberName,
      recordedBy,
      amountCents,
      contributionDate,
      description,
      status,
      idempotencyKey,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContributionRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.memberId == this.memberId &&
          other.memberName == this.memberName &&
          other.recordedBy == this.recordedBy &&
          other.amountCents == this.amountCents &&
          other.contributionDate == this.contributionDate &&
          other.description == this.description &&
          other.status == this.status &&
          other.idempotencyKey == this.idempotencyKey &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContributionsCompanion extends UpdateCompanion<ContributionRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> memberId;
  final Value<String> memberName;
  final Value<String> recordedBy;
  final Value<int> amountCents;
  final Value<DateTime> contributionDate;
  final Value<String?> description;
  final Value<String> status;
  final Value<String> idempotencyKey;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ContributionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.contributionDate = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContributionsCompanion.insert({
    required String id,
    required String householdId,
    required String memberId,
    required String memberName,
    required String recordedBy,
    required int amountCents,
    required DateTime contributionDate,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    required String idempotencyKey,
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        memberId = Value(memberId),
        memberName = Value(memberName),
        recordedBy = Value(recordedBy),
        amountCents = Value(amountCents),
        contributionDate = Value(contributionDate),
        idempotencyKey = Value(idempotencyKey),
        createdAt = Value(createdAt);
  static Insertable<ContributionRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? memberId,
    Expression<String>? memberName,
    Expression<String>? recordedBy,
    Expression<int>? amountCents,
    Expression<DateTime>? contributionDate,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? idempotencyKey,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (memberId != null) 'member_id': memberId,
      if (memberName != null) 'member_name': memberName,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (amountCents != null) 'amount_cents': amountCents,
      if (contributionDate != null) 'contribution_date': contributionDate,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContributionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? memberId,
      Value<String>? memberName,
      Value<String>? recordedBy,
      Value<int>? amountCents,
      Value<DateTime>? contributionDate,
      Value<String?>? description,
      Value<String>? status,
      Value<String>? idempotencyKey,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return ContributionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      recordedBy: recordedBy ?? this.recordedBy,
      amountCents: amountCents ?? this.amountCents,
      contributionDate: contributionDate ?? this.contributionDate,
      description: description ?? this.description,
      status: status ?? this.status,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (memberName.present) {
      map['member_name'] = Variable<String>(memberName.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (contributionDate.present) {
      map['contribution_date'] = Variable<DateTime>(contributionDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContributionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('amountCents: $amountCents, ')
          ..write('contributionDate: $contributionDate, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paidByMemberIdMeta =
      const VerificationMeta('paidByMemberId');
  @override
  late final GeneratedColumn<String> paidByMemberId = GeneratedColumn<String>(
      'paid_by_member_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paidByMemberNameMeta =
      const VerificationMeta('paidByMemberName');
  @override
  late final GeneratedColumn<String> paidByMemberName = GeneratedColumn<String>(
      'paid_by_member_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptUrlMeta =
      const VerificationMeta('receiptUrl');
  @override
  late final GeneratedColumn<String> receiptUrl = GeneratedColumn<String>(
      'receipt_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        categoryId,
        categoryName,
        paidByMemberId,
        paidByMemberName,
        recordedBy,
        title,
        amountCents,
        expenseDate,
        notes,
        receiptUrl,
        status,
        idempotencyKey,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
          _paidByMemberIdMeta,
          paidByMemberId.isAcceptableOrUnknown(
              data['paid_by_member_id']!, _paidByMemberIdMeta));
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('paid_by_member_name')) {
      context.handle(
          _paidByMemberNameMeta,
          paidByMemberName.isAcceptableOrUnknown(
              data['paid_by_member_name']!, _paidByMemberNameMeta));
    } else if (isInserting) {
      context.missing(_paidByMemberNameMeta);
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('receipt_url')) {
      context.handle(
          _receiptUrlMeta,
          receiptUrl.isAcceptableOrUnknown(
              data['receipt_url']!, _receiptUrlMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      paidByMemberId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}paid_by_member_id'])!,
      paidByMemberName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}paid_by_member_name'])!,
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      receiptUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_url']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final String paidByMemberId;
  final String paidByMemberName;
  final String recordedBy;
  final String title;
  final int amountCents;
  final DateTime expenseDate;
  final String? notes;
  final String? receiptUrl;
  final String status;
  final String idempotencyKey;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ExpenseRow(
      {required this.id,
      required this.householdId,
      required this.categoryId,
      required this.categoryName,
      required this.paidByMemberId,
      required this.paidByMemberName,
      required this.recordedBy,
      required this.title,
      required this.amountCents,
      required this.expenseDate,
      this.notes,
      this.receiptUrl,
      required this.status,
      required this.idempotencyKey,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['paid_by_member_id'] = Variable<String>(paidByMemberId);
    map['paid_by_member_name'] = Variable<String>(paidByMemberName);
    map['recorded_by'] = Variable<String>(recordedBy);
    map['title'] = Variable<String>(title);
    map['amount_cents'] = Variable<int>(amountCents);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || receiptUrl != null) {
      map['receipt_url'] = Variable<String>(receiptUrl);
    }
    map['status'] = Variable<String>(status);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      paidByMemberId: Value(paidByMemberId),
      paidByMemberName: Value(paidByMemberName),
      recordedBy: Value(recordedBy),
      title: Value(title),
      amountCents: Value(amountCents),
      expenseDate: Value(expenseDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      receiptUrl: receiptUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptUrl),
      status: Value(status),
      idempotencyKey: Value(idempotencyKey),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExpenseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      paidByMemberId: serializer.fromJson<String>(json['paidByMemberId']),
      paidByMemberName: serializer.fromJson<String>(json['paidByMemberName']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      title: serializer.fromJson<String>(json['title']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      receiptUrl: serializer.fromJson<String?>(json['receiptUrl']),
      status: serializer.fromJson<String>(json['status']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'paidByMemberId': serializer.toJson<String>(paidByMemberId),
      'paidByMemberName': serializer.toJson<String>(paidByMemberName),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'title': serializer.toJson<String>(title),
      'amountCents': serializer.toJson<int>(amountCents),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'notes': serializer.toJson<String?>(notes),
      'receiptUrl': serializer.toJson<String?>(receiptUrl),
      'status': serializer.toJson<String>(status),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExpenseRow copyWith(
          {String? id,
          String? householdId,
          String? categoryId,
          String? categoryName,
          String? paidByMemberId,
          String? paidByMemberName,
          String? recordedBy,
          String? title,
          int? amountCents,
          DateTime? expenseDate,
          Value<String?> notes = const Value.absent(),
          Value<String?> receiptUrl = const Value.absent(),
          String? status,
          String? idempotencyKey,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      ExpenseRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        paidByMemberId: paidByMemberId ?? this.paidByMemberId,
        paidByMemberName: paidByMemberName ?? this.paidByMemberName,
        recordedBy: recordedBy ?? this.recordedBy,
        title: title ?? this.title,
        amountCents: amountCents ?? this.amountCents,
        expenseDate: expenseDate ?? this.expenseDate,
        notes: notes.present ? notes.value : this.notes,
        receiptUrl: receiptUrl.present ? receiptUrl.value : this.receiptUrl,
        status: status ?? this.status,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      paidByMemberName: data.paidByMemberName.present
          ? data.paidByMemberName.value
          : this.paidByMemberName,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      title: data.title.present ? data.title.value : this.title,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      receiptUrl:
          data.receiptUrl.present ? data.receiptUrl.value : this.receiptUrl,
      status: data.status.present ? data.status.value : this.status,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('paidByMemberName: $paidByMemberName, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('notes: $notes, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('status: $status, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      categoryId,
      categoryName,
      paidByMemberId,
      paidByMemberName,
      recordedBy,
      title,
      amountCents,
      expenseDate,
      notes,
      receiptUrl,
      status,
      idempotencyKey,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.paidByMemberId == this.paidByMemberId &&
          other.paidByMemberName == this.paidByMemberName &&
          other.recordedBy == this.recordedBy &&
          other.title == this.title &&
          other.amountCents == this.amountCents &&
          other.expenseDate == this.expenseDate &&
          other.notes == this.notes &&
          other.receiptUrl == this.receiptUrl &&
          other.status == this.status &&
          other.idempotencyKey == this.idempotencyKey &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<String> paidByMemberId;
  final Value<String> paidByMemberName;
  final Value<String> recordedBy;
  final Value<String> title;
  final Value<int> amountCents;
  final Value<DateTime> expenseDate;
  final Value<String?> notes;
  final Value<String?> receiptUrl;
  final Value<String> status;
  final Value<String> idempotencyKey;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.paidByMemberName = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.title = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String householdId,
    required String categoryId,
    required String categoryName,
    required String paidByMemberId,
    required String paidByMemberName,
    required String recordedBy,
    required String title,
    required int amountCents,
    required DateTime expenseDate,
    this.notes = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.status = const Value.absent(),
    required String idempotencyKey,
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        categoryId = Value(categoryId),
        categoryName = Value(categoryName),
        paidByMemberId = Value(paidByMemberId),
        paidByMemberName = Value(paidByMemberName),
        recordedBy = Value(recordedBy),
        title = Value(title),
        amountCents = Value(amountCents),
        expenseDate = Value(expenseDate),
        idempotencyKey = Value(idempotencyKey),
        createdAt = Value(createdAt);
  static Insertable<ExpenseRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? paidByMemberId,
    Expression<String>? paidByMemberName,
    Expression<String>? recordedBy,
    Expression<String>? title,
    Expression<int>? amountCents,
    Expression<DateTime>? expenseDate,
    Expression<String>? notes,
    Expression<String>? receiptUrl,
    Expression<String>? status,
    Expression<String>? idempotencyKey,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (paidByMemberName != null) 'paid_by_member_name': paidByMemberName,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (title != null) 'title': title,
      if (amountCents != null) 'amount_cents': amountCents,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (notes != null) 'notes': notes,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
      if (status != null) 'status': status,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? categoryId,
      Value<String>? categoryName,
      Value<String>? paidByMemberId,
      Value<String>? paidByMemberName,
      Value<String>? recordedBy,
      Value<String>? title,
      Value<int>? amountCents,
      Value<DateTime>? expenseDate,
      Value<String?>? notes,
      Value<String?>? receiptUrl,
      Value<String>? status,
      Value<String>? idempotencyKey,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      paidByMemberName: paidByMemberName ?? this.paidByMemberName,
      recordedBy: recordedBy ?? this.recordedBy,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
      expenseDate: expenseDate ?? this.expenseDate,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      status: status ?? this.status,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<String>(paidByMemberId.value);
    }
    if (paidByMemberName.present) {
      map['paid_by_member_name'] = Variable<String>(paidByMemberName.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (receiptUrl.present) {
      map['receipt_url'] = Variable<String>(receiptUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('paidByMemberName: $paidByMemberName, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('notes: $notes, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('status: $status, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletTransactionsTable extends WalletTransactions
    with TableInfo<$WalletTransactionsTable, WalletTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _walletIdMeta =
      const VerificationMeta('walletId');
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
      'wallet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionTypeMeta =
      const VerificationMeta('transactionType');
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
      'transaction_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceContributionIdMeta =
      const VerificationMeta('referenceContributionId');
  @override
  late final GeneratedColumn<String> referenceContributionId =
      GeneratedColumn<String>('reference_contribution_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceExpenseIdMeta =
      const VerificationMeta('referenceExpenseId');
  @override
  late final GeneratedColumn<String> referenceExpenseId =
      GeneratedColumn<String>('reference_expense_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentTransactionIdMeta =
      const VerificationMeta('parentTransactionId');
  @override
  late final GeneratedColumn<String> parentTransactionId =
      GeneratedColumn<String>('parent_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
      'member_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memberNameMeta =
      const VerificationMeta('memberName');
  @override
  late final GeneratedColumn<String> memberName = GeneratedColumn<String>(
      'member_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _signedAmountCentsMeta =
      const VerificationMeta('signedAmountCents');
  @override
  late final GeneratedColumn<int> signedAmountCents = GeneratedColumn<int>(
      'signed_amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balanceBeforeCentsMeta =
      const VerificationMeta('balanceBeforeCents');
  @override
  late final GeneratedColumn<int> balanceBeforeCents = GeneratedColumn<int>(
      'balance_before_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balanceAfterCentsMeta =
      const VerificationMeta('balanceAfterCents');
  @override
  late final GeneratedColumn<int> balanceAfterCents = GeneratedColumn<int>(
      'balance_after_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        walletId,
        transactionType,
        referenceContributionId,
        referenceExpenseId,
        parentTransactionId,
        memberId,
        memberName,
        categoryId,
        categoryName,
        amountCents,
        signedAmountCents,
        balanceBeforeCents,
        balanceAfterCents,
        transactionDate,
        description,
        recordedBy,
        version,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<WalletTransactionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(_walletIdMeta,
          walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta));
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
          _transactionTypeMeta,
          transactionType.isAcceptableOrUnknown(
              data['transaction_type']!, _transactionTypeMeta));
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('reference_contribution_id')) {
      context.handle(
          _referenceContributionIdMeta,
          referenceContributionId.isAcceptableOrUnknown(
              data['reference_contribution_id']!,
              _referenceContributionIdMeta));
    }
    if (data.containsKey('reference_expense_id')) {
      context.handle(
          _referenceExpenseIdMeta,
          referenceExpenseId.isAcceptableOrUnknown(
              data['reference_expense_id']!, _referenceExpenseIdMeta));
    }
    if (data.containsKey('parent_transaction_id')) {
      context.handle(
          _parentTransactionIdMeta,
          parentTransactionId.isAcceptableOrUnknown(
              data['parent_transaction_id']!, _parentTransactionIdMeta));
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    }
    if (data.containsKey('member_name')) {
      context.handle(
          _memberNameMeta,
          memberName.isAcceptableOrUnknown(
              data['member_name']!, _memberNameMeta));
    } else if (isInserting) {
      context.missing(_memberNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('signed_amount_cents')) {
      context.handle(
          _signedAmountCentsMeta,
          signedAmountCents.isAcceptableOrUnknown(
              data['signed_amount_cents']!, _signedAmountCentsMeta));
    } else if (isInserting) {
      context.missing(_signedAmountCentsMeta);
    }
    if (data.containsKey('balance_before_cents')) {
      context.handle(
          _balanceBeforeCentsMeta,
          balanceBeforeCents.isAcceptableOrUnknown(
              data['balance_before_cents']!, _balanceBeforeCentsMeta));
    } else if (isInserting) {
      context.missing(_balanceBeforeCentsMeta);
    }
    if (data.containsKey('balance_after_cents')) {
      context.handle(
          _balanceAfterCentsMeta,
          balanceAfterCents.isAcceptableOrUnknown(
              data['balance_after_cents']!, _balanceAfterCentsMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterCentsMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletTransactionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      walletId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wallet_id'])!,
      transactionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transaction_type'])!,
      referenceContributionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reference_contribution_id']),
      referenceExpenseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_expense_id']),
      parentTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parent_transaction_id']),
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_id']),
      memberName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      signedAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}signed_amount_cents'])!,
      balanceBeforeCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}balance_before_cents'])!,
      balanceAfterCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}balance_after_cents'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WalletTransactionsTable createAlias(String alias) {
    return $WalletTransactionsTable(attachedDatabase, alias);
  }
}

class WalletTransactionRow extends DataClass
    implements Insertable<WalletTransactionRow> {
  final String id;
  final String householdId;
  final String walletId;
  final String transactionType;
  final String? referenceContributionId;
  final String? referenceExpenseId;
  final String? parentTransactionId;
  final String? memberId;
  final String memberName;
  final String? categoryId;
  final String categoryName;
  final int amountCents;
  final int signedAmountCents;
  final int balanceBeforeCents;
  final int balanceAfterCents;
  final DateTime transactionDate;
  final String description;
  final String recordedBy;
  final int version;
  final DateTime createdAt;
  const WalletTransactionRow(
      {required this.id,
      required this.householdId,
      required this.walletId,
      required this.transactionType,
      this.referenceContributionId,
      this.referenceExpenseId,
      this.parentTransactionId,
      this.memberId,
      required this.memberName,
      this.categoryId,
      required this.categoryName,
      required this.amountCents,
      required this.signedAmountCents,
      required this.balanceBeforeCents,
      required this.balanceAfterCents,
      required this.transactionDate,
      required this.description,
      required this.recordedBy,
      required this.version,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['wallet_id'] = Variable<String>(walletId);
    map['transaction_type'] = Variable<String>(transactionType);
    if (!nullToAbsent || referenceContributionId != null) {
      map['reference_contribution_id'] =
          Variable<String>(referenceContributionId);
    }
    if (!nullToAbsent || referenceExpenseId != null) {
      map['reference_expense_id'] = Variable<String>(referenceExpenseId);
    }
    if (!nullToAbsent || parentTransactionId != null) {
      map['parent_transaction_id'] = Variable<String>(parentTransactionId);
    }
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['member_name'] = Variable<String>(memberName);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['category_name'] = Variable<String>(categoryName);
    map['amount_cents'] = Variable<int>(amountCents);
    map['signed_amount_cents'] = Variable<int>(signedAmountCents);
    map['balance_before_cents'] = Variable<int>(balanceBeforeCents);
    map['balance_after_cents'] = Variable<int>(balanceAfterCents);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['description'] = Variable<String>(description);
    map['recorded_by'] = Variable<String>(recordedBy);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletTransactionsCompanion toCompanion(bool nullToAbsent) {
    return WalletTransactionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      walletId: Value(walletId),
      transactionType: Value(transactionType),
      referenceContributionId: referenceContributionId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceContributionId),
      referenceExpenseId: referenceExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceExpenseId),
      parentTransactionId: parentTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTransactionId),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      memberName: Value(memberName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categoryName: Value(categoryName),
      amountCents: Value(amountCents),
      signedAmountCents: Value(signedAmountCents),
      balanceBeforeCents: Value(balanceBeforeCents),
      balanceAfterCents: Value(balanceAfterCents),
      transactionDate: Value(transactionDate),
      description: Value(description),
      recordedBy: Value(recordedBy),
      version: Value(version),
      createdAt: Value(createdAt),
    );
  }

  factory WalletTransactionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      walletId: serializer.fromJson<String>(json['walletId']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      referenceContributionId:
          serializer.fromJson<String?>(json['referenceContributionId']),
      referenceExpenseId:
          serializer.fromJson<String?>(json['referenceExpenseId']),
      parentTransactionId:
          serializer.fromJson<String?>(json['parentTransactionId']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      memberName: serializer.fromJson<String>(json['memberName']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      signedAmountCents: serializer.fromJson<int>(json['signedAmountCents']),
      balanceBeforeCents: serializer.fromJson<int>(json['balanceBeforeCents']),
      balanceAfterCents: serializer.fromJson<int>(json['balanceAfterCents']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      description: serializer.fromJson<String>(json['description']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'walletId': serializer.toJson<String>(walletId),
      'transactionType': serializer.toJson<String>(transactionType),
      'referenceContributionId':
          serializer.toJson<String?>(referenceContributionId),
      'referenceExpenseId': serializer.toJson<String?>(referenceExpenseId),
      'parentTransactionId': serializer.toJson<String?>(parentTransactionId),
      'memberId': serializer.toJson<String?>(memberId),
      'memberName': serializer.toJson<String>(memberName),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'amountCents': serializer.toJson<int>(amountCents),
      'signedAmountCents': serializer.toJson<int>(signedAmountCents),
      'balanceBeforeCents': serializer.toJson<int>(balanceBeforeCents),
      'balanceAfterCents': serializer.toJson<int>(balanceAfterCents),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'description': serializer.toJson<String>(description),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletTransactionRow copyWith(
          {String? id,
          String? householdId,
          String? walletId,
          String? transactionType,
          Value<String?> referenceContributionId = const Value.absent(),
          Value<String?> referenceExpenseId = const Value.absent(),
          Value<String?> parentTransactionId = const Value.absent(),
          Value<String?> memberId = const Value.absent(),
          String? memberName,
          Value<String?> categoryId = const Value.absent(),
          String? categoryName,
          int? amountCents,
          int? signedAmountCents,
          int? balanceBeforeCents,
          int? balanceAfterCents,
          DateTime? transactionDate,
          String? description,
          String? recordedBy,
          int? version,
          DateTime? createdAt}) =>
      WalletTransactionRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        walletId: walletId ?? this.walletId,
        transactionType: transactionType ?? this.transactionType,
        referenceContributionId: referenceContributionId.present
            ? referenceContributionId.value
            : this.referenceContributionId,
        referenceExpenseId: referenceExpenseId.present
            ? referenceExpenseId.value
            : this.referenceExpenseId,
        parentTransactionId: parentTransactionId.present
            ? parentTransactionId.value
            : this.parentTransactionId,
        memberId: memberId.present ? memberId.value : this.memberId,
        memberName: memberName ?? this.memberName,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        amountCents: amountCents ?? this.amountCents,
        signedAmountCents: signedAmountCents ?? this.signedAmountCents,
        balanceBeforeCents: balanceBeforeCents ?? this.balanceBeforeCents,
        balanceAfterCents: balanceAfterCents ?? this.balanceAfterCents,
        transactionDate: transactionDate ?? this.transactionDate,
        description: description ?? this.description,
        recordedBy: recordedBy ?? this.recordedBy,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
      );
  WalletTransactionRow copyWithCompanion(WalletTransactionsCompanion data) {
    return WalletTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      referenceContributionId: data.referenceContributionId.present
          ? data.referenceContributionId.value
          : this.referenceContributionId,
      referenceExpenseId: data.referenceExpenseId.present
          ? data.referenceExpenseId.value
          : this.referenceExpenseId,
      parentTransactionId: data.parentTransactionId.present
          ? data.parentTransactionId.value
          : this.parentTransactionId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      memberName:
          data.memberName.present ? data.memberName.value : this.memberName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      signedAmountCents: data.signedAmountCents.present
          ? data.signedAmountCents.value
          : this.signedAmountCents,
      balanceBeforeCents: data.balanceBeforeCents.present
          ? data.balanceBeforeCents.value
          : this.balanceBeforeCents,
      balanceAfterCents: data.balanceAfterCents.present
          ? data.balanceAfterCents.value
          : this.balanceAfterCents,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      description:
          data.description.present ? data.description.value : this.description,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletTransactionRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('walletId: $walletId, ')
          ..write('transactionType: $transactionType, ')
          ..write('referenceContributionId: $referenceContributionId, ')
          ..write('referenceExpenseId: $referenceExpenseId, ')
          ..write('parentTransactionId: $parentTransactionId, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('amountCents: $amountCents, ')
          ..write('signedAmountCents: $signedAmountCents, ')
          ..write('balanceBeforeCents: $balanceBeforeCents, ')
          ..write('balanceAfterCents: $balanceAfterCents, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      walletId,
      transactionType,
      referenceContributionId,
      referenceExpenseId,
      parentTransactionId,
      memberId,
      memberName,
      categoryId,
      categoryName,
      amountCents,
      signedAmountCents,
      balanceBeforeCents,
      balanceAfterCents,
      transactionDate,
      description,
      recordedBy,
      version,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletTransactionRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.walletId == this.walletId &&
          other.transactionType == this.transactionType &&
          other.referenceContributionId == this.referenceContributionId &&
          other.referenceExpenseId == this.referenceExpenseId &&
          other.parentTransactionId == this.parentTransactionId &&
          other.memberId == this.memberId &&
          other.memberName == this.memberName &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.amountCents == this.amountCents &&
          other.signedAmountCents == this.signedAmountCents &&
          other.balanceBeforeCents == this.balanceBeforeCents &&
          other.balanceAfterCents == this.balanceAfterCents &&
          other.transactionDate == this.transactionDate &&
          other.description == this.description &&
          other.recordedBy == this.recordedBy &&
          other.version == this.version &&
          other.createdAt == this.createdAt);
}

class WalletTransactionsCompanion
    extends UpdateCompanion<WalletTransactionRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> walletId;
  final Value<String> transactionType;
  final Value<String?> referenceContributionId;
  final Value<String?> referenceExpenseId;
  final Value<String?> parentTransactionId;
  final Value<String?> memberId;
  final Value<String> memberName;
  final Value<String?> categoryId;
  final Value<String> categoryName;
  final Value<int> amountCents;
  final Value<int> signedAmountCents;
  final Value<int> balanceBeforeCents;
  final Value<int> balanceAfterCents;
  final Value<DateTime> transactionDate;
  final Value<String> description;
  final Value<String> recordedBy;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WalletTransactionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.referenceContributionId = const Value.absent(),
    this.referenceExpenseId = const Value.absent(),
    this.parentTransactionId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.signedAmountCents = const Value.absent(),
    this.balanceBeforeCents = const Value.absent(),
    this.balanceAfterCents = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.description = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletTransactionsCompanion.insert({
    required String id,
    required String householdId,
    required String walletId,
    required String transactionType,
    this.referenceContributionId = const Value.absent(),
    this.referenceExpenseId = const Value.absent(),
    this.parentTransactionId = const Value.absent(),
    this.memberId = const Value.absent(),
    required String memberName,
    this.categoryId = const Value.absent(),
    required String categoryName,
    required int amountCents,
    required int signedAmountCents,
    required int balanceBeforeCents,
    required int balanceAfterCents,
    required DateTime transactionDate,
    required String description,
    required String recordedBy,
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        walletId = Value(walletId),
        transactionType = Value(transactionType),
        memberName = Value(memberName),
        categoryName = Value(categoryName),
        amountCents = Value(amountCents),
        signedAmountCents = Value(signedAmountCents),
        balanceBeforeCents = Value(balanceBeforeCents),
        balanceAfterCents = Value(balanceAfterCents),
        transactionDate = Value(transactionDate),
        description = Value(description),
        recordedBy = Value(recordedBy),
        createdAt = Value(createdAt);
  static Insertable<WalletTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? walletId,
    Expression<String>? transactionType,
    Expression<String>? referenceContributionId,
    Expression<String>? referenceExpenseId,
    Expression<String>? parentTransactionId,
    Expression<String>? memberId,
    Expression<String>? memberName,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<int>? amountCents,
    Expression<int>? signedAmountCents,
    Expression<int>? balanceBeforeCents,
    Expression<int>? balanceAfterCents,
    Expression<DateTime>? transactionDate,
    Expression<String>? description,
    Expression<String>? recordedBy,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (walletId != null) 'wallet_id': walletId,
      if (transactionType != null) 'transaction_type': transactionType,
      if (referenceContributionId != null)
        'reference_contribution_id': referenceContributionId,
      if (referenceExpenseId != null)
        'reference_expense_id': referenceExpenseId,
      if (parentTransactionId != null)
        'parent_transaction_id': parentTransactionId,
      if (memberId != null) 'member_id': memberId,
      if (memberName != null) 'member_name': memberName,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (amountCents != null) 'amount_cents': amountCents,
      if (signedAmountCents != null) 'signed_amount_cents': signedAmountCents,
      if (balanceBeforeCents != null)
        'balance_before_cents': balanceBeforeCents,
      if (balanceAfterCents != null) 'balance_after_cents': balanceAfterCents,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (description != null) 'description': description,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? walletId,
      Value<String>? transactionType,
      Value<String?>? referenceContributionId,
      Value<String?>? referenceExpenseId,
      Value<String?>? parentTransactionId,
      Value<String?>? memberId,
      Value<String>? memberName,
      Value<String?>? categoryId,
      Value<String>? categoryName,
      Value<int>? amountCents,
      Value<int>? signedAmountCents,
      Value<int>? balanceBeforeCents,
      Value<int>? balanceAfterCents,
      Value<DateTime>? transactionDate,
      Value<String>? description,
      Value<String>? recordedBy,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return WalletTransactionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      walletId: walletId ?? this.walletId,
      transactionType: transactionType ?? this.transactionType,
      referenceContributionId:
          referenceContributionId ?? this.referenceContributionId,
      referenceExpenseId: referenceExpenseId ?? this.referenceExpenseId,
      parentTransactionId: parentTransactionId ?? this.parentTransactionId,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amountCents: amountCents ?? this.amountCents,
      signedAmountCents: signedAmountCents ?? this.signedAmountCents,
      balanceBeforeCents: balanceBeforeCents ?? this.balanceBeforeCents,
      balanceAfterCents: balanceAfterCents ?? this.balanceAfterCents,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      recordedBy: recordedBy ?? this.recordedBy,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (referenceContributionId.present) {
      map['reference_contribution_id'] =
          Variable<String>(referenceContributionId.value);
    }
    if (referenceExpenseId.present) {
      map['reference_expense_id'] = Variable<String>(referenceExpenseId.value);
    }
    if (parentTransactionId.present) {
      map['parent_transaction_id'] =
          Variable<String>(parentTransactionId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (memberName.present) {
      map['member_name'] = Variable<String>(memberName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (signedAmountCents.present) {
      map['signed_amount_cents'] = Variable<int>(signedAmountCents.value);
    }
    if (balanceBeforeCents.present) {
      map['balance_before_cents'] = Variable<int>(balanceBeforeCents.value);
    }
    if (balanceAfterCents.present) {
      map['balance_after_cents'] = Variable<int>(balanceAfterCents.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('walletId: $walletId, ')
          ..write('transactionType: $transactionType, ')
          ..write('referenceContributionId: $referenceContributionId, ')
          ..write('referenceExpenseId: $referenceExpenseId, ')
          ..write('parentTransactionId: $parentTransactionId, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('amountCents: $amountCents, ')
          ..write('signedAmountCents: $signedAmountCents, ')
          ..write('balanceBeforeCents: $balanceBeforeCents, ')
          ..write('balanceAfterCents: $balanceAfterCents, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdBudgetsTable extends HouseholdBudgets
    with TableInfo<$HouseholdBudgetsTable, HouseholdBudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetMonthMeta =
      const VerificationMeta('budgetMonth');
  @override
  late final GeneratedColumn<DateTime> budgetMonth = GeneratedColumn<DateTime>(
      'budget_month', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _budgetAmountCentsMeta =
      const VerificationMeta('budgetAmountCents');
  @override
  late final GeneratedColumn<int> budgetAmountCents = GeneratedColumn<int>(
      'budget_amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _alertThresholdPercentMeta =
      const VerificationMeta('alertThresholdPercent');
  @override
  late final GeneratedColumn<int> alertThresholdPercent = GeneratedColumn<int>(
      'alert_threshold_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(80));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        categoryId,
        categoryName,
        budgetMonth,
        budgetAmountCents,
        alertThresholdPercent,
        isActive,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_budgets';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdBudgetRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('budget_month')) {
      context.handle(
          _budgetMonthMeta,
          budgetMonth.isAcceptableOrUnknown(
              data['budget_month']!, _budgetMonthMeta));
    } else if (isInserting) {
      context.missing(_budgetMonthMeta);
    }
    if (data.containsKey('budget_amount_cents')) {
      context.handle(
          _budgetAmountCentsMeta,
          budgetAmountCents.isAcceptableOrUnknown(
              data['budget_amount_cents']!, _budgetAmountCentsMeta));
    } else if (isInserting) {
      context.missing(_budgetAmountCentsMeta);
    }
    if (data.containsKey('alert_threshold_percent')) {
      context.handle(
          _alertThresholdPercentMeta,
          alertThresholdPercent.isAcceptableOrUnknown(
              data['alert_threshold_percent']!, _alertThresholdPercentMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdBudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdBudgetRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      budgetMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}budget_month'])!,
      budgetAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}budget_amount_cents'])!,
      alertThresholdPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}alert_threshold_percent'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HouseholdBudgetsTable createAlias(String alias) {
    return $HouseholdBudgetsTable(attachedDatabase, alias);
  }
}

class HouseholdBudgetRow extends DataClass
    implements Insertable<HouseholdBudgetRow> {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final DateTime budgetMonth;
  final int budgetAmountCents;
  final int alertThresholdPercent;
  final bool isActive;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const HouseholdBudgetRow(
      {required this.id,
      required this.householdId,
      required this.categoryId,
      required this.categoryName,
      required this.budgetMonth,
      required this.budgetAmountCents,
      required this.alertThresholdPercent,
      required this.isActive,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['budget_month'] = Variable<DateTime>(budgetMonth);
    map['budget_amount_cents'] = Variable<int>(budgetAmountCents);
    map['alert_threshold_percent'] = Variable<int>(alertThresholdPercent);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HouseholdBudgetsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdBudgetsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      budgetMonth: Value(budgetMonth),
      budgetAmountCents: Value(budgetAmountCents),
      alertThresholdPercent: Value(alertThresholdPercent),
      isActive: Value(isActive),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory HouseholdBudgetRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdBudgetRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      budgetMonth: serializer.fromJson<DateTime>(json['budgetMonth']),
      budgetAmountCents: serializer.fromJson<int>(json['budgetAmountCents']),
      alertThresholdPercent:
          serializer.fromJson<int>(json['alertThresholdPercent']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'budgetMonth': serializer.toJson<DateTime>(budgetMonth),
      'budgetAmountCents': serializer.toJson<int>(budgetAmountCents),
      'alertThresholdPercent': serializer.toJson<int>(alertThresholdPercent),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  HouseholdBudgetRow copyWith(
          {String? id,
          String? householdId,
          String? categoryId,
          String? categoryName,
          DateTime? budgetMonth,
          int? budgetAmountCents,
          int? alertThresholdPercent,
          bool? isActive,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      HouseholdBudgetRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        budgetMonth: budgetMonth ?? this.budgetMonth,
        budgetAmountCents: budgetAmountCents ?? this.budgetAmountCents,
        alertThresholdPercent:
            alertThresholdPercent ?? this.alertThresholdPercent,
        isActive: isActive ?? this.isActive,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  HouseholdBudgetRow copyWithCompanion(HouseholdBudgetsCompanion data) {
    return HouseholdBudgetRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      budgetMonth:
          data.budgetMonth.present ? data.budgetMonth.value : this.budgetMonth,
      budgetAmountCents: data.budgetAmountCents.present
          ? data.budgetAmountCents.value
          : this.budgetAmountCents,
      alertThresholdPercent: data.alertThresholdPercent.present
          ? data.alertThresholdPercent.value
          : this.alertThresholdPercent,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdBudgetRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('budgetMonth: $budgetMonth, ')
          ..write('budgetAmountCents: $budgetAmountCents, ')
          ..write('alertThresholdPercent: $alertThresholdPercent, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      categoryId,
      categoryName,
      budgetMonth,
      budgetAmountCents,
      alertThresholdPercent,
      isActive,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdBudgetRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.budgetMonth == this.budgetMonth &&
          other.budgetAmountCents == this.budgetAmountCents &&
          other.alertThresholdPercent == this.alertThresholdPercent &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdBudgetsCompanion extends UpdateCompanion<HouseholdBudgetRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<DateTime> budgetMonth;
  final Value<int> budgetAmountCents;
  final Value<int> alertThresholdPercent;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HouseholdBudgetsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.budgetMonth = const Value.absent(),
    this.budgetAmountCents = const Value.absent(),
    this.alertThresholdPercent = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdBudgetsCompanion.insert({
    required String id,
    required String householdId,
    required String categoryId,
    required String categoryName,
    required DateTime budgetMonth,
    required int budgetAmountCents,
    this.alertThresholdPercent = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        categoryId = Value(categoryId),
        categoryName = Value(categoryName),
        budgetMonth = Value(budgetMonth),
        budgetAmountCents = Value(budgetAmountCents),
        createdAt = Value(createdAt);
  static Insertable<HouseholdBudgetRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<DateTime>? budgetMonth,
    Expression<int>? budgetAmountCents,
    Expression<int>? alertThresholdPercent,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (budgetMonth != null) 'budget_month': budgetMonth,
      if (budgetAmountCents != null) 'budget_amount_cents': budgetAmountCents,
      if (alertThresholdPercent != null)
        'alert_threshold_percent': alertThresholdPercent,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdBudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? categoryId,
      Value<String>? categoryName,
      Value<DateTime>? budgetMonth,
      Value<int>? budgetAmountCents,
      Value<int>? alertThresholdPercent,
      Value<bool>? isActive,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdBudgetsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      budgetMonth: budgetMonth ?? this.budgetMonth,
      budgetAmountCents: budgetAmountCents ?? this.budgetAmountCents,
      alertThresholdPercent:
          alertThresholdPercent ?? this.alertThresholdPercent,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (budgetMonth.present) {
      map['budget_month'] = Variable<DateTime>(budgetMonth.value);
    }
    if (budgetAmountCents.present) {
      map['budget_amount_cents'] = Variable<int>(budgetAmountCents.value);
    }
    if (alertThresholdPercent.present) {
      map['alert_threshold_percent'] =
          Variable<int>(alertThresholdPercent.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('budgetMonth: $budgetMonth, ')
          ..write('budgetAmountCents: $budgetAmountCents, ')
          ..write('alertThresholdPercent: $alertThresholdPercent, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackedSuppliesTable extends TrackedSupplies
    with TableInfo<$TrackedSuppliesTable, TrackedSupplyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackedSuppliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyTypeMeta =
      const VerificationMeta('supplyType');
  @override
  late final GeneratedColumn<String> supplyType = GeneratedColumn<String>(
      'supply_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        categoryId,
        name,
        supplyType,
        defaultUnit,
        isActive,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracked_supplies';
  @override
  VerificationContext validateIntegrity(Insertable<TrackedSupplyRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('supply_type')) {
      context.handle(
          _supplyTypeMeta,
          supplyType.isAcceptableOrUnknown(
              data['supply_type']!, _supplyTypeMeta));
    } else if (isInserting) {
      context.missing(_supplyTypeMeta);
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    } else if (isInserting) {
      context.missing(_defaultUnitMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackedSupplyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackedSupplyRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      supplyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_type'])!,
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $TrackedSuppliesTable createAlias(String alias) {
    return $TrackedSuppliesTable(attachedDatabase, alias);
  }
}

class TrackedSupplyRow extends DataClass
    implements Insertable<TrackedSupplyRow> {
  final String id;
  final String householdId;
  final String? categoryId;
  final String name;
  final String supplyType;
  final String defaultUnit;
  final bool isActive;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const TrackedSupplyRow(
      {required this.id,
      required this.householdId,
      this.categoryId,
      required this.name,
      required this.supplyType,
      required this.defaultUnit,
      required this.isActive,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['name'] = Variable<String>(name);
    map['supply_type'] = Variable<String>(supplyType);
    map['default_unit'] = Variable<String>(defaultUnit);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TrackedSuppliesCompanion toCompanion(bool nullToAbsent) {
    return TrackedSuppliesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      name: Value(name),
      supplyType: Value(supplyType),
      defaultUnit: Value(defaultUnit),
      isActive: Value(isActive),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TrackedSupplyRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackedSupplyRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      supplyType: serializer.fromJson<String>(json['supplyType']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'name': serializer.toJson<String>(name),
      'supplyType': serializer.toJson<String>(supplyType),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TrackedSupplyRow copyWith(
          {String? id,
          String? householdId,
          Value<String?> categoryId = const Value.absent(),
          String? name,
          String? supplyType,
          String? defaultUnit,
          bool? isActive,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      TrackedSupplyRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        name: name ?? this.name,
        supplyType: supplyType ?? this.supplyType,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        isActive: isActive ?? this.isActive,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  TrackedSupplyRow copyWithCompanion(TrackedSuppliesCompanion data) {
    return TrackedSupplyRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      supplyType:
          data.supplyType.present ? data.supplyType.value : this.supplyType,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackedSupplyRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('supplyType: $supplyType, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, categoryId, name, supplyType,
      defaultUnit, isActive, version, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackedSupplyRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.supplyType == this.supplyType &&
          other.defaultUnit == this.defaultUnit &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrackedSuppliesCompanion extends UpdateCompanion<TrackedSupplyRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String?> categoryId;
  final Value<String> name;
  final Value<String> supplyType;
  final Value<String> defaultUnit;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const TrackedSuppliesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.supplyType = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackedSuppliesCompanion.insert({
    required String id,
    required String householdId,
    this.categoryId = const Value.absent(),
    required String name,
    required String supplyType,
    required String defaultUnit,
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        name = Value(name),
        supplyType = Value(supplyType),
        defaultUnit = Value(defaultUnit),
        createdAt = Value(createdAt);
  static Insertable<TrackedSupplyRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? supplyType,
    Expression<String>? defaultUnit,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (supplyType != null) 'supply_type': supplyType,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackedSuppliesCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String?>? categoryId,
      Value<String>? name,
      Value<String>? supplyType,
      Value<String>? defaultUnit,
      Value<bool>? isActive,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return TrackedSuppliesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      supplyType: supplyType ?? this.supplyType,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (supplyType.present) {
      map['supply_type'] = Variable<String>(supplyType.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackedSuppliesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('supplyType: $supplyType, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsumptionRecordsTable extends ConsumptionRecords
    with TableInfo<$ConsumptionRecordsTable, ConsumptionRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsumptionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyIdMeta =
      const VerificationMeta('supplyId');
  @override
  late final GeneratedColumn<String> supplyId = GeneratedColumn<String>(
      'supply_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyNameMeta =
      const VerificationMeta('supplyName');
  @override
  late final GeneratedColumn<String> supplyName = GeneratedColumn<String>(
      'supply_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyTypeMeta =
      const VerificationMeta('supplyType');
  @override
  late final GeneratedColumn<String> supplyType = GeneratedColumn<String>(
      'supply_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
      'expense_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountPaidCentsMeta =
      const VerificationMeta('amountPaidCents');
  @override
  late final GeneratedColumn<int> amountPaidCents = GeneratedColumn<int>(
      'amount_paid_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousExhaustedStateMeta =
      const VerificationMeta('previousExhaustedState');
  @override
  late final GeneratedColumn<String> previousExhaustedState =
      GeneratedColumn<String>('previous_exhausted_state', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('unknown'));
  static const VerificationMeta _remainingUnitsMeta =
      const VerificationMeta('remainingUnits');
  @override
  late final GeneratedColumn<double> remainingUnits = GeneratedColumn<double>(
      'remaining_units', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _remainingPercentageMeta =
      const VerificationMeta('remainingPercentage');
  @override
  late final GeneratedColumn<double> remainingPercentage =
      GeneratedColumn<double>('remaining_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cylinderWeightKgMeta =
      const VerificationMeta('cylinderWeightKg');
  @override
  late final GeneratedColumn<double> cylinderWeightKg = GeneratedColumn<double>(
      'cylinder_weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _userEstimatedDurationDaysMeta =
      const VerificationMeta('userEstimatedDurationDays');
  @override
  late final GeneratedColumn<int> userEstimatedDurationDays =
      GeneratedColumn<int>('user_estimated_duration_days', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actualDepletionDateMeta =
      const VerificationMeta('actualDepletionDate');
  @override
  late final GeneratedColumn<DateTime> actualDepletionDate =
      GeneratedColumn<DateTime>('actual_depletion_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        expenseId,
        purchaseDate,
        amountPaidCents,
        quantity,
        unit,
        previousExhaustedState,
        remainingUnits,
        remainingPercentage,
        cylinderWeightKg,
        userEstimatedDurationDays,
        actualDepletionDate,
        notes,
        recordedBy,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consumption_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConsumptionRecordRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('supply_id')) {
      context.handle(_supplyIdMeta,
          supplyId.isAcceptableOrUnknown(data['supply_id']!, _supplyIdMeta));
    } else if (isInserting) {
      context.missing(_supplyIdMeta);
    }
    if (data.containsKey('supply_name')) {
      context.handle(
          _supplyNameMeta,
          supplyName.isAcceptableOrUnknown(
              data['supply_name']!, _supplyNameMeta));
    } else if (isInserting) {
      context.missing(_supplyNameMeta);
    }
    if (data.containsKey('supply_type')) {
      context.handle(
          _supplyTypeMeta,
          supplyType.isAcceptableOrUnknown(
              data['supply_type']!, _supplyTypeMeta));
    } else if (isInserting) {
      context.missing(_supplyTypeMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('amount_paid_cents')) {
      context.handle(
          _amountPaidCentsMeta,
          amountPaidCents.isAcceptableOrUnknown(
              data['amount_paid_cents']!, _amountPaidCentsMeta));
    } else if (isInserting) {
      context.missing(_amountPaidCentsMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('previous_exhausted_state')) {
      context.handle(
          _previousExhaustedStateMeta,
          previousExhaustedState.isAcceptableOrUnknown(
              data['previous_exhausted_state']!, _previousExhaustedStateMeta));
    }
    if (data.containsKey('remaining_units')) {
      context.handle(
          _remainingUnitsMeta,
          remainingUnits.isAcceptableOrUnknown(
              data['remaining_units']!, _remainingUnitsMeta));
    }
    if (data.containsKey('remaining_percentage')) {
      context.handle(
          _remainingPercentageMeta,
          remainingPercentage.isAcceptableOrUnknown(
              data['remaining_percentage']!, _remainingPercentageMeta));
    }
    if (data.containsKey('cylinder_weight_kg')) {
      context.handle(
          _cylinderWeightKgMeta,
          cylinderWeightKg.isAcceptableOrUnknown(
              data['cylinder_weight_kg']!, _cylinderWeightKgMeta));
    }
    if (data.containsKey('user_estimated_duration_days')) {
      context.handle(
          _userEstimatedDurationDaysMeta,
          userEstimatedDurationDays.isAcceptableOrUnknown(
              data['user_estimated_duration_days']!,
              _userEstimatedDurationDaysMeta));
    }
    if (data.containsKey('actual_depletion_date')) {
      context.handle(
          _actualDepletionDateMeta,
          actualDepletionDate.isAcceptableOrUnknown(
              data['actual_depletion_date']!, _actualDepletionDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsumptionRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsumptionRecordRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      supplyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_id'])!,
      supplyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_name'])!,
      supplyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_type'])!,
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expense_id']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      amountPaidCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paid_cents'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      previousExhaustedState: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}previous_exhausted_state'])!,
      remainingUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}remaining_units']),
      remainingPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_percentage']),
      cylinderWeightKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cylinder_weight_kg']),
      userEstimatedDurationDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}user_estimated_duration_days']),
      actualDepletionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}actual_depletion_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ConsumptionRecordsTable createAlias(String alias) {
    return $ConsumptionRecordsTable(attachedDatabase, alias);
  }
}

class ConsumptionRecordRow extends DataClass
    implements Insertable<ConsumptionRecordRow> {
  final String id;
  final String householdId;
  final String supplyId;
  final String supplyName;
  final String supplyType;
  final String? expenseId;
  final DateTime purchaseDate;
  final int amountPaidCents;
  final double? quantity;
  final String unit;
  final String previousExhaustedState;
  final double? remainingUnits;
  final double? remainingPercentage;
  final double? cylinderWeightKg;
  final int? userEstimatedDurationDays;
  final DateTime? actualDepletionDate;
  final String? notes;
  final String recordedBy;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ConsumptionRecordRow(
      {required this.id,
      required this.householdId,
      required this.supplyId,
      required this.supplyName,
      required this.supplyType,
      this.expenseId,
      required this.purchaseDate,
      required this.amountPaidCents,
      this.quantity,
      required this.unit,
      required this.previousExhaustedState,
      this.remainingUnits,
      this.remainingPercentage,
      this.cylinderWeightKg,
      this.userEstimatedDurationDays,
      this.actualDepletionDate,
      this.notes,
      required this.recordedBy,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['supply_id'] = Variable<String>(supplyId);
    map['supply_name'] = Variable<String>(supplyName);
    map['supply_type'] = Variable<String>(supplyType);
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<String>(expenseId);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['amount_paid_cents'] = Variable<int>(amountPaidCents);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    map['unit'] = Variable<String>(unit);
    map['previous_exhausted_state'] = Variable<String>(previousExhaustedState);
    if (!nullToAbsent || remainingUnits != null) {
      map['remaining_units'] = Variable<double>(remainingUnits);
    }
    if (!nullToAbsent || remainingPercentage != null) {
      map['remaining_percentage'] = Variable<double>(remainingPercentage);
    }
    if (!nullToAbsent || cylinderWeightKg != null) {
      map['cylinder_weight_kg'] = Variable<double>(cylinderWeightKg);
    }
    if (!nullToAbsent || userEstimatedDurationDays != null) {
      map['user_estimated_duration_days'] =
          Variable<int>(userEstimatedDurationDays);
    }
    if (!nullToAbsent || actualDepletionDate != null) {
      map['actual_depletion_date'] = Variable<DateTime>(actualDepletionDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_by'] = Variable<String>(recordedBy);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ConsumptionRecordsCompanion toCompanion(bool nullToAbsent) {
    return ConsumptionRecordsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      supplyId: Value(supplyId),
      supplyName: Value(supplyName),
      supplyType: Value(supplyType),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      purchaseDate: Value(purchaseDate),
      amountPaidCents: Value(amountPaidCents),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: Value(unit),
      previousExhaustedState: Value(previousExhaustedState),
      remainingUnits: remainingUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingUnits),
      remainingPercentage: remainingPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingPercentage),
      cylinderWeightKg: cylinderWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(cylinderWeightKg),
      userEstimatedDurationDays:
          userEstimatedDurationDays == null && nullToAbsent
              ? const Value.absent()
              : Value(userEstimatedDurationDays),
      actualDepletionDate: actualDepletionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDepletionDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      recordedBy: Value(recordedBy),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ConsumptionRecordRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsumptionRecordRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      supplyId: serializer.fromJson<String>(json['supplyId']),
      supplyName: serializer.fromJson<String>(json['supplyName']),
      supplyType: serializer.fromJson<String>(json['supplyType']),
      expenseId: serializer.fromJson<String?>(json['expenseId']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      amountPaidCents: serializer.fromJson<int>(json['amountPaidCents']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      previousExhaustedState:
          serializer.fromJson<String>(json['previousExhaustedState']),
      remainingUnits: serializer.fromJson<double?>(json['remainingUnits']),
      remainingPercentage:
          serializer.fromJson<double?>(json['remainingPercentage']),
      cylinderWeightKg: serializer.fromJson<double?>(json['cylinderWeightKg']),
      userEstimatedDurationDays:
          serializer.fromJson<int?>(json['userEstimatedDurationDays']),
      actualDepletionDate:
          serializer.fromJson<DateTime?>(json['actualDepletionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'supplyId': serializer.toJson<String>(supplyId),
      'supplyName': serializer.toJson<String>(supplyName),
      'supplyType': serializer.toJson<String>(supplyType),
      'expenseId': serializer.toJson<String?>(expenseId),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'amountPaidCents': serializer.toJson<int>(amountPaidCents),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String>(unit),
      'previousExhaustedState':
          serializer.toJson<String>(previousExhaustedState),
      'remainingUnits': serializer.toJson<double?>(remainingUnits),
      'remainingPercentage': serializer.toJson<double?>(remainingPercentage),
      'cylinderWeightKg': serializer.toJson<double?>(cylinderWeightKg),
      'userEstimatedDurationDays':
          serializer.toJson<int?>(userEstimatedDurationDays),
      'actualDepletionDate': serializer.toJson<DateTime?>(actualDepletionDate),
      'notes': serializer.toJson<String?>(notes),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ConsumptionRecordRow copyWith(
          {String? id,
          String? householdId,
          String? supplyId,
          String? supplyName,
          String? supplyType,
          Value<String?> expenseId = const Value.absent(),
          DateTime? purchaseDate,
          int? amountPaidCents,
          Value<double?> quantity = const Value.absent(),
          String? unit,
          String? previousExhaustedState,
          Value<double?> remainingUnits = const Value.absent(),
          Value<double?> remainingPercentage = const Value.absent(),
          Value<double?> cylinderWeightKg = const Value.absent(),
          Value<int?> userEstimatedDurationDays = const Value.absent(),
          Value<DateTime?> actualDepletionDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? recordedBy,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      ConsumptionRecordRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        supplyId: supplyId ?? this.supplyId,
        supplyName: supplyName ?? this.supplyName,
        supplyType: supplyType ?? this.supplyType,
        expenseId: expenseId.present ? expenseId.value : this.expenseId,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        amountPaidCents: amountPaidCents ?? this.amountPaidCents,
        quantity: quantity.present ? quantity.value : this.quantity,
        unit: unit ?? this.unit,
        previousExhaustedState:
            previousExhaustedState ?? this.previousExhaustedState,
        remainingUnits:
            remainingUnits.present ? remainingUnits.value : this.remainingUnits,
        remainingPercentage: remainingPercentage.present
            ? remainingPercentage.value
            : this.remainingPercentage,
        cylinderWeightKg: cylinderWeightKg.present
            ? cylinderWeightKg.value
            : this.cylinderWeightKg,
        userEstimatedDurationDays: userEstimatedDurationDays.present
            ? userEstimatedDurationDays.value
            : this.userEstimatedDurationDays,
        actualDepletionDate: actualDepletionDate.present
            ? actualDepletionDate.value
            : this.actualDepletionDate,
        notes: notes.present ? notes.value : this.notes,
        recordedBy: recordedBy ?? this.recordedBy,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ConsumptionRecordRow copyWithCompanion(ConsumptionRecordsCompanion data) {
    return ConsumptionRecordRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      supplyId: data.supplyId.present ? data.supplyId.value : this.supplyId,
      supplyName:
          data.supplyName.present ? data.supplyName.value : this.supplyName,
      supplyType:
          data.supplyType.present ? data.supplyType.value : this.supplyType,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      amountPaidCents: data.amountPaidCents.present
          ? data.amountPaidCents.value
          : this.amountPaidCents,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      previousExhaustedState: data.previousExhaustedState.present
          ? data.previousExhaustedState.value
          : this.previousExhaustedState,
      remainingUnits: data.remainingUnits.present
          ? data.remainingUnits.value
          : this.remainingUnits,
      remainingPercentage: data.remainingPercentage.present
          ? data.remainingPercentage.value
          : this.remainingPercentage,
      cylinderWeightKg: data.cylinderWeightKg.present
          ? data.cylinderWeightKg.value
          : this.cylinderWeightKg,
      userEstimatedDurationDays: data.userEstimatedDurationDays.present
          ? data.userEstimatedDurationDays.value
          : this.userEstimatedDurationDays,
      actualDepletionDate: data.actualDepletionDate.present
          ? data.actualDepletionDate.value
          : this.actualDepletionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsumptionRecordRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('supplyId: $supplyId, ')
          ..write('supplyName: $supplyName, ')
          ..write('supplyType: $supplyType, ')
          ..write('expenseId: $expenseId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('amountPaidCents: $amountPaidCents, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('previousExhaustedState: $previousExhaustedState, ')
          ..write('remainingUnits: $remainingUnits, ')
          ..write('remainingPercentage: $remainingPercentage, ')
          ..write('cylinderWeightKg: $cylinderWeightKg, ')
          ..write('userEstimatedDurationDays: $userEstimatedDurationDays, ')
          ..write('actualDepletionDate: $actualDepletionDate, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        expenseId,
        purchaseDate,
        amountPaidCents,
        quantity,
        unit,
        previousExhaustedState,
        remainingUnits,
        remainingPercentage,
        cylinderWeightKg,
        userEstimatedDurationDays,
        actualDepletionDate,
        notes,
        recordedBy,
        version,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsumptionRecordRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.supplyId == this.supplyId &&
          other.supplyName == this.supplyName &&
          other.supplyType == this.supplyType &&
          other.expenseId == this.expenseId &&
          other.purchaseDate == this.purchaseDate &&
          other.amountPaidCents == this.amountPaidCents &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.previousExhaustedState == this.previousExhaustedState &&
          other.remainingUnits == this.remainingUnits &&
          other.remainingPercentage == this.remainingPercentage &&
          other.cylinderWeightKg == this.cylinderWeightKg &&
          other.userEstimatedDurationDays == this.userEstimatedDurationDays &&
          other.actualDepletionDate == this.actualDepletionDate &&
          other.notes == this.notes &&
          other.recordedBy == this.recordedBy &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConsumptionRecordsCompanion
    extends UpdateCompanion<ConsumptionRecordRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> supplyId;
  final Value<String> supplyName;
  final Value<String> supplyType;
  final Value<String?> expenseId;
  final Value<DateTime> purchaseDate;
  final Value<int> amountPaidCents;
  final Value<double?> quantity;
  final Value<String> unit;
  final Value<String> previousExhaustedState;
  final Value<double?> remainingUnits;
  final Value<double?> remainingPercentage;
  final Value<double?> cylinderWeightKg;
  final Value<int?> userEstimatedDurationDays;
  final Value<DateTime?> actualDepletionDate;
  final Value<String?> notes;
  final Value<String> recordedBy;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ConsumptionRecordsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.supplyId = const Value.absent(),
    this.supplyName = const Value.absent(),
    this.supplyType = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.amountPaidCents = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.previousExhaustedState = const Value.absent(),
    this.remainingUnits = const Value.absent(),
    this.remainingPercentage = const Value.absent(),
    this.cylinderWeightKg = const Value.absent(),
    this.userEstimatedDurationDays = const Value.absent(),
    this.actualDepletionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsumptionRecordsCompanion.insert({
    required String id,
    required String householdId,
    required String supplyId,
    required String supplyName,
    required String supplyType,
    this.expenseId = const Value.absent(),
    required DateTime purchaseDate,
    required int amountPaidCents,
    this.quantity = const Value.absent(),
    required String unit,
    this.previousExhaustedState = const Value.absent(),
    this.remainingUnits = const Value.absent(),
    this.remainingPercentage = const Value.absent(),
    this.cylinderWeightKg = const Value.absent(),
    this.userEstimatedDurationDays = const Value.absent(),
    this.actualDepletionDate = const Value.absent(),
    this.notes = const Value.absent(),
    required String recordedBy,
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        supplyId = Value(supplyId),
        supplyName = Value(supplyName),
        supplyType = Value(supplyType),
        purchaseDate = Value(purchaseDate),
        amountPaidCents = Value(amountPaidCents),
        unit = Value(unit),
        recordedBy = Value(recordedBy),
        createdAt = Value(createdAt);
  static Insertable<ConsumptionRecordRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? supplyId,
    Expression<String>? supplyName,
    Expression<String>? supplyType,
    Expression<String>? expenseId,
    Expression<DateTime>? purchaseDate,
    Expression<int>? amountPaidCents,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? previousExhaustedState,
    Expression<double>? remainingUnits,
    Expression<double>? remainingPercentage,
    Expression<double>? cylinderWeightKg,
    Expression<int>? userEstimatedDurationDays,
    Expression<DateTime>? actualDepletionDate,
    Expression<String>? notes,
    Expression<String>? recordedBy,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (supplyId != null) 'supply_id': supplyId,
      if (supplyName != null) 'supply_name': supplyName,
      if (supplyType != null) 'supply_type': supplyType,
      if (expenseId != null) 'expense_id': expenseId,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (amountPaidCents != null) 'amount_paid_cents': amountPaidCents,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (previousExhaustedState != null)
        'previous_exhausted_state': previousExhaustedState,
      if (remainingUnits != null) 'remaining_units': remainingUnits,
      if (remainingPercentage != null)
        'remaining_percentage': remainingPercentage,
      if (cylinderWeightKg != null) 'cylinder_weight_kg': cylinderWeightKg,
      if (userEstimatedDurationDays != null)
        'user_estimated_duration_days': userEstimatedDurationDays,
      if (actualDepletionDate != null)
        'actual_depletion_date': actualDepletionDate,
      if (notes != null) 'notes': notes,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsumptionRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? supplyId,
      Value<String>? supplyName,
      Value<String>? supplyType,
      Value<String?>? expenseId,
      Value<DateTime>? purchaseDate,
      Value<int>? amountPaidCents,
      Value<double?>? quantity,
      Value<String>? unit,
      Value<String>? previousExhaustedState,
      Value<double?>? remainingUnits,
      Value<double?>? remainingPercentage,
      Value<double?>? cylinderWeightKg,
      Value<int?>? userEstimatedDurationDays,
      Value<DateTime?>? actualDepletionDate,
      Value<String?>? notes,
      Value<String>? recordedBy,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return ConsumptionRecordsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      supplyId: supplyId ?? this.supplyId,
      supplyName: supplyName ?? this.supplyName,
      supplyType: supplyType ?? this.supplyType,
      expenseId: expenseId ?? this.expenseId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      amountPaidCents: amountPaidCents ?? this.amountPaidCents,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      previousExhaustedState:
          previousExhaustedState ?? this.previousExhaustedState,
      remainingUnits: remainingUnits ?? this.remainingUnits,
      remainingPercentage: remainingPercentage ?? this.remainingPercentage,
      cylinderWeightKg: cylinderWeightKg ?? this.cylinderWeightKg,
      userEstimatedDurationDays:
          userEstimatedDurationDays ?? this.userEstimatedDurationDays,
      actualDepletionDate: actualDepletionDate ?? this.actualDepletionDate,
      notes: notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (supplyId.present) {
      map['supply_id'] = Variable<String>(supplyId.value);
    }
    if (supplyName.present) {
      map['supply_name'] = Variable<String>(supplyName.value);
    }
    if (supplyType.present) {
      map['supply_type'] = Variable<String>(supplyType.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (amountPaidCents.present) {
      map['amount_paid_cents'] = Variable<int>(amountPaidCents.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (previousExhaustedState.present) {
      map['previous_exhausted_state'] =
          Variable<String>(previousExhaustedState.value);
    }
    if (remainingUnits.present) {
      map['remaining_units'] = Variable<double>(remainingUnits.value);
    }
    if (remainingPercentage.present) {
      map['remaining_percentage'] = Variable<double>(remainingPercentage.value);
    }
    if (cylinderWeightKg.present) {
      map['cylinder_weight_kg'] = Variable<double>(cylinderWeightKg.value);
    }
    if (userEstimatedDurationDays.present) {
      map['user_estimated_duration_days'] =
          Variable<int>(userEstimatedDurationDays.value);
    }
    if (actualDepletionDate.present) {
      map['actual_depletion_date'] =
          Variable<DateTime>(actualDepletionDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsumptionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('supplyId: $supplyId, ')
          ..write('supplyName: $supplyName, ')
          ..write('supplyType: $supplyType, ')
          ..write('expenseId: $expenseId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('amountPaidCents: $amountPaidCents, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('previousExhaustedState: $previousExhaustedState, ')
          ..write('remainingUnits: $remainingUnits, ')
          ..write('remainingPercentage: $remainingPercentage, ')
          ..write('cylinderWeightKg: $cylinderWeightKg, ')
          ..write('userEstimatedDurationDays: $userEstimatedDurationDays, ')
          ..write('actualDepletionDate: $actualDepletionDate, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplyPredictionsTable extends SupplyPredictions
    with TableInfo<$SupplyPredictionsTable, SupplyPredictionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplyPredictionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyIdMeta =
      const VerificationMeta('supplyId');
  @override
  late final GeneratedColumn<String> supplyId = GeneratedColumn<String>(
      'supply_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _supplyNameMeta =
      const VerificationMeta('supplyName');
  @override
  late final GeneratedColumn<String> supplyName = GeneratedColumn<String>(
      'supply_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplyTypeMeta =
      const VerificationMeta('supplyType');
  @override
  late final GeneratedColumn<String> supplyType = GeneratedColumn<String>(
      'supply_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sampleCountMeta =
      const VerificationMeta('sampleCount');
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
      'sample_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _confirmedCycleCountMeta =
      const VerificationMeta('confirmedCycleCount');
  @override
  late final GeneratedColumn<int> confirmedCycleCount = GeneratedColumn<int>(
      'confirmed_cycle_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _averageIntervalDaysMeta =
      const VerificationMeta('averageIntervalDays');
  @override
  late final GeneratedColumn<double> averageIntervalDays =
      GeneratedColumn<double>('average_interval_days', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _medianIntervalDaysMeta =
      const VerificationMeta('medianIntervalDays');
  @override
  late final GeneratedColumn<double> medianIntervalDays =
      GeneratedColumn<double>('median_interval_days', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _weightedIntervalDaysMeta =
      const VerificationMeta('weightedIntervalDays');
  @override
  late final GeneratedColumn<double> weightedIntervalDays =
      GeneratedColumn<double>('weighted_interval_days', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _intervalStdDevDaysMeta =
      const VerificationMeta('intervalStdDevDays');
  @override
  late final GeneratedColumn<double> intervalStdDevDays =
      GeneratedColumn<double>('interval_std_dev_days', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _averagePurchaseAmountCentsMeta =
      const VerificationMeta('averagePurchaseAmountCents');
  @override
  late final GeneratedColumn<int> averagePurchaseAmountCents =
      GeneratedColumn<int>('average_purchase_amount_cents', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _averageDailyConsumptionUnitsMeta =
      const VerificationMeta('averageDailyConsumptionUnits');
  @override
  late final GeneratedColumn<double> averageDailyConsumptionUnits =
      GeneratedColumn<double>(
          'average_daily_consumption_units', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _averageDailyCostCentsMeta =
      const VerificationMeta('averageDailyCostCents');
  @override
  late final GeneratedColumn<int> averageDailyCostCents = GeneratedColumn<int>(
      'average_daily_cost_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastPurchaseDateMeta =
      const VerificationMeta('lastPurchaseDate');
  @override
  late final GeneratedColumn<DateTime> lastPurchaseDate =
      GeneratedColumn<DateTime>('last_purchase_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _estimatedNextReplenishmentDateMeta =
      const VerificationMeta('estimatedNextReplenishmentDate');
  @override
  late final GeneratedColumn<DateTime> estimatedNextReplenishmentDate =
      GeneratedColumn<DateTime>(
          'estimated_next_replenishment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _manualOverrideDateMeta =
      const VerificationMeta('manualOverrideDate');
  @override
  late final GeneratedColumn<DateTime> manualOverrideDate =
      GeneratedColumn<DateTime>('manual_override_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actualConfirmedDepletionDateMeta =
      const VerificationMeta('actualConfirmedDepletionDate');
  @override
  late final GeneratedColumn<DateTime> actualConfirmedDepletionDate =
      GeneratedColumn<DateTime>(
          'actual_confirmed_depletion_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _confidenceLevelMeta =
      const VerificationMeta('confidenceLevel');
  @override
  late final GeneratedColumn<String> confidenceLevel = GeneratedColumn<String>(
      'confidence_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('insufficientData'));
  static const VerificationMeta _confidenceScoreMeta =
      const VerificationMeta('confidenceScore');
  @override
  late final GeneratedColumn<int> confidenceScore = GeneratedColumn<int>(
      'confidence_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isMonetaryEstimateOnlyMeta =
      const VerificationMeta('isMonetaryEstimateOnly');
  @override
  late final GeneratedColumn<bool> isMonetaryEstimateOnly =
      GeneratedColumn<bool>('is_monetary_estimate_only', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("is_monetary_estimate_only" IN (0, 1))'),
          defaultValue: const Constant(true));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trendDirectionMeta =
      const VerificationMeta('trendDirection');
  @override
  late final GeneratedColumn<String> trendDirection = GeneratedColumn<String>(
      'trend_direction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('stable'));
  static const VerificationMeta _historicalIntervalsJsonMeta =
      const VerificationMeta('historicalIntervalsJson');
  @override
  late final GeneratedColumn<String> historicalIntervalsJson =
      GeneratedColumn<String>('historical_intervals_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        unit,
        sampleCount,
        confirmedCycleCount,
        averageIntervalDays,
        medianIntervalDays,
        weightedIntervalDays,
        intervalStdDevDays,
        averagePurchaseAmountCents,
        averageDailyConsumptionUnits,
        averageDailyCostCents,
        lastPurchaseDate,
        estimatedNextReplenishmentDate,
        manualOverrideDate,
        actualConfirmedDepletionDate,
        confidenceLevel,
        confidenceScore,
        isMonetaryEstimateOnly,
        explanation,
        trendDirection,
        historicalIntervalsJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supply_predictions';
  @override
  VerificationContext validateIntegrity(
      Insertable<SupplyPredictionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('supply_id')) {
      context.handle(_supplyIdMeta,
          supplyId.isAcceptableOrUnknown(data['supply_id']!, _supplyIdMeta));
    } else if (isInserting) {
      context.missing(_supplyIdMeta);
    }
    if (data.containsKey('supply_name')) {
      context.handle(
          _supplyNameMeta,
          supplyName.isAcceptableOrUnknown(
              data['supply_name']!, _supplyNameMeta));
    } else if (isInserting) {
      context.missing(_supplyNameMeta);
    }
    if (data.containsKey('supply_type')) {
      context.handle(
          _supplyTypeMeta,
          supplyType.isAcceptableOrUnknown(
              data['supply_type']!, _supplyTypeMeta));
    } else if (isInserting) {
      context.missing(_supplyTypeMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('sample_count')) {
      context.handle(
          _sampleCountMeta,
          sampleCount.isAcceptableOrUnknown(
              data['sample_count']!, _sampleCountMeta));
    }
    if (data.containsKey('confirmed_cycle_count')) {
      context.handle(
          _confirmedCycleCountMeta,
          confirmedCycleCount.isAcceptableOrUnknown(
              data['confirmed_cycle_count']!, _confirmedCycleCountMeta));
    }
    if (data.containsKey('average_interval_days')) {
      context.handle(
          _averageIntervalDaysMeta,
          averageIntervalDays.isAcceptableOrUnknown(
              data['average_interval_days']!, _averageIntervalDaysMeta));
    }
    if (data.containsKey('median_interval_days')) {
      context.handle(
          _medianIntervalDaysMeta,
          medianIntervalDays.isAcceptableOrUnknown(
              data['median_interval_days']!, _medianIntervalDaysMeta));
    }
    if (data.containsKey('weighted_interval_days')) {
      context.handle(
          _weightedIntervalDaysMeta,
          weightedIntervalDays.isAcceptableOrUnknown(
              data['weighted_interval_days']!, _weightedIntervalDaysMeta));
    }
    if (data.containsKey('interval_std_dev_days')) {
      context.handle(
          _intervalStdDevDaysMeta,
          intervalStdDevDays.isAcceptableOrUnknown(
              data['interval_std_dev_days']!, _intervalStdDevDaysMeta));
    }
    if (data.containsKey('average_purchase_amount_cents')) {
      context.handle(
          _averagePurchaseAmountCentsMeta,
          averagePurchaseAmountCents.isAcceptableOrUnknown(
              data['average_purchase_amount_cents']!,
              _averagePurchaseAmountCentsMeta));
    }
    if (data.containsKey('average_daily_consumption_units')) {
      context.handle(
          _averageDailyConsumptionUnitsMeta,
          averageDailyConsumptionUnits.isAcceptableOrUnknown(
              data['average_daily_consumption_units']!,
              _averageDailyConsumptionUnitsMeta));
    }
    if (data.containsKey('average_daily_cost_cents')) {
      context.handle(
          _averageDailyCostCentsMeta,
          averageDailyCostCents.isAcceptableOrUnknown(
              data['average_daily_cost_cents']!, _averageDailyCostCentsMeta));
    }
    if (data.containsKey('last_purchase_date')) {
      context.handle(
          _lastPurchaseDateMeta,
          lastPurchaseDate.isAcceptableOrUnknown(
              data['last_purchase_date']!, _lastPurchaseDateMeta));
    }
    if (data.containsKey('estimated_next_replenishment_date')) {
      context.handle(
          _estimatedNextReplenishmentDateMeta,
          estimatedNextReplenishmentDate.isAcceptableOrUnknown(
              data['estimated_next_replenishment_date']!,
              _estimatedNextReplenishmentDateMeta));
    }
    if (data.containsKey('manual_override_date')) {
      context.handle(
          _manualOverrideDateMeta,
          manualOverrideDate.isAcceptableOrUnknown(
              data['manual_override_date']!, _manualOverrideDateMeta));
    }
    if (data.containsKey('actual_confirmed_depletion_date')) {
      context.handle(
          _actualConfirmedDepletionDateMeta,
          actualConfirmedDepletionDate.isAcceptableOrUnknown(
              data['actual_confirmed_depletion_date']!,
              _actualConfirmedDepletionDateMeta));
    }
    if (data.containsKey('confidence_level')) {
      context.handle(
          _confidenceLevelMeta,
          confidenceLevel.isAcceptableOrUnknown(
              data['confidence_level']!, _confidenceLevelMeta));
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
          _confidenceScoreMeta,
          confidenceScore.isAcceptableOrUnknown(
              data['confidence_score']!, _confidenceScoreMeta));
    }
    if (data.containsKey('is_monetary_estimate_only')) {
      context.handle(
          _isMonetaryEstimateOnlyMeta,
          isMonetaryEstimateOnly.isAcceptableOrUnknown(
              data['is_monetary_estimate_only']!, _isMonetaryEstimateOnlyMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('trend_direction')) {
      context.handle(
          _trendDirectionMeta,
          trendDirection.isAcceptableOrUnknown(
              data['trend_direction']!, _trendDirectionMeta));
    }
    if (data.containsKey('historical_intervals_json')) {
      context.handle(
          _historicalIntervalsJsonMeta,
          historicalIntervalsJson.isAcceptableOrUnknown(
              data['historical_intervals_json']!,
              _historicalIntervalsJsonMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplyPredictionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplyPredictionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      supplyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_id'])!,
      supplyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_name'])!,
      supplyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supply_type'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      sampleCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sample_count'])!,
      confirmedCycleCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}confirmed_cycle_count'])!,
      averageIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}average_interval_days']),
      medianIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}median_interval_days']),
      weightedIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}weighted_interval_days']),
      intervalStdDevDays: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}interval_std_dev_days']),
      averagePurchaseAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}average_purchase_amount_cents']),
      averageDailyConsumptionUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}average_daily_consumption_units']),
      averageDailyCostCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}average_daily_cost_cents']),
      lastPurchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_purchase_date']),
      estimatedNextReplenishmentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}estimated_next_replenishment_date']),
      manualOverrideDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}manual_override_date']),
      actualConfirmedDepletionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}actual_confirmed_depletion_date']),
      confidenceLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}confidence_level'])!,
      confidenceScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}confidence_score'])!,
      isMonetaryEstimateOnly: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}is_monetary_estimate_only'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      trendDirection: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}trend_direction'])!,
      historicalIntervalsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}historical_intervals_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SupplyPredictionsTable createAlias(String alias) {
    return $SupplyPredictionsTable(attachedDatabase, alias);
  }
}

class SupplyPredictionRow extends DataClass
    implements Insertable<SupplyPredictionRow> {
  final String id;
  final String householdId;
  final String supplyId;
  final String supplyName;
  final String supplyType;
  final String unit;
  final int sampleCount;
  final int confirmedCycleCount;
  final double? averageIntervalDays;
  final double? medianIntervalDays;
  final double? weightedIntervalDays;
  final double? intervalStdDevDays;
  final int? averagePurchaseAmountCents;
  final double? averageDailyConsumptionUnits;
  final int? averageDailyCostCents;
  final DateTime? lastPurchaseDate;
  final DateTime? estimatedNextReplenishmentDate;
  final DateTime? manualOverrideDate;
  final DateTime? actualConfirmedDepletionDate;
  final String confidenceLevel;
  final int confidenceScore;
  final bool isMonetaryEstimateOnly;
  final String explanation;
  final String trendDirection;
  final String historicalIntervalsJson;
  final DateTime updatedAt;
  const SupplyPredictionRow(
      {required this.id,
      required this.householdId,
      required this.supplyId,
      required this.supplyName,
      required this.supplyType,
      required this.unit,
      required this.sampleCount,
      required this.confirmedCycleCount,
      this.averageIntervalDays,
      this.medianIntervalDays,
      this.weightedIntervalDays,
      this.intervalStdDevDays,
      this.averagePurchaseAmountCents,
      this.averageDailyConsumptionUnits,
      this.averageDailyCostCents,
      this.lastPurchaseDate,
      this.estimatedNextReplenishmentDate,
      this.manualOverrideDate,
      this.actualConfirmedDepletionDate,
      required this.confidenceLevel,
      required this.confidenceScore,
      required this.isMonetaryEstimateOnly,
      required this.explanation,
      required this.trendDirection,
      required this.historicalIntervalsJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['supply_id'] = Variable<String>(supplyId);
    map['supply_name'] = Variable<String>(supplyName);
    map['supply_type'] = Variable<String>(supplyType);
    map['unit'] = Variable<String>(unit);
    map['sample_count'] = Variable<int>(sampleCount);
    map['confirmed_cycle_count'] = Variable<int>(confirmedCycleCount);
    if (!nullToAbsent || averageIntervalDays != null) {
      map['average_interval_days'] = Variable<double>(averageIntervalDays);
    }
    if (!nullToAbsent || medianIntervalDays != null) {
      map['median_interval_days'] = Variable<double>(medianIntervalDays);
    }
    if (!nullToAbsent || weightedIntervalDays != null) {
      map['weighted_interval_days'] = Variable<double>(weightedIntervalDays);
    }
    if (!nullToAbsent || intervalStdDevDays != null) {
      map['interval_std_dev_days'] = Variable<double>(intervalStdDevDays);
    }
    if (!nullToAbsent || averagePurchaseAmountCents != null) {
      map['average_purchase_amount_cents'] =
          Variable<int>(averagePurchaseAmountCents);
    }
    if (!nullToAbsent || averageDailyConsumptionUnits != null) {
      map['average_daily_consumption_units'] =
          Variable<double>(averageDailyConsumptionUnits);
    }
    if (!nullToAbsent || averageDailyCostCents != null) {
      map['average_daily_cost_cents'] = Variable<int>(averageDailyCostCents);
    }
    if (!nullToAbsent || lastPurchaseDate != null) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate);
    }
    if (!nullToAbsent || estimatedNextReplenishmentDate != null) {
      map['estimated_next_replenishment_date'] =
          Variable<DateTime>(estimatedNextReplenishmentDate);
    }
    if (!nullToAbsent || manualOverrideDate != null) {
      map['manual_override_date'] = Variable<DateTime>(manualOverrideDate);
    }
    if (!nullToAbsent || actualConfirmedDepletionDate != null) {
      map['actual_confirmed_depletion_date'] =
          Variable<DateTime>(actualConfirmedDepletionDate);
    }
    map['confidence_level'] = Variable<String>(confidenceLevel);
    map['confidence_score'] = Variable<int>(confidenceScore);
    map['is_monetary_estimate_only'] = Variable<bool>(isMonetaryEstimateOnly);
    map['explanation'] = Variable<String>(explanation);
    map['trend_direction'] = Variable<String>(trendDirection);
    map['historical_intervals_json'] =
        Variable<String>(historicalIntervalsJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SupplyPredictionsCompanion toCompanion(bool nullToAbsent) {
    return SupplyPredictionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      supplyId: Value(supplyId),
      supplyName: Value(supplyName),
      supplyType: Value(supplyType),
      unit: Value(unit),
      sampleCount: Value(sampleCount),
      confirmedCycleCount: Value(confirmedCycleCount),
      averageIntervalDays: averageIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(averageIntervalDays),
      medianIntervalDays: medianIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(medianIntervalDays),
      weightedIntervalDays: weightedIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(weightedIntervalDays),
      intervalStdDevDays: intervalStdDevDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalStdDevDays),
      averagePurchaseAmountCents:
          averagePurchaseAmountCents == null && nullToAbsent
              ? const Value.absent()
              : Value(averagePurchaseAmountCents),
      averageDailyConsumptionUnits:
          averageDailyConsumptionUnits == null && nullToAbsent
              ? const Value.absent()
              : Value(averageDailyConsumptionUnits),
      averageDailyCostCents: averageDailyCostCents == null && nullToAbsent
          ? const Value.absent()
          : Value(averageDailyCostCents),
      lastPurchaseDate: lastPurchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchaseDate),
      estimatedNextReplenishmentDate:
          estimatedNextReplenishmentDate == null && nullToAbsent
              ? const Value.absent()
              : Value(estimatedNextReplenishmentDate),
      manualOverrideDate: manualOverrideDate == null && nullToAbsent
          ? const Value.absent()
          : Value(manualOverrideDate),
      actualConfirmedDepletionDate:
          actualConfirmedDepletionDate == null && nullToAbsent
              ? const Value.absent()
              : Value(actualConfirmedDepletionDate),
      confidenceLevel: Value(confidenceLevel),
      confidenceScore: Value(confidenceScore),
      isMonetaryEstimateOnly: Value(isMonetaryEstimateOnly),
      explanation: Value(explanation),
      trendDirection: Value(trendDirection),
      historicalIntervalsJson: Value(historicalIntervalsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory SupplyPredictionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplyPredictionRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      supplyId: serializer.fromJson<String>(json['supplyId']),
      supplyName: serializer.fromJson<String>(json['supplyName']),
      supplyType: serializer.fromJson<String>(json['supplyType']),
      unit: serializer.fromJson<String>(json['unit']),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      confirmedCycleCount:
          serializer.fromJson<int>(json['confirmedCycleCount']),
      averageIntervalDays:
          serializer.fromJson<double?>(json['averageIntervalDays']),
      medianIntervalDays:
          serializer.fromJson<double?>(json['medianIntervalDays']),
      weightedIntervalDays:
          serializer.fromJson<double?>(json['weightedIntervalDays']),
      intervalStdDevDays:
          serializer.fromJson<double?>(json['intervalStdDevDays']),
      averagePurchaseAmountCents:
          serializer.fromJson<int?>(json['averagePurchaseAmountCents']),
      averageDailyConsumptionUnits:
          serializer.fromJson<double?>(json['averageDailyConsumptionUnits']),
      averageDailyCostCents:
          serializer.fromJson<int?>(json['averageDailyCostCents']),
      lastPurchaseDate:
          serializer.fromJson<DateTime?>(json['lastPurchaseDate']),
      estimatedNextReplenishmentDate: serializer
          .fromJson<DateTime?>(json['estimatedNextReplenishmentDate']),
      manualOverrideDate:
          serializer.fromJson<DateTime?>(json['manualOverrideDate']),
      actualConfirmedDepletionDate:
          serializer.fromJson<DateTime?>(json['actualConfirmedDepletionDate']),
      confidenceLevel: serializer.fromJson<String>(json['confidenceLevel']),
      confidenceScore: serializer.fromJson<int>(json['confidenceScore']),
      isMonetaryEstimateOnly:
          serializer.fromJson<bool>(json['isMonetaryEstimateOnly']),
      explanation: serializer.fromJson<String>(json['explanation']),
      trendDirection: serializer.fromJson<String>(json['trendDirection']),
      historicalIntervalsJson:
          serializer.fromJson<String>(json['historicalIntervalsJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'supplyId': serializer.toJson<String>(supplyId),
      'supplyName': serializer.toJson<String>(supplyName),
      'supplyType': serializer.toJson<String>(supplyType),
      'unit': serializer.toJson<String>(unit),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'confirmedCycleCount': serializer.toJson<int>(confirmedCycleCount),
      'averageIntervalDays': serializer.toJson<double?>(averageIntervalDays),
      'medianIntervalDays': serializer.toJson<double?>(medianIntervalDays),
      'weightedIntervalDays': serializer.toJson<double?>(weightedIntervalDays),
      'intervalStdDevDays': serializer.toJson<double?>(intervalStdDevDays),
      'averagePurchaseAmountCents':
          serializer.toJson<int?>(averagePurchaseAmountCents),
      'averageDailyConsumptionUnits':
          serializer.toJson<double?>(averageDailyConsumptionUnits),
      'averageDailyCostCents': serializer.toJson<int?>(averageDailyCostCents),
      'lastPurchaseDate': serializer.toJson<DateTime?>(lastPurchaseDate),
      'estimatedNextReplenishmentDate':
          serializer.toJson<DateTime?>(estimatedNextReplenishmentDate),
      'manualOverrideDate': serializer.toJson<DateTime?>(manualOverrideDate),
      'actualConfirmedDepletionDate':
          serializer.toJson<DateTime?>(actualConfirmedDepletionDate),
      'confidenceLevel': serializer.toJson<String>(confidenceLevel),
      'confidenceScore': serializer.toJson<int>(confidenceScore),
      'isMonetaryEstimateOnly': serializer.toJson<bool>(isMonetaryEstimateOnly),
      'explanation': serializer.toJson<String>(explanation),
      'trendDirection': serializer.toJson<String>(trendDirection),
      'historicalIntervalsJson':
          serializer.toJson<String>(historicalIntervalsJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SupplyPredictionRow copyWith(
          {String? id,
          String? householdId,
          String? supplyId,
          String? supplyName,
          String? supplyType,
          String? unit,
          int? sampleCount,
          int? confirmedCycleCount,
          Value<double?> averageIntervalDays = const Value.absent(),
          Value<double?> medianIntervalDays = const Value.absent(),
          Value<double?> weightedIntervalDays = const Value.absent(),
          Value<double?> intervalStdDevDays = const Value.absent(),
          Value<int?> averagePurchaseAmountCents = const Value.absent(),
          Value<double?> averageDailyConsumptionUnits = const Value.absent(),
          Value<int?> averageDailyCostCents = const Value.absent(),
          Value<DateTime?> lastPurchaseDate = const Value.absent(),
          Value<DateTime?> estimatedNextReplenishmentDate =
              const Value.absent(),
          Value<DateTime?> manualOverrideDate = const Value.absent(),
          Value<DateTime?> actualConfirmedDepletionDate = const Value.absent(),
          String? confidenceLevel,
          int? confidenceScore,
          bool? isMonetaryEstimateOnly,
          String? explanation,
          String? trendDirection,
          String? historicalIntervalsJson,
          DateTime? updatedAt}) =>
      SupplyPredictionRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        supplyId: supplyId ?? this.supplyId,
        supplyName: supplyName ?? this.supplyName,
        supplyType: supplyType ?? this.supplyType,
        unit: unit ?? this.unit,
        sampleCount: sampleCount ?? this.sampleCount,
        confirmedCycleCount: confirmedCycleCount ?? this.confirmedCycleCount,
        averageIntervalDays: averageIntervalDays.present
            ? averageIntervalDays.value
            : this.averageIntervalDays,
        medianIntervalDays: medianIntervalDays.present
            ? medianIntervalDays.value
            : this.medianIntervalDays,
        weightedIntervalDays: weightedIntervalDays.present
            ? weightedIntervalDays.value
            : this.weightedIntervalDays,
        intervalStdDevDays: intervalStdDevDays.present
            ? intervalStdDevDays.value
            : this.intervalStdDevDays,
        averagePurchaseAmountCents: averagePurchaseAmountCents.present
            ? averagePurchaseAmountCents.value
            : this.averagePurchaseAmountCents,
        averageDailyConsumptionUnits: averageDailyConsumptionUnits.present
            ? averageDailyConsumptionUnits.value
            : this.averageDailyConsumptionUnits,
        averageDailyCostCents: averageDailyCostCents.present
            ? averageDailyCostCents.value
            : this.averageDailyCostCents,
        lastPurchaseDate: lastPurchaseDate.present
            ? lastPurchaseDate.value
            : this.lastPurchaseDate,
        estimatedNextReplenishmentDate: estimatedNextReplenishmentDate.present
            ? estimatedNextReplenishmentDate.value
            : this.estimatedNextReplenishmentDate,
        manualOverrideDate: manualOverrideDate.present
            ? manualOverrideDate.value
            : this.manualOverrideDate,
        actualConfirmedDepletionDate: actualConfirmedDepletionDate.present
            ? actualConfirmedDepletionDate.value
            : this.actualConfirmedDepletionDate,
        confidenceLevel: confidenceLevel ?? this.confidenceLevel,
        confidenceScore: confidenceScore ?? this.confidenceScore,
        isMonetaryEstimateOnly:
            isMonetaryEstimateOnly ?? this.isMonetaryEstimateOnly,
        explanation: explanation ?? this.explanation,
        trendDirection: trendDirection ?? this.trendDirection,
        historicalIntervalsJson:
            historicalIntervalsJson ?? this.historicalIntervalsJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SupplyPredictionRow copyWithCompanion(SupplyPredictionsCompanion data) {
    return SupplyPredictionRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      supplyId: data.supplyId.present ? data.supplyId.value : this.supplyId,
      supplyName:
          data.supplyName.present ? data.supplyName.value : this.supplyName,
      supplyType:
          data.supplyType.present ? data.supplyType.value : this.supplyType,
      unit: data.unit.present ? data.unit.value : this.unit,
      sampleCount:
          data.sampleCount.present ? data.sampleCount.value : this.sampleCount,
      confirmedCycleCount: data.confirmedCycleCount.present
          ? data.confirmedCycleCount.value
          : this.confirmedCycleCount,
      averageIntervalDays: data.averageIntervalDays.present
          ? data.averageIntervalDays.value
          : this.averageIntervalDays,
      medianIntervalDays: data.medianIntervalDays.present
          ? data.medianIntervalDays.value
          : this.medianIntervalDays,
      weightedIntervalDays: data.weightedIntervalDays.present
          ? data.weightedIntervalDays.value
          : this.weightedIntervalDays,
      intervalStdDevDays: data.intervalStdDevDays.present
          ? data.intervalStdDevDays.value
          : this.intervalStdDevDays,
      averagePurchaseAmountCents: data.averagePurchaseAmountCents.present
          ? data.averagePurchaseAmountCents.value
          : this.averagePurchaseAmountCents,
      averageDailyConsumptionUnits: data.averageDailyConsumptionUnits.present
          ? data.averageDailyConsumptionUnits.value
          : this.averageDailyConsumptionUnits,
      averageDailyCostCents: data.averageDailyCostCents.present
          ? data.averageDailyCostCents.value
          : this.averageDailyCostCents,
      lastPurchaseDate: data.lastPurchaseDate.present
          ? data.lastPurchaseDate.value
          : this.lastPurchaseDate,
      estimatedNextReplenishmentDate:
          data.estimatedNextReplenishmentDate.present
              ? data.estimatedNextReplenishmentDate.value
              : this.estimatedNextReplenishmentDate,
      manualOverrideDate: data.manualOverrideDate.present
          ? data.manualOverrideDate.value
          : this.manualOverrideDate,
      actualConfirmedDepletionDate: data.actualConfirmedDepletionDate.present
          ? data.actualConfirmedDepletionDate.value
          : this.actualConfirmedDepletionDate,
      confidenceLevel: data.confidenceLevel.present
          ? data.confidenceLevel.value
          : this.confidenceLevel,
      confidenceScore: data.confidenceScore.present
          ? data.confidenceScore.value
          : this.confidenceScore,
      isMonetaryEstimateOnly: data.isMonetaryEstimateOnly.present
          ? data.isMonetaryEstimateOnly.value
          : this.isMonetaryEstimateOnly,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      trendDirection: data.trendDirection.present
          ? data.trendDirection.value
          : this.trendDirection,
      historicalIntervalsJson: data.historicalIntervalsJson.present
          ? data.historicalIntervalsJson.value
          : this.historicalIntervalsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplyPredictionRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('supplyId: $supplyId, ')
          ..write('supplyName: $supplyName, ')
          ..write('supplyType: $supplyType, ')
          ..write('unit: $unit, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('confirmedCycleCount: $confirmedCycleCount, ')
          ..write('averageIntervalDays: $averageIntervalDays, ')
          ..write('medianIntervalDays: $medianIntervalDays, ')
          ..write('weightedIntervalDays: $weightedIntervalDays, ')
          ..write('intervalStdDevDays: $intervalStdDevDays, ')
          ..write('averagePurchaseAmountCents: $averagePurchaseAmountCents, ')
          ..write(
              'averageDailyConsumptionUnits: $averageDailyConsumptionUnits, ')
          ..write('averageDailyCostCents: $averageDailyCostCents, ')
          ..write('lastPurchaseDate: $lastPurchaseDate, ')
          ..write(
              'estimatedNextReplenishmentDate: $estimatedNextReplenishmentDate, ')
          ..write('manualOverrideDate: $manualOverrideDate, ')
          ..write(
              'actualConfirmedDepletionDate: $actualConfirmedDepletionDate, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('isMonetaryEstimateOnly: $isMonetaryEstimateOnly, ')
          ..write('explanation: $explanation, ')
          ..write('trendDirection: $trendDirection, ')
          ..write('historicalIntervalsJson: $historicalIntervalsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        householdId,
        supplyId,
        supplyName,
        supplyType,
        unit,
        sampleCount,
        confirmedCycleCount,
        averageIntervalDays,
        medianIntervalDays,
        weightedIntervalDays,
        intervalStdDevDays,
        averagePurchaseAmountCents,
        averageDailyConsumptionUnits,
        averageDailyCostCents,
        lastPurchaseDate,
        estimatedNextReplenishmentDate,
        manualOverrideDate,
        actualConfirmedDepletionDate,
        confidenceLevel,
        confidenceScore,
        isMonetaryEstimateOnly,
        explanation,
        trendDirection,
        historicalIntervalsJson,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplyPredictionRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.supplyId == this.supplyId &&
          other.supplyName == this.supplyName &&
          other.supplyType == this.supplyType &&
          other.unit == this.unit &&
          other.sampleCount == this.sampleCount &&
          other.confirmedCycleCount == this.confirmedCycleCount &&
          other.averageIntervalDays == this.averageIntervalDays &&
          other.medianIntervalDays == this.medianIntervalDays &&
          other.weightedIntervalDays == this.weightedIntervalDays &&
          other.intervalStdDevDays == this.intervalStdDevDays &&
          other.averagePurchaseAmountCents == this.averagePurchaseAmountCents &&
          other.averageDailyConsumptionUnits ==
              this.averageDailyConsumptionUnits &&
          other.averageDailyCostCents == this.averageDailyCostCents &&
          other.lastPurchaseDate == this.lastPurchaseDate &&
          other.estimatedNextReplenishmentDate ==
              this.estimatedNextReplenishmentDate &&
          other.manualOverrideDate == this.manualOverrideDate &&
          other.actualConfirmedDepletionDate ==
              this.actualConfirmedDepletionDate &&
          other.confidenceLevel == this.confidenceLevel &&
          other.confidenceScore == this.confidenceScore &&
          other.isMonetaryEstimateOnly == this.isMonetaryEstimateOnly &&
          other.explanation == this.explanation &&
          other.trendDirection == this.trendDirection &&
          other.historicalIntervalsJson == this.historicalIntervalsJson &&
          other.updatedAt == this.updatedAt);
}

class SupplyPredictionsCompanion extends UpdateCompanion<SupplyPredictionRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> supplyId;
  final Value<String> supplyName;
  final Value<String> supplyType;
  final Value<String> unit;
  final Value<int> sampleCount;
  final Value<int> confirmedCycleCount;
  final Value<double?> averageIntervalDays;
  final Value<double?> medianIntervalDays;
  final Value<double?> weightedIntervalDays;
  final Value<double?> intervalStdDevDays;
  final Value<int?> averagePurchaseAmountCents;
  final Value<double?> averageDailyConsumptionUnits;
  final Value<int?> averageDailyCostCents;
  final Value<DateTime?> lastPurchaseDate;
  final Value<DateTime?> estimatedNextReplenishmentDate;
  final Value<DateTime?> manualOverrideDate;
  final Value<DateTime?> actualConfirmedDepletionDate;
  final Value<String> confidenceLevel;
  final Value<int> confidenceScore;
  final Value<bool> isMonetaryEstimateOnly;
  final Value<String> explanation;
  final Value<String> trendDirection;
  final Value<String> historicalIntervalsJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SupplyPredictionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.supplyId = const Value.absent(),
    this.supplyName = const Value.absent(),
    this.supplyType = const Value.absent(),
    this.unit = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.confirmedCycleCount = const Value.absent(),
    this.averageIntervalDays = const Value.absent(),
    this.medianIntervalDays = const Value.absent(),
    this.weightedIntervalDays = const Value.absent(),
    this.intervalStdDevDays = const Value.absent(),
    this.averagePurchaseAmountCents = const Value.absent(),
    this.averageDailyConsumptionUnits = const Value.absent(),
    this.averageDailyCostCents = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
    this.estimatedNextReplenishmentDate = const Value.absent(),
    this.manualOverrideDate = const Value.absent(),
    this.actualConfirmedDepletionDate = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.isMonetaryEstimateOnly = const Value.absent(),
    this.explanation = const Value.absent(),
    this.trendDirection = const Value.absent(),
    this.historicalIntervalsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplyPredictionsCompanion.insert({
    required String id,
    required String householdId,
    required String supplyId,
    required String supplyName,
    required String supplyType,
    required String unit,
    this.sampleCount = const Value.absent(),
    this.confirmedCycleCount = const Value.absent(),
    this.averageIntervalDays = const Value.absent(),
    this.medianIntervalDays = const Value.absent(),
    this.weightedIntervalDays = const Value.absent(),
    this.intervalStdDevDays = const Value.absent(),
    this.averagePurchaseAmountCents = const Value.absent(),
    this.averageDailyConsumptionUnits = const Value.absent(),
    this.averageDailyCostCents = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
    this.estimatedNextReplenishmentDate = const Value.absent(),
    this.manualOverrideDate = const Value.absent(),
    this.actualConfirmedDepletionDate = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.isMonetaryEstimateOnly = const Value.absent(),
    required String explanation,
    this.trendDirection = const Value.absent(),
    this.historicalIntervalsJson = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        supplyId = Value(supplyId),
        supplyName = Value(supplyName),
        supplyType = Value(supplyType),
        unit = Value(unit),
        explanation = Value(explanation),
        updatedAt = Value(updatedAt);
  static Insertable<SupplyPredictionRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? supplyId,
    Expression<String>? supplyName,
    Expression<String>? supplyType,
    Expression<String>? unit,
    Expression<int>? sampleCount,
    Expression<int>? confirmedCycleCount,
    Expression<double>? averageIntervalDays,
    Expression<double>? medianIntervalDays,
    Expression<double>? weightedIntervalDays,
    Expression<double>? intervalStdDevDays,
    Expression<int>? averagePurchaseAmountCents,
    Expression<double>? averageDailyConsumptionUnits,
    Expression<int>? averageDailyCostCents,
    Expression<DateTime>? lastPurchaseDate,
    Expression<DateTime>? estimatedNextReplenishmentDate,
    Expression<DateTime>? manualOverrideDate,
    Expression<DateTime>? actualConfirmedDepletionDate,
    Expression<String>? confidenceLevel,
    Expression<int>? confidenceScore,
    Expression<bool>? isMonetaryEstimateOnly,
    Expression<String>? explanation,
    Expression<String>? trendDirection,
    Expression<String>? historicalIntervalsJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (supplyId != null) 'supply_id': supplyId,
      if (supplyName != null) 'supply_name': supplyName,
      if (supplyType != null) 'supply_type': supplyType,
      if (unit != null) 'unit': unit,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (confirmedCycleCount != null)
        'confirmed_cycle_count': confirmedCycleCount,
      if (averageIntervalDays != null)
        'average_interval_days': averageIntervalDays,
      if (medianIntervalDays != null)
        'median_interval_days': medianIntervalDays,
      if (weightedIntervalDays != null)
        'weighted_interval_days': weightedIntervalDays,
      if (intervalStdDevDays != null)
        'interval_std_dev_days': intervalStdDevDays,
      if (averagePurchaseAmountCents != null)
        'average_purchase_amount_cents': averagePurchaseAmountCents,
      if (averageDailyConsumptionUnits != null)
        'average_daily_consumption_units': averageDailyConsumptionUnits,
      if (averageDailyCostCents != null)
        'average_daily_cost_cents': averageDailyCostCents,
      if (lastPurchaseDate != null) 'last_purchase_date': lastPurchaseDate,
      if (estimatedNextReplenishmentDate != null)
        'estimated_next_replenishment_date': estimatedNextReplenishmentDate,
      if (manualOverrideDate != null)
        'manual_override_date': manualOverrideDate,
      if (actualConfirmedDepletionDate != null)
        'actual_confirmed_depletion_date': actualConfirmedDepletionDate,
      if (confidenceLevel != null) 'confidence_level': confidenceLevel,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (isMonetaryEstimateOnly != null)
        'is_monetary_estimate_only': isMonetaryEstimateOnly,
      if (explanation != null) 'explanation': explanation,
      if (trendDirection != null) 'trend_direction': trendDirection,
      if (historicalIntervalsJson != null)
        'historical_intervals_json': historicalIntervalsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplyPredictionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? supplyId,
      Value<String>? supplyName,
      Value<String>? supplyType,
      Value<String>? unit,
      Value<int>? sampleCount,
      Value<int>? confirmedCycleCount,
      Value<double?>? averageIntervalDays,
      Value<double?>? medianIntervalDays,
      Value<double?>? weightedIntervalDays,
      Value<double?>? intervalStdDevDays,
      Value<int?>? averagePurchaseAmountCents,
      Value<double?>? averageDailyConsumptionUnits,
      Value<int?>? averageDailyCostCents,
      Value<DateTime?>? lastPurchaseDate,
      Value<DateTime?>? estimatedNextReplenishmentDate,
      Value<DateTime?>? manualOverrideDate,
      Value<DateTime?>? actualConfirmedDepletionDate,
      Value<String>? confidenceLevel,
      Value<int>? confidenceScore,
      Value<bool>? isMonetaryEstimateOnly,
      Value<String>? explanation,
      Value<String>? trendDirection,
      Value<String>? historicalIntervalsJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SupplyPredictionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      supplyId: supplyId ?? this.supplyId,
      supplyName: supplyName ?? this.supplyName,
      supplyType: supplyType ?? this.supplyType,
      unit: unit ?? this.unit,
      sampleCount: sampleCount ?? this.sampleCount,
      confirmedCycleCount: confirmedCycleCount ?? this.confirmedCycleCount,
      averageIntervalDays: averageIntervalDays ?? this.averageIntervalDays,
      medianIntervalDays: medianIntervalDays ?? this.medianIntervalDays,
      weightedIntervalDays: weightedIntervalDays ?? this.weightedIntervalDays,
      intervalStdDevDays: intervalStdDevDays ?? this.intervalStdDevDays,
      averagePurchaseAmountCents:
          averagePurchaseAmountCents ?? this.averagePurchaseAmountCents,
      averageDailyConsumptionUnits:
          averageDailyConsumptionUnits ?? this.averageDailyConsumptionUnits,
      averageDailyCostCents:
          averageDailyCostCents ?? this.averageDailyCostCents,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      estimatedNextReplenishmentDate:
          estimatedNextReplenishmentDate ?? this.estimatedNextReplenishmentDate,
      manualOverrideDate: manualOverrideDate ?? this.manualOverrideDate,
      actualConfirmedDepletionDate:
          actualConfirmedDepletionDate ?? this.actualConfirmedDepletionDate,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      isMonetaryEstimateOnly:
          isMonetaryEstimateOnly ?? this.isMonetaryEstimateOnly,
      explanation: explanation ?? this.explanation,
      trendDirection: trendDirection ?? this.trendDirection,
      historicalIntervalsJson:
          historicalIntervalsJson ?? this.historicalIntervalsJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (supplyId.present) {
      map['supply_id'] = Variable<String>(supplyId.value);
    }
    if (supplyName.present) {
      map['supply_name'] = Variable<String>(supplyName.value);
    }
    if (supplyType.present) {
      map['supply_type'] = Variable<String>(supplyType.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (confirmedCycleCount.present) {
      map['confirmed_cycle_count'] = Variable<int>(confirmedCycleCount.value);
    }
    if (averageIntervalDays.present) {
      map['average_interval_days'] =
          Variable<double>(averageIntervalDays.value);
    }
    if (medianIntervalDays.present) {
      map['median_interval_days'] = Variable<double>(medianIntervalDays.value);
    }
    if (weightedIntervalDays.present) {
      map['weighted_interval_days'] =
          Variable<double>(weightedIntervalDays.value);
    }
    if (intervalStdDevDays.present) {
      map['interval_std_dev_days'] = Variable<double>(intervalStdDevDays.value);
    }
    if (averagePurchaseAmountCents.present) {
      map['average_purchase_amount_cents'] =
          Variable<int>(averagePurchaseAmountCents.value);
    }
    if (averageDailyConsumptionUnits.present) {
      map['average_daily_consumption_units'] =
          Variable<double>(averageDailyConsumptionUnits.value);
    }
    if (averageDailyCostCents.present) {
      map['average_daily_cost_cents'] =
          Variable<int>(averageDailyCostCents.value);
    }
    if (lastPurchaseDate.present) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate.value);
    }
    if (estimatedNextReplenishmentDate.present) {
      map['estimated_next_replenishment_date'] =
          Variable<DateTime>(estimatedNextReplenishmentDate.value);
    }
    if (manualOverrideDate.present) {
      map['manual_override_date'] =
          Variable<DateTime>(manualOverrideDate.value);
    }
    if (actualConfirmedDepletionDate.present) {
      map['actual_confirmed_depletion_date'] =
          Variable<DateTime>(actualConfirmedDepletionDate.value);
    }
    if (confidenceLevel.present) {
      map['confidence_level'] = Variable<String>(confidenceLevel.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<int>(confidenceScore.value);
    }
    if (isMonetaryEstimateOnly.present) {
      map['is_monetary_estimate_only'] =
          Variable<bool>(isMonetaryEstimateOnly.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (trendDirection.present) {
      map['trend_direction'] = Variable<String>(trendDirection.value);
    }
    if (historicalIntervalsJson.present) {
      map['historical_intervals_json'] =
          Variable<String>(historicalIntervalsJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplyPredictionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('supplyId: $supplyId, ')
          ..write('supplyName: $supplyName, ')
          ..write('supplyType: $supplyType, ')
          ..write('unit: $unit, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('confirmedCycleCount: $confirmedCycleCount, ')
          ..write('averageIntervalDays: $averageIntervalDays, ')
          ..write('medianIntervalDays: $medianIntervalDays, ')
          ..write('weightedIntervalDays: $weightedIntervalDays, ')
          ..write('intervalStdDevDays: $intervalStdDevDays, ')
          ..write('averagePurchaseAmountCents: $averagePurchaseAmountCents, ')
          ..write(
              'averageDailyConsumptionUnits: $averageDailyConsumptionUnits, ')
          ..write('averageDailyCostCents: $averageDailyCostCents, ')
          ..write('lastPurchaseDate: $lastPurchaseDate, ')
          ..write(
              'estimatedNextReplenishmentDate: $estimatedNextReplenishmentDate, ')
          ..write('manualOverrideDate: $manualOverrideDate, ')
          ..write(
              'actualConfirmedDepletionDate: $actualConfirmedDepletionDate, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('isMonetaryEstimateOnly: $isMonetaryEstimateOnly, ')
          ..write('explanation: $explanation, ')
          ..write('trendDirection: $trendDirection, ')
          ..write('historicalIntervalsJson: $historicalIntervalsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringBillsTable extends RecurringBills
    with TableInfo<$RecurringBillsTable, RecurringBillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerNameMeta =
      const VerificationMeta('providerName');
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
      'provider_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expectedAmountCentsMeta =
      const VerificationMeta('expectedAmountCents');
  @override
  late final GeneratedColumn<int> expectedAmountCents = GeneratedColumn<int>(
      'expected_amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _remindDaysBeforeMeta =
      const VerificationMeta('remindDaysBefore');
  @override
  late final GeneratedColumn<int> remindDaysBefore = GeneratedColumn<int>(
      'remind_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        categoryId,
        categoryName,
        title,
        providerName,
        expectedAmountCents,
        frequency,
        nextDueDate,
        remindDaysBefore,
        isActive,
        version,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_bills';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringBillRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('provider_name')) {
      context.handle(
          _providerNameMeta,
          providerName.isAcceptableOrUnknown(
              data['provider_name']!, _providerNameMeta));
    }
    if (data.containsKey('expected_amount_cents')) {
      context.handle(
          _expectedAmountCentsMeta,
          expectedAmountCents.isAcceptableOrUnknown(
              data['expected_amount_cents']!, _expectedAmountCentsMeta));
    } else if (isInserting) {
      context.missing(_expectedAmountCentsMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('remind_days_before')) {
      context.handle(
          _remindDaysBeforeMeta,
          remindDaysBefore.isAcceptableOrUnknown(
              data['remind_days_before']!, _remindDaysBeforeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringBillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringBillRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      providerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider_name']),
      expectedAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_amount_cents'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      nextDueDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_due_date'])!,
      remindDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}remind_days_before'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RecurringBillsTable createAlias(String alias) {
    return $RecurringBillsTable(attachedDatabase, alias);
  }
}

class RecurringBillRow extends DataClass
    implements Insertable<RecurringBillRow> {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String? providerName;
  final int expectedAmountCents;
  final String frequency;
  final DateTime nextDueDate;
  final int remindDaysBefore;
  final bool isActive;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const RecurringBillRow(
      {required this.id,
      required this.householdId,
      required this.categoryId,
      required this.categoryName,
      required this.title,
      this.providerName,
      required this.expectedAmountCents,
      required this.frequency,
      required this.nextDueDate,
      required this.remindDaysBefore,
      required this.isActive,
      required this.version,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || providerName != null) {
      map['provider_name'] = Variable<String>(providerName);
    }
    map['expected_amount_cents'] = Variable<int>(expectedAmountCents);
    map['frequency'] = Variable<String>(frequency);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    map['remind_days_before'] = Variable<int>(remindDaysBefore);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RecurringBillsCompanion toCompanion(bool nullToAbsent) {
    return RecurringBillsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      title: Value(title),
      providerName: providerName == null && nullToAbsent
          ? const Value.absent()
          : Value(providerName),
      expectedAmountCents: Value(expectedAmountCents),
      frequency: Value(frequency),
      nextDueDate: Value(nextDueDate),
      remindDaysBefore: Value(remindDaysBefore),
      isActive: Value(isActive),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RecurringBillRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringBillRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      title: serializer.fromJson<String>(json['title']),
      providerName: serializer.fromJson<String?>(json['providerName']),
      expectedAmountCents:
          serializer.fromJson<int>(json['expectedAmountCents']),
      frequency: serializer.fromJson<String>(json['frequency']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      remindDaysBefore: serializer.fromJson<int>(json['remindDaysBefore']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'title': serializer.toJson<String>(title),
      'providerName': serializer.toJson<String?>(providerName),
      'expectedAmountCents': serializer.toJson<int>(expectedAmountCents),
      'frequency': serializer.toJson<String>(frequency),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'remindDaysBefore': serializer.toJson<int>(remindDaysBefore),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RecurringBillRow copyWith(
          {String? id,
          String? householdId,
          String? categoryId,
          String? categoryName,
          String? title,
          Value<String?> providerName = const Value.absent(),
          int? expectedAmountCents,
          String? frequency,
          DateTime? nextDueDate,
          int? remindDaysBefore,
          bool? isActive,
          int? version,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      RecurringBillRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        title: title ?? this.title,
        providerName:
            providerName.present ? providerName.value : this.providerName,
        expectedAmountCents: expectedAmountCents ?? this.expectedAmountCents,
        frequency: frequency ?? this.frequency,
        nextDueDate: nextDueDate ?? this.nextDueDate,
        remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
        isActive: isActive ?? this.isActive,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RecurringBillRow copyWithCompanion(RecurringBillsCompanion data) {
    return RecurringBillRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      title: data.title.present ? data.title.value : this.title,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      expectedAmountCents: data.expectedAmountCents.present
          ? data.expectedAmountCents.value
          : this.expectedAmountCents,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      remindDaysBefore: data.remindDaysBefore.present
          ? data.remindDaysBefore.value
          : this.remindDaysBefore,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringBillRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('title: $title, ')
          ..write('providerName: $providerName, ')
          ..write('expectedAmountCents: $expectedAmountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      categoryId,
      categoryName,
      title,
      providerName,
      expectedAmountCents,
      frequency,
      nextDueDate,
      remindDaysBefore,
      isActive,
      version,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringBillRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.title == this.title &&
          other.providerName == this.providerName &&
          other.expectedAmountCents == this.expectedAmountCents &&
          other.frequency == this.frequency &&
          other.nextDueDate == this.nextDueDate &&
          other.remindDaysBefore == this.remindDaysBefore &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringBillsCompanion extends UpdateCompanion<RecurringBillRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<String> title;
  final Value<String?> providerName;
  final Value<int> expectedAmountCents;
  final Value<String> frequency;
  final Value<DateTime> nextDueDate;
  final Value<int> remindDaysBefore;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RecurringBillsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.title = const Value.absent(),
    this.providerName = const Value.absent(),
    this.expectedAmountCents = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringBillsCompanion.insert({
    required String id,
    required String householdId,
    required String categoryId,
    required String categoryName,
    required String title,
    this.providerName = const Value.absent(),
    required int expectedAmountCents,
    required String frequency,
    required DateTime nextDueDate,
    this.remindDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        categoryId = Value(categoryId),
        categoryName = Value(categoryName),
        title = Value(title),
        expectedAmountCents = Value(expectedAmountCents),
        frequency = Value(frequency),
        nextDueDate = Value(nextDueDate),
        createdAt = Value(createdAt);
  static Insertable<RecurringBillRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? title,
    Expression<String>? providerName,
    Expression<int>? expectedAmountCents,
    Expression<String>? frequency,
    Expression<DateTime>? nextDueDate,
    Expression<int>? remindDaysBefore,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (title != null) 'title': title,
      if (providerName != null) 'provider_name': providerName,
      if (expectedAmountCents != null)
        'expected_amount_cents': expectedAmountCents,
      if (frequency != null) 'frequency': frequency,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (remindDaysBefore != null) 'remind_days_before': remindDaysBefore,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringBillsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? categoryId,
      Value<String>? categoryName,
      Value<String>? title,
      Value<String?>? providerName,
      Value<int>? expectedAmountCents,
      Value<String>? frequency,
      Value<DateTime>? nextDueDate,
      Value<int>? remindDaysBefore,
      Value<bool>? isActive,
      Value<int>? version,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return RecurringBillsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      title: title ?? this.title,
      providerName: providerName ?? this.providerName,
      expectedAmountCents: expectedAmountCents ?? this.expectedAmountCents,
      frequency: frequency ?? this.frequency,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (expectedAmountCents.present) {
      map['expected_amount_cents'] = Variable<int>(expectedAmountCents.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (remindDaysBefore.present) {
      map['remind_days_before'] = Variable<int>(remindDaysBefore.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringBillsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('title: $title, ')
          ..write('providerName: $providerName, ')
          ..write('expectedAmountCents: $expectedAmountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdNotificationsTable extends HouseholdNotifications
    with TableInfo<$HouseholdNotificationsTable, HouseholdNotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relatedEntityTypeMeta =
      const VerificationMeta('relatedEntityType');
  @override
  late final GeneratedColumn<String> relatedEntityType =
      GeneratedColumn<String>('related_entity_type', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedEntityIdMeta =
      const VerificationMeta('relatedEntityId');
  @override
  late final GeneratedColumn<String> relatedEntityId = GeneratedColumn<String>(
      'related_entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dedupKeyMeta =
      const VerificationMeta('dedupKey');
  @override
  late final GeneratedColumn<String> dedupKey = GeneratedColumn<String>(
      'dedup_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDismissedMeta =
      const VerificationMeta('isDismissed');
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
      'is_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        type,
        severity,
        title,
        body,
        relatedEntityType,
        relatedEntityId,
        dedupKey,
        isRead,
        isDismissed,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_notifications';
  @override
  VerificationContext validateIntegrity(
      Insertable<HouseholdNotificationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('related_entity_type')) {
      context.handle(
          _relatedEntityTypeMeta,
          relatedEntityType.isAcceptableOrUnknown(
              data['related_entity_type']!, _relatedEntityTypeMeta));
    }
    if (data.containsKey('related_entity_id')) {
      context.handle(
          _relatedEntityIdMeta,
          relatedEntityId.isAcceptableOrUnknown(
              data['related_entity_id']!, _relatedEntityIdMeta));
    }
    if (data.containsKey('dedup_key')) {
      context.handle(_dedupKeyMeta,
          dedupKey.isAcceptableOrUnknown(data['dedup_key']!, _dedupKeyMeta));
    } else if (isInserting) {
      context.missing(_dedupKeyMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
          _isDismissedMeta,
          isDismissed.isAcceptableOrUnknown(
              data['is_dismissed']!, _isDismissedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdNotificationRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdNotificationRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      relatedEntityType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}related_entity_type']),
      relatedEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}related_entity_id']),
      dedupKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dedup_key'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      isDismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dismissed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HouseholdNotificationsTable createAlias(String alias) {
    return $HouseholdNotificationsTable(attachedDatabase, alias);
  }
}

class HouseholdNotificationRow extends DataClass
    implements Insertable<HouseholdNotificationRow> {
  final String id;
  final String householdId;
  final String type;
  final String severity;
  final String title;
  final String body;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String dedupKey;
  final bool isRead;
  final bool isDismissed;
  final DateTime createdAt;
  const HouseholdNotificationRow(
      {required this.id,
      required this.householdId,
      required this.type,
      required this.severity,
      required this.title,
      required this.body,
      this.relatedEntityType,
      this.relatedEntityId,
      required this.dedupKey,
      required this.isRead,
      required this.isDismissed,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['type'] = Variable<String>(type);
    map['severity'] = Variable<String>(severity);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || relatedEntityType != null) {
      map['related_entity_type'] = Variable<String>(relatedEntityType);
    }
    if (!nullToAbsent || relatedEntityId != null) {
      map['related_entity_id'] = Variable<String>(relatedEntityId);
    }
    map['dedup_key'] = Variable<String>(dedupKey);
    map['is_read'] = Variable<bool>(isRead);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HouseholdNotificationsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdNotificationsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      type: Value(type),
      severity: Value(severity),
      title: Value(title),
      body: Value(body),
      relatedEntityType: relatedEntityType == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedEntityType),
      relatedEntityId: relatedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedEntityId),
      dedupKey: Value(dedupKey),
      isRead: Value(isRead),
      isDismissed: Value(isDismissed),
      createdAt: Value(createdAt),
    );
  }

  factory HouseholdNotificationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdNotificationRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      type: serializer.fromJson<String>(json['type']),
      severity: serializer.fromJson<String>(json['severity']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      relatedEntityType:
          serializer.fromJson<String?>(json['relatedEntityType']),
      relatedEntityId: serializer.fromJson<String?>(json['relatedEntityId']),
      dedupKey: serializer.fromJson<String>(json['dedupKey']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'type': serializer.toJson<String>(type),
      'severity': serializer.toJson<String>(severity),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'relatedEntityType': serializer.toJson<String?>(relatedEntityType),
      'relatedEntityId': serializer.toJson<String?>(relatedEntityId),
      'dedupKey': serializer.toJson<String>(dedupKey),
      'isRead': serializer.toJson<bool>(isRead),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HouseholdNotificationRow copyWith(
          {String? id,
          String? householdId,
          String? type,
          String? severity,
          String? title,
          String? body,
          Value<String?> relatedEntityType = const Value.absent(),
          Value<String?> relatedEntityId = const Value.absent(),
          String? dedupKey,
          bool? isRead,
          bool? isDismissed,
          DateTime? createdAt}) =>
      HouseholdNotificationRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        type: type ?? this.type,
        severity: severity ?? this.severity,
        title: title ?? this.title,
        body: body ?? this.body,
        relatedEntityType: relatedEntityType.present
            ? relatedEntityType.value
            : this.relatedEntityType,
        relatedEntityId: relatedEntityId.present
            ? relatedEntityId.value
            : this.relatedEntityId,
        dedupKey: dedupKey ?? this.dedupKey,
        isRead: isRead ?? this.isRead,
        isDismissed: isDismissed ?? this.isDismissed,
        createdAt: createdAt ?? this.createdAt,
      );
  HouseholdNotificationRow copyWithCompanion(
      HouseholdNotificationsCompanion data) {
    return HouseholdNotificationRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      type: data.type.present ? data.type.value : this.type,
      severity: data.severity.present ? data.severity.value : this.severity,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      relatedEntityType: data.relatedEntityType.present
          ? data.relatedEntityType.value
          : this.relatedEntityType,
      relatedEntityId: data.relatedEntityId.present
          ? data.relatedEntityId.value
          : this.relatedEntityId,
      dedupKey: data.dedupKey.present ? data.dedupKey.value : this.dedupKey,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isDismissed:
          data.isDismissed.present ? data.isDismissed.value : this.isDismissed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdNotificationRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('relatedEntityType: $relatedEntityType, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      type,
      severity,
      title,
      body,
      relatedEntityType,
      relatedEntityId,
      dedupKey,
      isRead,
      isDismissed,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdNotificationRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.type == this.type &&
          other.severity == this.severity &&
          other.title == this.title &&
          other.body == this.body &&
          other.relatedEntityType == this.relatedEntityType &&
          other.relatedEntityId == this.relatedEntityId &&
          other.dedupKey == this.dedupKey &&
          other.isRead == this.isRead &&
          other.isDismissed == this.isDismissed &&
          other.createdAt == this.createdAt);
}

class HouseholdNotificationsCompanion
    extends UpdateCompanion<HouseholdNotificationRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> type;
  final Value<String> severity;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> relatedEntityType;
  final Value<String?> relatedEntityId;
  final Value<String> dedupKey;
  final Value<bool> isRead;
  final Value<bool> isDismissed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HouseholdNotificationsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.type = const Value.absent(),
    this.severity = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.relatedEntityType = const Value.absent(),
    this.relatedEntityId = const Value.absent(),
    this.dedupKey = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdNotificationsCompanion.insert({
    required String id,
    required String householdId,
    required String type,
    required String severity,
    required String title,
    required String body,
    this.relatedEntityType = const Value.absent(),
    this.relatedEntityId = const Value.absent(),
    required String dedupKey,
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        type = Value(type),
        severity = Value(severity),
        title = Value(title),
        body = Value(body),
        dedupKey = Value(dedupKey),
        createdAt = Value(createdAt);
  static Insertable<HouseholdNotificationRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? type,
    Expression<String>? severity,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? relatedEntityType,
    Expression<String>? relatedEntityId,
    Expression<String>? dedupKey,
    Expression<bool>? isRead,
    Expression<bool>? isDismissed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (type != null) 'type': type,
      if (severity != null) 'severity': severity,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (relatedEntityType != null) 'related_entity_type': relatedEntityType,
      if (relatedEntityId != null) 'related_entity_id': relatedEntityId,
      if (dedupKey != null) 'dedup_key': dedupKey,
      if (isRead != null) 'is_read': isRead,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdNotificationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? type,
      Value<String>? severity,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? relatedEntityType,
      Value<String?>? relatedEntityId,
      Value<String>? dedupKey,
      Value<bool>? isRead,
      Value<bool>? isDismissed,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HouseholdNotificationsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      body: body ?? this.body,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      dedupKey: dedupKey ?? this.dedupKey,
      isRead: isRead ?? this.isRead,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (relatedEntityType.present) {
      map['related_entity_type'] = Variable<String>(relatedEntityType.value);
    }
    if (relatedEntityId.present) {
      map['related_entity_id'] = Variable<String>(relatedEntityId.value);
    }
    if (dedupKey.present) {
      map['dedup_key'] = Variable<String>(dedupKey.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('relatedEntityType: $relatedEntityType, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedByMeta =
      const VerificationMeta('performedBy');
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
      'performed_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedByNameMeta =
      const VerificationMeta('performedByName');
  @override
  late final GeneratedColumn<String> performedByName = GeneratedColumn<String>(
      'performed_by_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beforeStateJsonMeta =
      const VerificationMeta('beforeStateJson');
  @override
  late final GeneratedColumn<String> beforeStateJson = GeneratedColumn<String>(
      'before_state_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _afterStateJsonMeta =
      const VerificationMeta('afterStateJson');
  @override
  late final GeneratedColumn<String> afterStateJson = GeneratedColumn<String>(
      'after_state_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        action,
        entityType,
        entityId,
        performedBy,
        performedByName,
        reason,
        beforeStateJson,
        afterStateJson,
        timestamp
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('performed_by')) {
      context.handle(
          _performedByMeta,
          performedBy.isAcceptableOrUnknown(
              data['performed_by']!, _performedByMeta));
    } else if (isInserting) {
      context.missing(_performedByMeta);
    }
    if (data.containsKey('performed_by_name')) {
      context.handle(
          _performedByNameMeta,
          performedByName.isAcceptableOrUnknown(
              data['performed_by_name']!, _performedByNameMeta));
    } else if (isInserting) {
      context.missing(_performedByNameMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('before_state_json')) {
      context.handle(
          _beforeStateJsonMeta,
          beforeStateJson.isAcceptableOrUnknown(
              data['before_state_json']!, _beforeStateJsonMeta));
    }
    if (data.containsKey('after_state_json')) {
      context.handle(
          _afterStateJsonMeta,
          afterStateJson.isAcceptableOrUnknown(
              data['after_state_json']!, _afterStateJsonMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      performedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_by'])!,
      performedByName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}performed_by_name'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      beforeStateJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}before_state_json']),
      afterStateJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}after_state_json']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLogRow extends DataClass implements Insertable<AuditLogRow> {
  final String id;
  final String householdId;
  final String action;
  final String entityType;
  final String entityId;
  final String performedBy;
  final String performedByName;
  final String reason;
  final String? beforeStateJson;
  final String? afterStateJson;
  final DateTime timestamp;
  const AuditLogRow(
      {required this.id,
      required this.householdId,
      required this.action,
      required this.entityType,
      required this.entityId,
      required this.performedBy,
      required this.performedByName,
      required this.reason,
      this.beforeStateJson,
      this.afterStateJson,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['performed_by'] = Variable<String>(performedBy);
    map['performed_by_name'] = Variable<String>(performedByName);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || beforeStateJson != null) {
      map['before_state_json'] = Variable<String>(beforeStateJson);
    }
    if (!nullToAbsent || afterStateJson != null) {
      map['after_state_json'] = Variable<String>(afterStateJson);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: Value(entityId),
      performedBy: Value(performedBy),
      performedByName: Value(performedByName),
      reason: Value(reason),
      beforeStateJson: beforeStateJson == null && nullToAbsent
          ? const Value.absent()
          : Value(beforeStateJson),
      afterStateJson: afterStateJson == null && nullToAbsent
          ? const Value.absent()
          : Value(afterStateJson),
      timestamp: Value(timestamp),
    );
  }

  factory AuditLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      performedByName: serializer.fromJson<String>(json['performedByName']),
      reason: serializer.fromJson<String>(json['reason']),
      beforeStateJson: serializer.fromJson<String?>(json['beforeStateJson']),
      afterStateJson: serializer.fromJson<String?>(json['afterStateJson']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'performedBy': serializer.toJson<String>(performedBy),
      'performedByName': serializer.toJson<String>(performedByName),
      'reason': serializer.toJson<String>(reason),
      'beforeStateJson': serializer.toJson<String?>(beforeStateJson),
      'afterStateJson': serializer.toJson<String?>(afterStateJson),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AuditLogRow copyWith(
          {String? id,
          String? householdId,
          String? action,
          String? entityType,
          String? entityId,
          String? performedBy,
          String? performedByName,
          String? reason,
          Value<String?> beforeStateJson = const Value.absent(),
          Value<String?> afterStateJson = const Value.absent(),
          DateTime? timestamp}) =>
      AuditLogRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        action: action ?? this.action,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        performedBy: performedBy ?? this.performedBy,
        performedByName: performedByName ?? this.performedByName,
        reason: reason ?? this.reason,
        beforeStateJson: beforeStateJson.present
            ? beforeStateJson.value
            : this.beforeStateJson,
        afterStateJson:
            afterStateJson.present ? afterStateJson.value : this.afterStateJson,
        timestamp: timestamp ?? this.timestamp,
      );
  AuditLogRow copyWithCompanion(AuditLogsCompanion data) {
    return AuditLogRow(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      performedBy:
          data.performedBy.present ? data.performedBy.value : this.performedBy,
      performedByName: data.performedByName.present
          ? data.performedByName.value
          : this.performedByName,
      reason: data.reason.present ? data.reason.value : this.reason,
      beforeStateJson: data.beforeStateJson.present
          ? data.beforeStateJson.value
          : this.beforeStateJson,
      afterStateJson: data.afterStateJson.present
          ? data.afterStateJson.value
          : this.afterStateJson,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedByName: $performedByName, ')
          ..write('reason: $reason, ')
          ..write('beforeStateJson: $beforeStateJson, ')
          ..write('afterStateJson: $afterStateJson, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      action,
      entityType,
      entityId,
      performedBy,
      performedByName,
      reason,
      beforeStateJson,
      afterStateJson,
      timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.performedBy == this.performedBy &&
          other.performedByName == this.performedByName &&
          other.reason == this.reason &&
          other.beforeStateJson == this.beforeStateJson &&
          other.afterStateJson == this.afterStateJson &&
          other.timestamp == this.timestamp);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLogRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> performedBy;
  final Value<String> performedByName;
  final Value<String> reason;
  final Value<String?> beforeStateJson;
  final Value<String?> afterStateJson;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.performedByName = const Value.absent(),
    this.reason = const Value.absent(),
    this.beforeStateJson = const Value.absent(),
    this.afterStateJson = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    required String householdId,
    required String action,
    required String entityType,
    required String entityId,
    required String performedBy,
    required String performedByName,
    required String reason,
    this.beforeStateJson = const Value.absent(),
    this.afterStateJson = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        action = Value(action),
        entityType = Value(entityType),
        entityId = Value(entityId),
        performedBy = Value(performedBy),
        performedByName = Value(performedByName),
        reason = Value(reason),
        timestamp = Value(timestamp);
  static Insertable<AuditLogRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? performedBy,
    Expression<String>? performedByName,
    Expression<String>? reason,
    Expression<String>? beforeStateJson,
    Expression<String>? afterStateJson,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (performedBy != null) 'performed_by': performedBy,
      if (performedByName != null) 'performed_by_name': performedByName,
      if (reason != null) 'reason': reason,
      if (beforeStateJson != null) 'before_state_json': beforeStateJson,
      if (afterStateJson != null) 'after_state_json': afterStateJson,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? action,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? performedBy,
      Value<String>? performedByName,
      Value<String>? reason,
      Value<String?>? beforeStateJson,
      Value<String?>? afterStateJson,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      performedBy: performedBy ?? this.performedBy,
      performedByName: performedByName ?? this.performedByName,
      reason: reason ?? this.reason,
      beforeStateJson: beforeStateJson ?? this.beforeStateJson,
      afterStateJson: afterStateJson ?? this.afterStateJson,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (performedByName.present) {
      map['performed_by_name'] = Variable<String>(performedByName.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (beforeStateJson.present) {
      map['before_state_json'] = Variable<String>(beforeStateJson.value);
    }
    if (afterStateJson.present) {
      map['after_state_json'] = Variable<String>(afterStateJson.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedByName: $performedByName, ')
          ..write('reason: $reason, ')
          ..write('beforeStateJson: $beforeStateJson, ')
          ..write('afterStateJson: $afterStateJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        householdId,
        entityType,
        entityId,
        operation,
        payloadJson,
        idempotencyKey,
        retryCount,
        status,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      idempotencyKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}idempotency_key']),
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final int id;
  final String userId;
  final String householdId;
  final String entityType;
  final String entityId;
  final String operation;
  final String payloadJson;
  final String? idempotencyKey;
  final int retryCount;
  final String status;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const SyncQueueRow(
      {required this.id,
      required this.userId,
      required this.householdId,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payloadJson,
      this.idempotencyKey,
      required this.retryCount,
      required this.status,
      this.lastError,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['household_id'] = Variable<String>(householdId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || idempotencyKey != null) {
      map['idempotency_key'] = Variable<String>(idempotencyKey);
    }
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      userId: Value(userId),
      householdId: Value(householdId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      idempotencyKey: idempotencyKey == null && nullToAbsent
          ? const Value.absent()
          : Value(idempotencyKey),
      retryCount: Value(retryCount),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SyncQueueRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String?>(json['idempotencyKey']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'householdId': serializer.toJson<String>(householdId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String?>(idempotencyKey),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SyncQueueRow copyWith(
          {int? id,
          String? userId,
          String? householdId,
          String? entityType,
          String? entityId,
          String? operation,
          String? payloadJson,
          Value<String?> idempotencyKey = const Value.absent(),
          int? retryCount,
          String? status,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      SyncQueueRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        householdId: householdId ?? this.householdId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payloadJson: payloadJson ?? this.payloadJson,
        idempotencyKey:
            idempotencyKey.present ? idempotencyKey.value : this.idempotencyKey,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  SyncQueueRow copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      householdId,
      entityType,
      entityId,
      operation,
      payloadJson,
      idempotencyKey,
      retryCount,
      status,
      lastError,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.householdId == this.householdId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> householdId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<String?> idempotencyKey;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String householdId,
    required String entityType,
    required String entityId,
    required String operation,
    required String payloadJson,
    this.idempotencyKey = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        householdId = Value(householdId),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueRow> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? householdId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (householdId != null) 'household_id': householdId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? householdId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payloadJson,
      Value<String?>? idempotencyKey,
      Value<int>? retryCount,
      Value<String>? status,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      householdId: householdId ?? this.householdId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $HouseholdMembersTable householdMembers =
      $HouseholdMembersTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $HouseholdWalletsTable householdWallets =
      $HouseholdWalletsTable(this);
  late final $ContributionsTable contributions = $ContributionsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $WalletTransactionsTable walletTransactions =
      $WalletTransactionsTable(this);
  late final $HouseholdBudgetsTable householdBudgets =
      $HouseholdBudgetsTable(this);
  late final $TrackedSuppliesTable trackedSupplies =
      $TrackedSuppliesTable(this);
  late final $ConsumptionRecordsTable consumptionRecords =
      $ConsumptionRecordsTable(this);
  late final $SupplyPredictionsTable supplyPredictions =
      $SupplyPredictionsTable(this);
  late final $RecurringBillsTable recurringBills = $RecurringBillsTable(this);
  late final $HouseholdNotificationsTable householdNotifications =
      $HouseholdNotificationsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        households,
        householdMembers,
        expenseCategories,
        householdWallets,
        contributions,
        expenses,
        walletTransactions,
        householdBudgets,
        trackedSupplies,
        consumptionRecords,
        supplyPredictions,
        recurringBills,
        householdNotifications,
        auditLogs,
        syncQueue
      ];
}

typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  required String id,
  required String ownerId,
  required String name,
  Value<String?> description,
  Value<String?> address,
  Value<String> currencyCode,
  Value<String> currencySymbol,
  Value<String> timezone,
  Value<bool> allowOverdraft,
  Value<int> lowBalanceThresholdCents,
  Value<bool> isArchived,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<String?> description,
  Value<String?> address,
  Value<String> currencyCode,
  Value<String> currencySymbol,
  Value<String> timezone,
  Value<bool> allowOverdraft,
  Value<int> lowBalanceThresholdCents,
  Value<bool> isArchived,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allowOverdraft => $composableBuilder(
      column: $table.allowOverdraft,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lowBalanceThresholdCents => $composableBuilder(
      column: $table.lowBalanceThresholdCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowOverdraft => $composableBuilder(
      column: $table.allowOverdraft,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lowBalanceThresholdCents => $composableBuilder(
      column: $table.lowBalanceThresholdCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<bool> get allowOverdraft => $composableBuilder(
      column: $table.allowOverdraft, builder: (column) => column);

  GeneratedColumn<int> get lowBalanceThresholdCents => $composableBuilder(
      column: $table.lowBalanceThresholdCents, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HouseholdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    HouseholdRow,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (
      HouseholdRow,
      BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdRow>
    ),
    HouseholdRow,
    PrefetchHooks Function()> {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            Value<bool> allowOverdraft = const Value.absent(),
            Value<int> lowBalanceThresholdCents = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            description: description,
            address: address,
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
            timezone: timezone,
            allowOverdraft: allowOverdraft,
            lowBalanceThresholdCents: lowBalanceThresholdCents,
            isArchived: isArchived,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            Value<bool> allowOverdraft = const Value.absent(),
            Value<int> lowBalanceThresholdCents = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            description: description,
            address: address,
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
            timezone: timezone,
            allowOverdraft: allowOverdraft,
            lowBalanceThresholdCents: lowBalanceThresholdCents,
            isArchived: isArchived,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    HouseholdRow,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (
      HouseholdRow,
      BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdRow>
    ),
    HouseholdRow,
    PrefetchHooks Function()>;
typedef $$HouseholdMembersTableCreateCompanionBuilder
    = HouseholdMembersCompanion Function({
  required String id,
  required String householdId,
  Value<String?> linkedUserId,
  required String displayName,
  Value<String?> email,
  Value<String?> phoneNumber,
  Value<String> role,
  Value<String> avatarColor,
  Value<bool> isActive,
  Value<int> version,
  required DateTime joinedAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdMembersTableUpdateCompanionBuilder
    = HouseholdMembersCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String?> linkedUserId,
  Value<String> displayName,
  Value<String?> email,
  Value<String?> phoneNumber,
  Value<String> role,
  Value<String> avatarColor,
  Value<bool> isActive,
  Value<int> version,
  Value<DateTime> joinedAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$HouseholdMembersTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarColor => $composableBuilder(
      column: $table.avatarColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HouseholdMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarColor => $composableBuilder(
      column: $table.avatarColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get avatarColor => $composableBuilder(
      column: $table.avatarColor, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HouseholdMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMemberRow,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (
      HouseholdMemberRow,
      BaseReferences<_$AppDatabase, $HouseholdMembersTable, HouseholdMemberRow>
    ),
    HouseholdMemberRow,
    PrefetchHooks Function()> {
  $$HouseholdMembersTableTableManager(
      _$AppDatabase db, $HouseholdMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String?> linkedUserId = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> avatarColor = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> joinedAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion(
            id: id,
            householdId: householdId,
            linkedUserId: linkedUserId,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            role: role,
            avatarColor: avatarColor,
            isActive: isActive,
            version: version,
            joinedAt: joinedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            Value<String?> linkedUserId = const Value.absent(),
            required String displayName,
            Value<String?> email = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> avatarColor = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime joinedAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion.insert(
            id: id,
            householdId: householdId,
            linkedUserId: linkedUserId,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            role: role,
            avatarColor: avatarColor,
            isActive: isActive,
            version: version,
            joinedAt: joinedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMemberRow,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (
      HouseholdMemberRow,
      BaseReferences<_$AppDatabase, $HouseholdMembersTable, HouseholdMemberRow>
    ),
    HouseholdMemberRow,
    PrefetchHooks Function()>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  required String id,
  required String householdId,
  required String name,
  required String slug,
  Value<String> iconName,
  Value<String> colorHex,
  Value<bool> isDefault,
  Value<bool> isActive,
  Value<bool> tracksConsumption,
  Value<String> supplyType,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> name,
  Value<String> slug,
  Value<String> iconName,
  Value<String> colorHex,
  Value<bool> isDefault,
  Value<bool> isActive,
  Value<bool> tracksConsumption,
  Value<String> supplyType,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tracksConsumption => $composableBuilder(
      column: $table.tracksConsumption,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tracksConsumption => $composableBuilder(
      column: $table.tracksConsumption,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get tracksConsumption => $composableBuilder(
      column: $table.tracksConsumption, builder: (column) => column);

  GeneratedColumn<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategoryRow,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategoryRow,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategoryRow>
    ),
    ExpenseCategoryRow,
    PrefetchHooks Function()> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> tracksConsumption = const Value.absent(),
            Value<String> supplyType = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            householdId: householdId,
            name: name,
            slug: slug,
            iconName: iconName,
            colorHex: colorHex,
            isDefault: isDefault,
            isActive: isActive,
            tracksConsumption: tracksConsumption,
            supplyType: supplyType,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String name,
            required String slug,
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> tracksConsumption = const Value.absent(),
            Value<String> supplyType = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            householdId: householdId,
            name: name,
            slug: slug,
            iconName: iconName,
            colorHex: colorHex,
            isDefault: isDefault,
            isActive: isActive,
            tracksConsumption: tracksConsumption,
            supplyType: supplyType,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategoryRow,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategoryRow,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategoryRow>
    ),
    ExpenseCategoryRow,
    PrefetchHooks Function()>;
typedef $$HouseholdWalletsTableCreateCompanionBuilder
    = HouseholdWalletsCompanion Function({
  required String id,
  required String householdId,
  Value<int> totalContributionsCents,
  Value<int> totalExpensesCents,
  Value<int> totalAdjustmentsCents,
  Value<int> availableBalanceCents,
  Value<int> version,
  Value<DateTime?> lastTransactionAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdWalletsTableUpdateCompanionBuilder
    = HouseholdWalletsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<int> totalContributionsCents,
  Value<int> totalExpensesCents,
  Value<int> totalAdjustmentsCents,
  Value<int> availableBalanceCents,
  Value<int> version,
  Value<DateTime?> lastTransactionAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$HouseholdWalletsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdWalletsTable> {
  $$HouseholdWalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalContributionsCents => $composableBuilder(
      column: $table.totalContributionsCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalExpensesCents => $composableBuilder(
      column: $table.totalExpensesCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAdjustmentsCents => $composableBuilder(
      column: $table.totalAdjustmentsCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableBalanceCents => $composableBuilder(
      column: $table.availableBalanceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastTransactionAt => $composableBuilder(
      column: $table.lastTransactionAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HouseholdWalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdWalletsTable> {
  $$HouseholdWalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalContributionsCents => $composableBuilder(
      column: $table.totalContributionsCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalExpensesCents => $composableBuilder(
      column: $table.totalExpensesCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAdjustmentsCents => $composableBuilder(
      column: $table.totalAdjustmentsCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableBalanceCents => $composableBuilder(
      column: $table.availableBalanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastTransactionAt => $composableBuilder(
      column: $table.lastTransactionAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdWalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdWalletsTable> {
  $$HouseholdWalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<int> get totalContributionsCents => $composableBuilder(
      column: $table.totalContributionsCents, builder: (column) => column);

  GeneratedColumn<int> get totalExpensesCents => $composableBuilder(
      column: $table.totalExpensesCents, builder: (column) => column);

  GeneratedColumn<int> get totalAdjustmentsCents => $composableBuilder(
      column: $table.totalAdjustmentsCents, builder: (column) => column);

  GeneratedColumn<int> get availableBalanceCents => $composableBuilder(
      column: $table.availableBalanceCents, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get lastTransactionAt => $composableBuilder(
      column: $table.lastTransactionAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HouseholdWalletsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdWalletsTable,
    HouseholdWalletRow,
    $$HouseholdWalletsTableFilterComposer,
    $$HouseholdWalletsTableOrderingComposer,
    $$HouseholdWalletsTableAnnotationComposer,
    $$HouseholdWalletsTableCreateCompanionBuilder,
    $$HouseholdWalletsTableUpdateCompanionBuilder,
    (
      HouseholdWalletRow,
      BaseReferences<_$AppDatabase, $HouseholdWalletsTable, HouseholdWalletRow>
    ),
    HouseholdWalletRow,
    PrefetchHooks Function()> {
  $$HouseholdWalletsTableTableManager(
      _$AppDatabase db, $HouseholdWalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdWalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdWalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdWalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<int> totalContributionsCents = const Value.absent(),
            Value<int> totalExpensesCents = const Value.absent(),
            Value<int> totalAdjustmentsCents = const Value.absent(),
            Value<int> availableBalanceCents = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime?> lastTransactionAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdWalletsCompanion(
            id: id,
            householdId: householdId,
            totalContributionsCents: totalContributionsCents,
            totalExpensesCents: totalExpensesCents,
            totalAdjustmentsCents: totalAdjustmentsCents,
            availableBalanceCents: availableBalanceCents,
            version: version,
            lastTransactionAt: lastTransactionAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            Value<int> totalContributionsCents = const Value.absent(),
            Value<int> totalExpensesCents = const Value.absent(),
            Value<int> totalAdjustmentsCents = const Value.absent(),
            Value<int> availableBalanceCents = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime?> lastTransactionAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdWalletsCompanion.insert(
            id: id,
            householdId: householdId,
            totalContributionsCents: totalContributionsCents,
            totalExpensesCents: totalExpensesCents,
            totalAdjustmentsCents: totalAdjustmentsCents,
            availableBalanceCents: availableBalanceCents,
            version: version,
            lastTransactionAt: lastTransactionAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdWalletsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdWalletsTable,
    HouseholdWalletRow,
    $$HouseholdWalletsTableFilterComposer,
    $$HouseholdWalletsTableOrderingComposer,
    $$HouseholdWalletsTableAnnotationComposer,
    $$HouseholdWalletsTableCreateCompanionBuilder,
    $$HouseholdWalletsTableUpdateCompanionBuilder,
    (
      HouseholdWalletRow,
      BaseReferences<_$AppDatabase, $HouseholdWalletsTable, HouseholdWalletRow>
    ),
    HouseholdWalletRow,
    PrefetchHooks Function()>;
typedef $$ContributionsTableCreateCompanionBuilder = ContributionsCompanion
    Function({
  required String id,
  required String householdId,
  required String memberId,
  required String memberName,
  required String recordedBy,
  required int amountCents,
  required DateTime contributionDate,
  Value<String?> description,
  Value<String> status,
  required String idempotencyKey,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$ContributionsTableUpdateCompanionBuilder = ContributionsCompanion
    Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> memberId,
  Value<String> memberName,
  Value<String> recordedBy,
  Value<int> amountCents,
  Value<DateTime> contributionDate,
  Value<String?> description,
  Value<String> status,
  Value<String> idempotencyKey,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$ContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberId => $composableBuilder(
      column: $table.memberId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get contributionDate => $composableBuilder(
      column: $table.contributionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberId => $composableBuilder(
      column: $table.memberId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get contributionDate => $composableBuilder(
      column: $table.contributionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContributionsTable> {
  $$ContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<DateTime> get contributionDate => $composableBuilder(
      column: $table.contributionDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContributionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContributionsTable,
    ContributionRow,
    $$ContributionsTableFilterComposer,
    $$ContributionsTableOrderingComposer,
    $$ContributionsTableAnnotationComposer,
    $$ContributionsTableCreateCompanionBuilder,
    $$ContributionsTableUpdateCompanionBuilder,
    (
      ContributionRow,
      BaseReferences<_$AppDatabase, $ContributionsTable, ContributionRow>
    ),
    ContributionRow,
    PrefetchHooks Function()> {
  $$ContributionsTableTableManager(_$AppDatabase db, $ContributionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContributionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> memberId = const Value.absent(),
            Value<String> memberName = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<DateTime> contributionDate = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContributionsCompanion(
            id: id,
            householdId: householdId,
            memberId: memberId,
            memberName: memberName,
            recordedBy: recordedBy,
            amountCents: amountCents,
            contributionDate: contributionDate,
            description: description,
            status: status,
            idempotencyKey: idempotencyKey,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String memberId,
            required String memberName,
            required String recordedBy,
            required int amountCents,
            required DateTime contributionDate,
            Value<String?> description = const Value.absent(),
            Value<String> status = const Value.absent(),
            required String idempotencyKey,
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContributionsCompanion.insert(
            id: id,
            householdId: householdId,
            memberId: memberId,
            memberName: memberName,
            recordedBy: recordedBy,
            amountCents: amountCents,
            contributionDate: contributionDate,
            description: description,
            status: status,
            idempotencyKey: idempotencyKey,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContributionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContributionsTable,
    ContributionRow,
    $$ContributionsTableFilterComposer,
    $$ContributionsTableOrderingComposer,
    $$ContributionsTableAnnotationComposer,
    $$ContributionsTableCreateCompanionBuilder,
    $$ContributionsTableUpdateCompanionBuilder,
    (
      ContributionRow,
      BaseReferences<_$AppDatabase, $ContributionsTable, ContributionRow>
    ),
    ContributionRow,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  required String id,
  required String householdId,
  required String categoryId,
  required String categoryName,
  required String paidByMemberId,
  required String paidByMemberName,
  required String recordedBy,
  required String title,
  required int amountCents,
  required DateTime expenseDate,
  Value<String?> notes,
  Value<String?> receiptUrl,
  Value<String> status,
  required String idempotencyKey,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> categoryId,
  Value<String> categoryName,
  Value<String> paidByMemberId,
  Value<String> paidByMemberName,
  Value<String> recordedBy,
  Value<String> title,
  Value<int> amountCents,
  Value<DateTime> expenseDate,
  Value<String?> notes,
  Value<String?> receiptUrl,
  Value<String> status,
  Value<String> idempotencyKey,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidByMemberId => $composableBuilder(
      column: $table.paidByMemberId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidByMemberName => $composableBuilder(
      column: $table.paidByMemberName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidByMemberId => $composableBuilder(
      column: $table.paidByMemberId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidByMemberName => $composableBuilder(
      column: $table.paidByMemberName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get paidByMemberId => $composableBuilder(
      column: $table.paidByMemberId, builder: (column) => column);

  GeneratedColumn<String> get paidByMemberName => $composableBuilder(
      column: $table.paidByMemberName, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    ExpenseRow,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
    ExpenseRow,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<String> paidByMemberId = const Value.absent(),
            Value<String> paidByMemberName = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> receiptUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            paidByMemberId: paidByMemberId,
            paidByMemberName: paidByMemberName,
            recordedBy: recordedBy,
            title: title,
            amountCents: amountCents,
            expenseDate: expenseDate,
            notes: notes,
            receiptUrl: receiptUrl,
            status: status,
            idempotencyKey: idempotencyKey,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String categoryId,
            required String categoryName,
            required String paidByMemberId,
            required String paidByMemberName,
            required String recordedBy,
            required String title,
            required int amountCents,
            required DateTime expenseDate,
            Value<String?> notes = const Value.absent(),
            Value<String?> receiptUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            required String idempotencyKey,
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            paidByMemberId: paidByMemberId,
            paidByMemberName: paidByMemberName,
            recordedBy: recordedBy,
            title: title,
            amountCents: amountCents,
            expenseDate: expenseDate,
            notes: notes,
            receiptUrl: receiptUrl,
            status: status,
            idempotencyKey: idempotencyKey,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    ExpenseRow,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
    ExpenseRow,
    PrefetchHooks Function()>;
typedef $$WalletTransactionsTableCreateCompanionBuilder
    = WalletTransactionsCompanion Function({
  required String id,
  required String householdId,
  required String walletId,
  required String transactionType,
  Value<String?> referenceContributionId,
  Value<String?> referenceExpenseId,
  Value<String?> parentTransactionId,
  Value<String?> memberId,
  required String memberName,
  Value<String?> categoryId,
  required String categoryName,
  required int amountCents,
  required int signedAmountCents,
  required int balanceBeforeCents,
  required int balanceAfterCents,
  required DateTime transactionDate,
  required String description,
  required String recordedBy,
  Value<int> version,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$WalletTransactionsTableUpdateCompanionBuilder
    = WalletTransactionsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> walletId,
  Value<String> transactionType,
  Value<String?> referenceContributionId,
  Value<String?> referenceExpenseId,
  Value<String?> parentTransactionId,
  Value<String?> memberId,
  Value<String> memberName,
  Value<String?> categoryId,
  Value<String> categoryName,
  Value<int> amountCents,
  Value<int> signedAmountCents,
  Value<int> balanceBeforeCents,
  Value<int> balanceAfterCents,
  Value<DateTime> transactionDate,
  Value<String> description,
  Value<String> recordedBy,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$WalletTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceContributionId => $composableBuilder(
      column: $table.referenceContributionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceExpenseId => $composableBuilder(
      column: $table.referenceExpenseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentTransactionId => $composableBuilder(
      column: $table.parentTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberId => $composableBuilder(
      column: $table.memberId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get signedAmountCents => $composableBuilder(
      column: $table.signedAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balanceBeforeCents => $composableBuilder(
      column: $table.balanceBeforeCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balanceAfterCents => $composableBuilder(
      column: $table.balanceAfterCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$WalletTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionType => $composableBuilder(
      column: $table.transactionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceContributionId => $composableBuilder(
      column: $table.referenceContributionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceExpenseId => $composableBuilder(
      column: $table.referenceExpenseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentTransactionId => $composableBuilder(
      column: $table.parentTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberId => $composableBuilder(
      column: $table.memberId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get signedAmountCents => $composableBuilder(
      column: $table.signedAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balanceBeforeCents => $composableBuilder(
      column: $table.balanceBeforeCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balanceAfterCents => $composableBuilder(
      column: $table.balanceAfterCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$WalletTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
      column: $table.transactionType, builder: (column) => column);

  GeneratedColumn<String> get referenceContributionId => $composableBuilder(
      column: $table.referenceContributionId, builder: (column) => column);

  GeneratedColumn<String> get referenceExpenseId => $composableBuilder(
      column: $table.referenceExpenseId, builder: (column) => column);

  GeneratedColumn<String> get parentTransactionId => $composableBuilder(
      column: $table.parentTransactionId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<int> get signedAmountCents => $composableBuilder(
      column: $table.signedAmountCents, builder: (column) => column);

  GeneratedColumn<int> get balanceBeforeCents => $composableBuilder(
      column: $table.balanceBeforeCents, builder: (column) => column);

  GeneratedColumn<int> get balanceAfterCents => $composableBuilder(
      column: $table.balanceAfterCents, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WalletTransactionsTable,
    WalletTransactionRow,
    $$WalletTransactionsTableFilterComposer,
    $$WalletTransactionsTableOrderingComposer,
    $$WalletTransactionsTableAnnotationComposer,
    $$WalletTransactionsTableCreateCompanionBuilder,
    $$WalletTransactionsTableUpdateCompanionBuilder,
    (
      WalletTransactionRow,
      BaseReferences<_$AppDatabase, $WalletTransactionsTable,
          WalletTransactionRow>
    ),
    WalletTransactionRow,
    PrefetchHooks Function()> {
  $$WalletTransactionsTableTableManager(
      _$AppDatabase db, $WalletTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> walletId = const Value.absent(),
            Value<String> transactionType = const Value.absent(),
            Value<String?> referenceContributionId = const Value.absent(),
            Value<String?> referenceExpenseId = const Value.absent(),
            Value<String?> parentTransactionId = const Value.absent(),
            Value<String?> memberId = const Value.absent(),
            Value<String> memberName = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<int> signedAmountCents = const Value.absent(),
            Value<int> balanceBeforeCents = const Value.absent(),
            Value<int> balanceAfterCents = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WalletTransactionsCompanion(
            id: id,
            householdId: householdId,
            walletId: walletId,
            transactionType: transactionType,
            referenceContributionId: referenceContributionId,
            referenceExpenseId: referenceExpenseId,
            parentTransactionId: parentTransactionId,
            memberId: memberId,
            memberName: memberName,
            categoryId: categoryId,
            categoryName: categoryName,
            amountCents: amountCents,
            signedAmountCents: signedAmountCents,
            balanceBeforeCents: balanceBeforeCents,
            balanceAfterCents: balanceAfterCents,
            transactionDate: transactionDate,
            description: description,
            recordedBy: recordedBy,
            version: version,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String walletId,
            required String transactionType,
            Value<String?> referenceContributionId = const Value.absent(),
            Value<String?> referenceExpenseId = const Value.absent(),
            Value<String?> parentTransactionId = const Value.absent(),
            Value<String?> memberId = const Value.absent(),
            required String memberName,
            Value<String?> categoryId = const Value.absent(),
            required String categoryName,
            required int amountCents,
            required int signedAmountCents,
            required int balanceBeforeCents,
            required int balanceAfterCents,
            required DateTime transactionDate,
            required String description,
            required String recordedBy,
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WalletTransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            walletId: walletId,
            transactionType: transactionType,
            referenceContributionId: referenceContributionId,
            referenceExpenseId: referenceExpenseId,
            parentTransactionId: parentTransactionId,
            memberId: memberId,
            memberName: memberName,
            categoryId: categoryId,
            categoryName: categoryName,
            amountCents: amountCents,
            signedAmountCents: signedAmountCents,
            balanceBeforeCents: balanceBeforeCents,
            balanceAfterCents: balanceAfterCents,
            transactionDate: transactionDate,
            description: description,
            recordedBy: recordedBy,
            version: version,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WalletTransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WalletTransactionsTable,
    WalletTransactionRow,
    $$WalletTransactionsTableFilterComposer,
    $$WalletTransactionsTableOrderingComposer,
    $$WalletTransactionsTableAnnotationComposer,
    $$WalletTransactionsTableCreateCompanionBuilder,
    $$WalletTransactionsTableUpdateCompanionBuilder,
    (
      WalletTransactionRow,
      BaseReferences<_$AppDatabase, $WalletTransactionsTable,
          WalletTransactionRow>
    ),
    WalletTransactionRow,
    PrefetchHooks Function()>;
typedef $$HouseholdBudgetsTableCreateCompanionBuilder
    = HouseholdBudgetsCompanion Function({
  required String id,
  required String householdId,
  required String categoryId,
  required String categoryName,
  required DateTime budgetMonth,
  required int budgetAmountCents,
  Value<int> alertThresholdPercent,
  Value<bool> isActive,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdBudgetsTableUpdateCompanionBuilder
    = HouseholdBudgetsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> categoryId,
  Value<String> categoryName,
  Value<DateTime> budgetMonth,
  Value<int> budgetAmountCents,
  Value<int> alertThresholdPercent,
  Value<bool> isActive,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$HouseholdBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdBudgetsTable> {
  $$HouseholdBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get budgetMonth => $composableBuilder(
      column: $table.budgetMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budgetAmountCents => $composableBuilder(
      column: $table.budgetAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HouseholdBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdBudgetsTable> {
  $$HouseholdBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get budgetMonth => $composableBuilder(
      column: $table.budgetMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budgetAmountCents => $composableBuilder(
      column: $table.budgetAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdBudgetsTable> {
  $$HouseholdBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<DateTime> get budgetMonth => $composableBuilder(
      column: $table.budgetMonth, builder: (column) => column);

  GeneratedColumn<int> get budgetAmountCents => $composableBuilder(
      column: $table.budgetAmountCents, builder: (column) => column);

  GeneratedColumn<int> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HouseholdBudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdBudgetsTable,
    HouseholdBudgetRow,
    $$HouseholdBudgetsTableFilterComposer,
    $$HouseholdBudgetsTableOrderingComposer,
    $$HouseholdBudgetsTableAnnotationComposer,
    $$HouseholdBudgetsTableCreateCompanionBuilder,
    $$HouseholdBudgetsTableUpdateCompanionBuilder,
    (
      HouseholdBudgetRow,
      BaseReferences<_$AppDatabase, $HouseholdBudgetsTable, HouseholdBudgetRow>
    ),
    HouseholdBudgetRow,
    PrefetchHooks Function()> {
  $$HouseholdBudgetsTableTableManager(
      _$AppDatabase db, $HouseholdBudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<DateTime> budgetMonth = const Value.absent(),
            Value<int> budgetAmountCents = const Value.absent(),
            Value<int> alertThresholdPercent = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdBudgetsCompanion(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            budgetMonth: budgetMonth,
            budgetAmountCents: budgetAmountCents,
            alertThresholdPercent: alertThresholdPercent,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String categoryId,
            required String categoryName,
            required DateTime budgetMonth,
            required int budgetAmountCents,
            Value<int> alertThresholdPercent = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdBudgetsCompanion.insert(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            budgetMonth: budgetMonth,
            budgetAmountCents: budgetAmountCents,
            alertThresholdPercent: alertThresholdPercent,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdBudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdBudgetsTable,
    HouseholdBudgetRow,
    $$HouseholdBudgetsTableFilterComposer,
    $$HouseholdBudgetsTableOrderingComposer,
    $$HouseholdBudgetsTableAnnotationComposer,
    $$HouseholdBudgetsTableCreateCompanionBuilder,
    $$HouseholdBudgetsTableUpdateCompanionBuilder,
    (
      HouseholdBudgetRow,
      BaseReferences<_$AppDatabase, $HouseholdBudgetsTable, HouseholdBudgetRow>
    ),
    HouseholdBudgetRow,
    PrefetchHooks Function()>;
typedef $$TrackedSuppliesTableCreateCompanionBuilder = TrackedSuppliesCompanion
    Function({
  required String id,
  required String householdId,
  Value<String?> categoryId,
  required String name,
  required String supplyType,
  required String defaultUnit,
  Value<bool> isActive,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$TrackedSuppliesTableUpdateCompanionBuilder = TrackedSuppliesCompanion
    Function({
  Value<String> id,
  Value<String> householdId,
  Value<String?> categoryId,
  Value<String> name,
  Value<String> supplyType,
  Value<String> defaultUnit,
  Value<bool> isActive,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$TrackedSuppliesTableFilterComposer
    extends Composer<_$AppDatabase, $TrackedSuppliesTable> {
  $$TrackedSuppliesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TrackedSuppliesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackedSuppliesTable> {
  $$TrackedSuppliesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TrackedSuppliesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackedSuppliesTable> {
  $$TrackedSuppliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TrackedSuppliesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrackedSuppliesTable,
    TrackedSupplyRow,
    $$TrackedSuppliesTableFilterComposer,
    $$TrackedSuppliesTableOrderingComposer,
    $$TrackedSuppliesTableAnnotationComposer,
    $$TrackedSuppliesTableCreateCompanionBuilder,
    $$TrackedSuppliesTableUpdateCompanionBuilder,
    (
      TrackedSupplyRow,
      BaseReferences<_$AppDatabase, $TrackedSuppliesTable, TrackedSupplyRow>
    ),
    TrackedSupplyRow,
    PrefetchHooks Function()> {
  $$TrackedSuppliesTableTableManager(
      _$AppDatabase db, $TrackedSuppliesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackedSuppliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackedSuppliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackedSuppliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> supplyType = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrackedSuppliesCompanion(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            name: name,
            supplyType: supplyType,
            defaultUnit: defaultUnit,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            Value<String?> categoryId = const Value.absent(),
            required String name,
            required String supplyType,
            required String defaultUnit,
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrackedSuppliesCompanion.insert(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            name: name,
            supplyType: supplyType,
            defaultUnit: defaultUnit,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrackedSuppliesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrackedSuppliesTable,
    TrackedSupplyRow,
    $$TrackedSuppliesTableFilterComposer,
    $$TrackedSuppliesTableOrderingComposer,
    $$TrackedSuppliesTableAnnotationComposer,
    $$TrackedSuppliesTableCreateCompanionBuilder,
    $$TrackedSuppliesTableUpdateCompanionBuilder,
    (
      TrackedSupplyRow,
      BaseReferences<_$AppDatabase, $TrackedSuppliesTable, TrackedSupplyRow>
    ),
    TrackedSupplyRow,
    PrefetchHooks Function()>;
typedef $$ConsumptionRecordsTableCreateCompanionBuilder
    = ConsumptionRecordsCompanion Function({
  required String id,
  required String householdId,
  required String supplyId,
  required String supplyName,
  required String supplyType,
  Value<String?> expenseId,
  required DateTime purchaseDate,
  required int amountPaidCents,
  Value<double?> quantity,
  required String unit,
  Value<String> previousExhaustedState,
  Value<double?> remainingUnits,
  Value<double?> remainingPercentage,
  Value<double?> cylinderWeightKg,
  Value<int?> userEstimatedDurationDays,
  Value<DateTime?> actualDepletionDate,
  Value<String?> notes,
  required String recordedBy,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$ConsumptionRecordsTableUpdateCompanionBuilder
    = ConsumptionRecordsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> supplyId,
  Value<String> supplyName,
  Value<String> supplyType,
  Value<String?> expenseId,
  Value<DateTime> purchaseDate,
  Value<int> amountPaidCents,
  Value<double?> quantity,
  Value<String> unit,
  Value<String> previousExhaustedState,
  Value<double?> remainingUnits,
  Value<double?> remainingPercentage,
  Value<double?> cylinderWeightKg,
  Value<int?> userEstimatedDurationDays,
  Value<DateTime?> actualDepletionDate,
  Value<String?> notes,
  Value<String> recordedBy,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$ConsumptionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsumptionRecordsTable> {
  $$ConsumptionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyId => $composableBuilder(
      column: $table.supplyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaidCents => $composableBuilder(
      column: $table.amountPaidCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousExhaustedState => $composableBuilder(
      column: $table.previousExhaustedState,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingUnits => $composableBuilder(
      column: $table.remainingUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingPercentage => $composableBuilder(
      column: $table.remainingPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cylinderWeightKg => $composableBuilder(
      column: $table.cylinderWeightKg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userEstimatedDurationDays => $composableBuilder(
      column: $table.userEstimatedDurationDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualDepletionDate => $composableBuilder(
      column: $table.actualDepletionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ConsumptionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsumptionRecordsTable> {
  $$ConsumptionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyId => $composableBuilder(
      column: $table.supplyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expenseId => $composableBuilder(
      column: $table.expenseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaidCents => $composableBuilder(
      column: $table.amountPaidCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousExhaustedState => $composableBuilder(
      column: $table.previousExhaustedState,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingUnits => $composableBuilder(
      column: $table.remainingUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingPercentage => $composableBuilder(
      column: $table.remainingPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cylinderWeightKg => $composableBuilder(
      column: $table.cylinderWeightKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userEstimatedDurationDays => $composableBuilder(
      column: $table.userEstimatedDurationDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualDepletionDate => $composableBuilder(
      column: $table.actualDepletionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConsumptionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsumptionRecordsTable> {
  $$ConsumptionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get supplyId =>
      $composableBuilder(column: $table.supplyId, builder: (column) => column);

  GeneratedColumn<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => column);

  GeneratedColumn<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => column);

  GeneratedColumn<String> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<int> get amountPaidCents => $composableBuilder(
      column: $table.amountPaidCents, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get previousExhaustedState => $composableBuilder(
      column: $table.previousExhaustedState, builder: (column) => column);

  GeneratedColumn<double> get remainingUnits => $composableBuilder(
      column: $table.remainingUnits, builder: (column) => column);

  GeneratedColumn<double> get remainingPercentage => $composableBuilder(
      column: $table.remainingPercentage, builder: (column) => column);

  GeneratedColumn<double> get cylinderWeightKg => $composableBuilder(
      column: $table.cylinderWeightKg, builder: (column) => column);

  GeneratedColumn<int> get userEstimatedDurationDays => $composableBuilder(
      column: $table.userEstimatedDurationDays, builder: (column) => column);

  GeneratedColumn<DateTime> get actualDepletionDate => $composableBuilder(
      column: $table.actualDepletionDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ConsumptionRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConsumptionRecordsTable,
    ConsumptionRecordRow,
    $$ConsumptionRecordsTableFilterComposer,
    $$ConsumptionRecordsTableOrderingComposer,
    $$ConsumptionRecordsTableAnnotationComposer,
    $$ConsumptionRecordsTableCreateCompanionBuilder,
    $$ConsumptionRecordsTableUpdateCompanionBuilder,
    (
      ConsumptionRecordRow,
      BaseReferences<_$AppDatabase, $ConsumptionRecordsTable,
          ConsumptionRecordRow>
    ),
    ConsumptionRecordRow,
    PrefetchHooks Function()> {
  $$ConsumptionRecordsTableTableManager(
      _$AppDatabase db, $ConsumptionRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsumptionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsumptionRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsumptionRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> supplyId = const Value.absent(),
            Value<String> supplyName = const Value.absent(),
            Value<String> supplyType = const Value.absent(),
            Value<String?> expenseId = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<int> amountPaidCents = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> previousExhaustedState = const Value.absent(),
            Value<double?> remainingUnits = const Value.absent(),
            Value<double?> remainingPercentage = const Value.absent(),
            Value<double?> cylinderWeightKg = const Value.absent(),
            Value<int?> userEstimatedDurationDays = const Value.absent(),
            Value<DateTime?> actualDepletionDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsumptionRecordsCompanion(
            id: id,
            householdId: householdId,
            supplyId: supplyId,
            supplyName: supplyName,
            supplyType: supplyType,
            expenseId: expenseId,
            purchaseDate: purchaseDate,
            amountPaidCents: amountPaidCents,
            quantity: quantity,
            unit: unit,
            previousExhaustedState: previousExhaustedState,
            remainingUnits: remainingUnits,
            remainingPercentage: remainingPercentage,
            cylinderWeightKg: cylinderWeightKg,
            userEstimatedDurationDays: userEstimatedDurationDays,
            actualDepletionDate: actualDepletionDate,
            notes: notes,
            recordedBy: recordedBy,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String supplyId,
            required String supplyName,
            required String supplyType,
            Value<String?> expenseId = const Value.absent(),
            required DateTime purchaseDate,
            required int amountPaidCents,
            Value<double?> quantity = const Value.absent(),
            required String unit,
            Value<String> previousExhaustedState = const Value.absent(),
            Value<double?> remainingUnits = const Value.absent(),
            Value<double?> remainingPercentage = const Value.absent(),
            Value<double?> cylinderWeightKg = const Value.absent(),
            Value<int?> userEstimatedDurationDays = const Value.absent(),
            Value<DateTime?> actualDepletionDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String recordedBy,
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsumptionRecordsCompanion.insert(
            id: id,
            householdId: householdId,
            supplyId: supplyId,
            supplyName: supplyName,
            supplyType: supplyType,
            expenseId: expenseId,
            purchaseDate: purchaseDate,
            amountPaidCents: amountPaidCents,
            quantity: quantity,
            unit: unit,
            previousExhaustedState: previousExhaustedState,
            remainingUnits: remainingUnits,
            remainingPercentage: remainingPercentage,
            cylinderWeightKg: cylinderWeightKg,
            userEstimatedDurationDays: userEstimatedDurationDays,
            actualDepletionDate: actualDepletionDate,
            notes: notes,
            recordedBy: recordedBy,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConsumptionRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConsumptionRecordsTable,
    ConsumptionRecordRow,
    $$ConsumptionRecordsTableFilterComposer,
    $$ConsumptionRecordsTableOrderingComposer,
    $$ConsumptionRecordsTableAnnotationComposer,
    $$ConsumptionRecordsTableCreateCompanionBuilder,
    $$ConsumptionRecordsTableUpdateCompanionBuilder,
    (
      ConsumptionRecordRow,
      BaseReferences<_$AppDatabase, $ConsumptionRecordsTable,
          ConsumptionRecordRow>
    ),
    ConsumptionRecordRow,
    PrefetchHooks Function()>;
typedef $$SupplyPredictionsTableCreateCompanionBuilder
    = SupplyPredictionsCompanion Function({
  required String id,
  required String householdId,
  required String supplyId,
  required String supplyName,
  required String supplyType,
  required String unit,
  Value<int> sampleCount,
  Value<int> confirmedCycleCount,
  Value<double?> averageIntervalDays,
  Value<double?> medianIntervalDays,
  Value<double?> weightedIntervalDays,
  Value<double?> intervalStdDevDays,
  Value<int?> averagePurchaseAmountCents,
  Value<double?> averageDailyConsumptionUnits,
  Value<int?> averageDailyCostCents,
  Value<DateTime?> lastPurchaseDate,
  Value<DateTime?> estimatedNextReplenishmentDate,
  Value<DateTime?> manualOverrideDate,
  Value<DateTime?> actualConfirmedDepletionDate,
  Value<String> confidenceLevel,
  Value<int> confidenceScore,
  Value<bool> isMonetaryEstimateOnly,
  required String explanation,
  Value<String> trendDirection,
  Value<String> historicalIntervalsJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SupplyPredictionsTableUpdateCompanionBuilder
    = SupplyPredictionsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> supplyId,
  Value<String> supplyName,
  Value<String> supplyType,
  Value<String> unit,
  Value<int> sampleCount,
  Value<int> confirmedCycleCount,
  Value<double?> averageIntervalDays,
  Value<double?> medianIntervalDays,
  Value<double?> weightedIntervalDays,
  Value<double?> intervalStdDevDays,
  Value<int?> averagePurchaseAmountCents,
  Value<double?> averageDailyConsumptionUnits,
  Value<int?> averageDailyCostCents,
  Value<DateTime?> lastPurchaseDate,
  Value<DateTime?> estimatedNextReplenishmentDate,
  Value<DateTime?> manualOverrideDate,
  Value<DateTime?> actualConfirmedDepletionDate,
  Value<String> confidenceLevel,
  Value<int> confidenceScore,
  Value<bool> isMonetaryEstimateOnly,
  Value<String> explanation,
  Value<String> trendDirection,
  Value<String> historicalIntervalsJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SupplyPredictionsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplyPredictionsTable> {
  $$SupplyPredictionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyId => $composableBuilder(
      column: $table.supplyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get confirmedCycleCount => $composableBuilder(
      column: $table.confirmedCycleCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get averageIntervalDays => $composableBuilder(
      column: $table.averageIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get medianIntervalDays => $composableBuilder(
      column: $table.medianIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightedIntervalDays => $composableBuilder(
      column: $table.weightedIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get intervalStdDevDays => $composableBuilder(
      column: $table.intervalStdDevDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get averagePurchaseAmountCents => $composableBuilder(
      column: $table.averagePurchaseAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get averageDailyConsumptionUnits => $composableBuilder(
      column: $table.averageDailyConsumptionUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get averageDailyCostCents => $composableBuilder(
      column: $table.averageDailyCostCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPurchaseDate => $composableBuilder(
      column: $table.lastPurchaseDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get estimatedNextReplenishmentDate =>
      $composableBuilder(
          column: $table.estimatedNextReplenishmentDate,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get manualOverrideDate => $composableBuilder(
      column: $table.manualOverrideDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualConfirmedDepletionDate =>
      $composableBuilder(
          column: $table.actualConfirmedDepletionDate,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confidenceLevel => $composableBuilder(
      column: $table.confidenceLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMonetaryEstimateOnly => $composableBuilder(
      column: $table.isMonetaryEstimateOnly,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trendDirection => $composableBuilder(
      column: $table.trendDirection,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historicalIntervalsJson => $composableBuilder(
      column: $table.historicalIntervalsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SupplyPredictionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplyPredictionsTable> {
  $$SupplyPredictionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyId => $composableBuilder(
      column: $table.supplyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get confirmedCycleCount => $composableBuilder(
      column: $table.confirmedCycleCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get averageIntervalDays => $composableBuilder(
      column: $table.averageIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get medianIntervalDays => $composableBuilder(
      column: $table.medianIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightedIntervalDays => $composableBuilder(
      column: $table.weightedIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intervalStdDevDays => $composableBuilder(
      column: $table.intervalStdDevDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get averagePurchaseAmountCents => $composableBuilder(
      column: $table.averagePurchaseAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get averageDailyConsumptionUnits =>
      $composableBuilder(
          column: $table.averageDailyConsumptionUnits,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get averageDailyCostCents => $composableBuilder(
      column: $table.averageDailyCostCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPurchaseDate => $composableBuilder(
      column: $table.lastPurchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get estimatedNextReplenishmentDate =>
      $composableBuilder(
          column: $table.estimatedNextReplenishmentDate,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get manualOverrideDate => $composableBuilder(
      column: $table.manualOverrideDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualConfirmedDepletionDate =>
      $composableBuilder(
          column: $table.actualConfirmedDepletionDate,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confidenceLevel => $composableBuilder(
      column: $table.confidenceLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMonetaryEstimateOnly => $composableBuilder(
      column: $table.isMonetaryEstimateOnly,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trendDirection => $composableBuilder(
      column: $table.trendDirection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historicalIntervalsJson => $composableBuilder(
      column: $table.historicalIntervalsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SupplyPredictionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplyPredictionsTable> {
  $$SupplyPredictionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get supplyId =>
      $composableBuilder(column: $table.supplyId, builder: (column) => column);

  GeneratedColumn<String> get supplyName => $composableBuilder(
      column: $table.supplyName, builder: (column) => column);

  GeneratedColumn<String> get supplyType => $composableBuilder(
      column: $table.supplyType, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => column);

  GeneratedColumn<int> get confirmedCycleCount => $composableBuilder(
      column: $table.confirmedCycleCount, builder: (column) => column);

  GeneratedColumn<double> get averageIntervalDays => $composableBuilder(
      column: $table.averageIntervalDays, builder: (column) => column);

  GeneratedColumn<double> get medianIntervalDays => $composableBuilder(
      column: $table.medianIntervalDays, builder: (column) => column);

  GeneratedColumn<double> get weightedIntervalDays => $composableBuilder(
      column: $table.weightedIntervalDays, builder: (column) => column);

  GeneratedColumn<double> get intervalStdDevDays => $composableBuilder(
      column: $table.intervalStdDevDays, builder: (column) => column);

  GeneratedColumn<int> get averagePurchaseAmountCents => $composableBuilder(
      column: $table.averagePurchaseAmountCents, builder: (column) => column);

  GeneratedColumn<double> get averageDailyConsumptionUnits =>
      $composableBuilder(
          column: $table.averageDailyConsumptionUnits,
          builder: (column) => column);

  GeneratedColumn<int> get averageDailyCostCents => $composableBuilder(
      column: $table.averageDailyCostCents, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPurchaseDate => $composableBuilder(
      column: $table.lastPurchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get estimatedNextReplenishmentDate =>
      $composableBuilder(
          column: $table.estimatedNextReplenishmentDate,
          builder: (column) => column);

  GeneratedColumn<DateTime> get manualOverrideDate => $composableBuilder(
      column: $table.manualOverrideDate, builder: (column) => column);

  GeneratedColumn<DateTime> get actualConfirmedDepletionDate =>
      $composableBuilder(
          column: $table.actualConfirmedDepletionDate,
          builder: (column) => column);

  GeneratedColumn<String> get confidenceLevel => $composableBuilder(
      column: $table.confidenceLevel, builder: (column) => column);

  GeneratedColumn<int> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore, builder: (column) => column);

  GeneratedColumn<bool> get isMonetaryEstimateOnly => $composableBuilder(
      column: $table.isMonetaryEstimateOnly, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<String> get trendDirection => $composableBuilder(
      column: $table.trendDirection, builder: (column) => column);

  GeneratedColumn<String> get historicalIntervalsJson => $composableBuilder(
      column: $table.historicalIntervalsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SupplyPredictionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplyPredictionsTable,
    SupplyPredictionRow,
    $$SupplyPredictionsTableFilterComposer,
    $$SupplyPredictionsTableOrderingComposer,
    $$SupplyPredictionsTableAnnotationComposer,
    $$SupplyPredictionsTableCreateCompanionBuilder,
    $$SupplyPredictionsTableUpdateCompanionBuilder,
    (
      SupplyPredictionRow,
      BaseReferences<_$AppDatabase, $SupplyPredictionsTable,
          SupplyPredictionRow>
    ),
    SupplyPredictionRow,
    PrefetchHooks Function()> {
  $$SupplyPredictionsTableTableManager(
      _$AppDatabase db, $SupplyPredictionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplyPredictionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplyPredictionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplyPredictionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> supplyId = const Value.absent(),
            Value<String> supplyName = const Value.absent(),
            Value<String> supplyType = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> sampleCount = const Value.absent(),
            Value<int> confirmedCycleCount = const Value.absent(),
            Value<double?> averageIntervalDays = const Value.absent(),
            Value<double?> medianIntervalDays = const Value.absent(),
            Value<double?> weightedIntervalDays = const Value.absent(),
            Value<double?> intervalStdDevDays = const Value.absent(),
            Value<int?> averagePurchaseAmountCents = const Value.absent(),
            Value<double?> averageDailyConsumptionUnits = const Value.absent(),
            Value<int?> averageDailyCostCents = const Value.absent(),
            Value<DateTime?> lastPurchaseDate = const Value.absent(),
            Value<DateTime?> estimatedNextReplenishmentDate =
                const Value.absent(),
            Value<DateTime?> manualOverrideDate = const Value.absent(),
            Value<DateTime?> actualConfirmedDepletionDate =
                const Value.absent(),
            Value<String> confidenceLevel = const Value.absent(),
            Value<int> confidenceScore = const Value.absent(),
            Value<bool> isMonetaryEstimateOnly = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<String> trendDirection = const Value.absent(),
            Value<String> historicalIntervalsJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SupplyPredictionsCompanion(
            id: id,
            householdId: householdId,
            supplyId: supplyId,
            supplyName: supplyName,
            supplyType: supplyType,
            unit: unit,
            sampleCount: sampleCount,
            confirmedCycleCount: confirmedCycleCount,
            averageIntervalDays: averageIntervalDays,
            medianIntervalDays: medianIntervalDays,
            weightedIntervalDays: weightedIntervalDays,
            intervalStdDevDays: intervalStdDevDays,
            averagePurchaseAmountCents: averagePurchaseAmountCents,
            averageDailyConsumptionUnits: averageDailyConsumptionUnits,
            averageDailyCostCents: averageDailyCostCents,
            lastPurchaseDate: lastPurchaseDate,
            estimatedNextReplenishmentDate: estimatedNextReplenishmentDate,
            manualOverrideDate: manualOverrideDate,
            actualConfirmedDepletionDate: actualConfirmedDepletionDate,
            confidenceLevel: confidenceLevel,
            confidenceScore: confidenceScore,
            isMonetaryEstimateOnly: isMonetaryEstimateOnly,
            explanation: explanation,
            trendDirection: trendDirection,
            historicalIntervalsJson: historicalIntervalsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String supplyId,
            required String supplyName,
            required String supplyType,
            required String unit,
            Value<int> sampleCount = const Value.absent(),
            Value<int> confirmedCycleCount = const Value.absent(),
            Value<double?> averageIntervalDays = const Value.absent(),
            Value<double?> medianIntervalDays = const Value.absent(),
            Value<double?> weightedIntervalDays = const Value.absent(),
            Value<double?> intervalStdDevDays = const Value.absent(),
            Value<int?> averagePurchaseAmountCents = const Value.absent(),
            Value<double?> averageDailyConsumptionUnits = const Value.absent(),
            Value<int?> averageDailyCostCents = const Value.absent(),
            Value<DateTime?> lastPurchaseDate = const Value.absent(),
            Value<DateTime?> estimatedNextReplenishmentDate =
                const Value.absent(),
            Value<DateTime?> manualOverrideDate = const Value.absent(),
            Value<DateTime?> actualConfirmedDepletionDate =
                const Value.absent(),
            Value<String> confidenceLevel = const Value.absent(),
            Value<int> confidenceScore = const Value.absent(),
            Value<bool> isMonetaryEstimateOnly = const Value.absent(),
            required String explanation,
            Value<String> trendDirection = const Value.absent(),
            Value<String> historicalIntervalsJson = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SupplyPredictionsCompanion.insert(
            id: id,
            householdId: householdId,
            supplyId: supplyId,
            supplyName: supplyName,
            supplyType: supplyType,
            unit: unit,
            sampleCount: sampleCount,
            confirmedCycleCount: confirmedCycleCount,
            averageIntervalDays: averageIntervalDays,
            medianIntervalDays: medianIntervalDays,
            weightedIntervalDays: weightedIntervalDays,
            intervalStdDevDays: intervalStdDevDays,
            averagePurchaseAmountCents: averagePurchaseAmountCents,
            averageDailyConsumptionUnits: averageDailyConsumptionUnits,
            averageDailyCostCents: averageDailyCostCents,
            lastPurchaseDate: lastPurchaseDate,
            estimatedNextReplenishmentDate: estimatedNextReplenishmentDate,
            manualOverrideDate: manualOverrideDate,
            actualConfirmedDepletionDate: actualConfirmedDepletionDate,
            confidenceLevel: confidenceLevel,
            confidenceScore: confidenceScore,
            isMonetaryEstimateOnly: isMonetaryEstimateOnly,
            explanation: explanation,
            trendDirection: trendDirection,
            historicalIntervalsJson: historicalIntervalsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SupplyPredictionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SupplyPredictionsTable,
    SupplyPredictionRow,
    $$SupplyPredictionsTableFilterComposer,
    $$SupplyPredictionsTableOrderingComposer,
    $$SupplyPredictionsTableAnnotationComposer,
    $$SupplyPredictionsTableCreateCompanionBuilder,
    $$SupplyPredictionsTableUpdateCompanionBuilder,
    (
      SupplyPredictionRow,
      BaseReferences<_$AppDatabase, $SupplyPredictionsTable,
          SupplyPredictionRow>
    ),
    SupplyPredictionRow,
    PrefetchHooks Function()>;
typedef $$RecurringBillsTableCreateCompanionBuilder = RecurringBillsCompanion
    Function({
  required String id,
  required String householdId,
  required String categoryId,
  required String categoryName,
  required String title,
  Value<String?> providerName,
  required int expectedAmountCents,
  required String frequency,
  required DateTime nextDueDate,
  Value<int> remindDaysBefore,
  Value<bool> isActive,
  Value<int> version,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$RecurringBillsTableUpdateCompanionBuilder = RecurringBillsCompanion
    Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> categoryId,
  Value<String> categoryName,
  Value<String> title,
  Value<String?> providerName,
  Value<int> expectedAmountCents,
  Value<String> frequency,
  Value<DateTime> nextDueDate,
  Value<int> remindDaysBefore,
  Value<bool> isActive,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$RecurringBillsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringBillsTable> {
  $$RecurringBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get providerName => $composableBuilder(
      column: $table.providerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedAmountCents => $composableBuilder(
      column: $table.expectedAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RecurringBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringBillsTable> {
  $$RecurringBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get providerName => $composableBuilder(
      column: $table.providerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedAmountCents => $composableBuilder(
      column: $table.expectedAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecurringBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringBillsTable> {
  $$RecurringBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get providerName => $composableBuilder(
      column: $table.providerName, builder: (column) => column);

  GeneratedColumn<int> get expectedAmountCents => $composableBuilder(
      column: $table.expectedAmountCents, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringBillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringBillsTable,
    RecurringBillRow,
    $$RecurringBillsTableFilterComposer,
    $$RecurringBillsTableOrderingComposer,
    $$RecurringBillsTableAnnotationComposer,
    $$RecurringBillsTableCreateCompanionBuilder,
    $$RecurringBillsTableUpdateCompanionBuilder,
    (
      RecurringBillRow,
      BaseReferences<_$AppDatabase, $RecurringBillsTable, RecurringBillRow>
    ),
    RecurringBillRow,
    PrefetchHooks Function()> {
  $$RecurringBillsTableTableManager(
      _$AppDatabase db, $RecurringBillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringBillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringBillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> providerName = const Value.absent(),
            Value<int> expectedAmountCents = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<DateTime> nextDueDate = const Value.absent(),
            Value<int> remindDaysBefore = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringBillsCompanion(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            title: title,
            providerName: providerName,
            expectedAmountCents: expectedAmountCents,
            frequency: frequency,
            nextDueDate: nextDueDate,
            remindDaysBefore: remindDaysBefore,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String categoryId,
            required String categoryName,
            required String title,
            Value<String?> providerName = const Value.absent(),
            required int expectedAmountCents,
            required String frequency,
            required DateTime nextDueDate,
            Value<int> remindDaysBefore = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringBillsCompanion.insert(
            id: id,
            householdId: householdId,
            categoryId: categoryId,
            categoryName: categoryName,
            title: title,
            providerName: providerName,
            expectedAmountCents: expectedAmountCents,
            frequency: frequency,
            nextDueDate: nextDueDate,
            remindDaysBefore: remindDaysBefore,
            isActive: isActive,
            version: version,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringBillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringBillsTable,
    RecurringBillRow,
    $$RecurringBillsTableFilterComposer,
    $$RecurringBillsTableOrderingComposer,
    $$RecurringBillsTableAnnotationComposer,
    $$RecurringBillsTableCreateCompanionBuilder,
    $$RecurringBillsTableUpdateCompanionBuilder,
    (
      RecurringBillRow,
      BaseReferences<_$AppDatabase, $RecurringBillsTable, RecurringBillRow>
    ),
    RecurringBillRow,
    PrefetchHooks Function()>;
typedef $$HouseholdNotificationsTableCreateCompanionBuilder
    = HouseholdNotificationsCompanion Function({
  required String id,
  required String householdId,
  required String type,
  required String severity,
  required String title,
  required String body,
  Value<String?> relatedEntityType,
  Value<String?> relatedEntityId,
  required String dedupKey,
  Value<bool> isRead,
  Value<bool> isDismissed,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HouseholdNotificationsTableUpdateCompanionBuilder
    = HouseholdNotificationsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> type,
  Value<String> severity,
  Value<String> title,
  Value<String> body,
  Value<String?> relatedEntityType,
  Value<String?> relatedEntityId,
  Value<String> dedupKey,
  Value<bool> isRead,
  Value<bool> isDismissed,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$HouseholdNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdNotificationsTable> {
  $$HouseholdNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedEntityType => $composableBuilder(
      column: $table.relatedEntityType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedEntityId => $composableBuilder(
      column: $table.relatedEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dedupKey => $composableBuilder(
      column: $table.dedupKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$HouseholdNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdNotificationsTable> {
  $$HouseholdNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedEntityType => $composableBuilder(
      column: $table.relatedEntityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedEntityId => $composableBuilder(
      column: $table.relatedEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dedupKey => $composableBuilder(
      column: $table.dedupKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdNotificationsTable> {
  $$HouseholdNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get relatedEntityType => $composableBuilder(
      column: $table.relatedEntityType, builder: (column) => column);

  GeneratedColumn<String> get relatedEntityId => $composableBuilder(
      column: $table.relatedEntityId, builder: (column) => column);

  GeneratedColumn<String> get dedupKey =>
      $composableBuilder(column: $table.dedupKey, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HouseholdNotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdNotificationsTable,
    HouseholdNotificationRow,
    $$HouseholdNotificationsTableFilterComposer,
    $$HouseholdNotificationsTableOrderingComposer,
    $$HouseholdNotificationsTableAnnotationComposer,
    $$HouseholdNotificationsTableCreateCompanionBuilder,
    $$HouseholdNotificationsTableUpdateCompanionBuilder,
    (
      HouseholdNotificationRow,
      BaseReferences<_$AppDatabase, $HouseholdNotificationsTable,
          HouseholdNotificationRow>
    ),
    HouseholdNotificationRow,
    PrefetchHooks Function()> {
  $$HouseholdNotificationsTableTableManager(
      _$AppDatabase db, $HouseholdNotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdNotificationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdNotificationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdNotificationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String?> relatedEntityType = const Value.absent(),
            Value<String?> relatedEntityId = const Value.absent(),
            Value<String> dedupKey = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdNotificationsCompanion(
            id: id,
            householdId: householdId,
            type: type,
            severity: severity,
            title: title,
            body: body,
            relatedEntityType: relatedEntityType,
            relatedEntityId: relatedEntityId,
            dedupKey: dedupKey,
            isRead: isRead,
            isDismissed: isDismissed,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String type,
            required String severity,
            required String title,
            required String body,
            Value<String?> relatedEntityType = const Value.absent(),
            Value<String?> relatedEntityId = const Value.absent(),
            required String dedupKey,
            Value<bool> isRead = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdNotificationsCompanion.insert(
            id: id,
            householdId: householdId,
            type: type,
            severity: severity,
            title: title,
            body: body,
            relatedEntityType: relatedEntityType,
            relatedEntityId: relatedEntityId,
            dedupKey: dedupKey,
            isRead: isRead,
            isDismissed: isDismissed,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdNotificationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HouseholdNotificationsTable,
        HouseholdNotificationRow,
        $$HouseholdNotificationsTableFilterComposer,
        $$HouseholdNotificationsTableOrderingComposer,
        $$HouseholdNotificationsTableAnnotationComposer,
        $$HouseholdNotificationsTableCreateCompanionBuilder,
        $$HouseholdNotificationsTableUpdateCompanionBuilder,
        (
          HouseholdNotificationRow,
          BaseReferences<_$AppDatabase, $HouseholdNotificationsTable,
              HouseholdNotificationRow>
        ),
        HouseholdNotificationRow,
        PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  required String id,
  required String householdId,
  required String action,
  required String entityType,
  required String entityId,
  required String performedBy,
  required String performedByName,
  required String reason,
  Value<String?> beforeStateJson,
  Value<String?> afterStateJson,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> action,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> performedBy,
  Value<String> performedByName,
  Value<String> reason,
  Value<String?> beforeStateJson,
  Value<String?> afterStateJson,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedByName => $composableBuilder(
      column: $table.performedByName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get beforeStateJson => $composableBuilder(
      column: $table.beforeStateJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get afterStateJson => $composableBuilder(
      column: $table.afterStateJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedByName => $composableBuilder(
      column: $table.performedByName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get beforeStateJson => $composableBuilder(
      column: $table.beforeStateJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get afterStateJson => $composableBuilder(
      column: $table.afterStateJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => column);

  GeneratedColumn<String> get performedByName => $composableBuilder(
      column: $table.performedByName, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get beforeStateJson => $composableBuilder(
      column: $table.beforeStateJson, builder: (column) => column);

  GeneratedColumn<String> get afterStateJson => $composableBuilder(
      column: $table.afterStateJson, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLogRow,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLogRow, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLogRow>),
    AuditLogRow,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> performedBy = const Value.absent(),
            Value<String> performedByName = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> beforeStateJson = const Value.absent(),
            Value<String?> afterStateJson = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            householdId: householdId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            performedBy: performedBy,
            performedByName: performedByName,
            reason: reason,
            beforeStateJson: beforeStateJson,
            afterStateJson: afterStateJson,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String action,
            required String entityType,
            required String entityId,
            required String performedBy,
            required String performedByName,
            required String reason,
            Value<String?> beforeStateJson = const Value.absent(),
            Value<String?> afterStateJson = const Value.absent(),
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            householdId: householdId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            performedBy: performedBy,
            performedByName: performedByName,
            reason: reason,
            beforeStateJson: beforeStateJson,
            afterStateJson: afterStateJson,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLogRow,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLogRow, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLogRow>),
    AuditLogRow,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String userId,
  required String householdId,
  required String entityType,
  required String entityId,
  required String operation,
  required String payloadJson,
  Value<String?> idempotencyKey,
  Value<int> retryCount,
  Value<String> status,
  Value<String?> lastError,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String> householdId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payloadJson,
  Value<String?> idempotencyKey,
  Value<int> retryCount,
  Value<String> status,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueRow,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRow>
    ),
    SyncQueueRow,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String?> idempotencyKey = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            userId: userId,
            householdId: householdId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            retryCount: retryCount,
            status: status,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required String householdId,
            required String entityType,
            required String entityId,
            required String operation,
            required String payloadJson,
            Value<String?> idempotencyKey = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            userId: userId,
            householdId: householdId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            idempotencyKey: idempotencyKey,
            retryCount: retryCount,
            status: status,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueRow,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRow>
    ),
    SyncQueueRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$HouseholdMembersTableTableManager get householdMembers =>
      $$HouseholdMembersTableTableManager(_db, _db.householdMembers);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$HouseholdWalletsTableTableManager get householdWallets =>
      $$HouseholdWalletsTableTableManager(_db, _db.householdWallets);
  $$ContributionsTableTableManager get contributions =>
      $$ContributionsTableTableManager(_db, _db.contributions);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$WalletTransactionsTableTableManager get walletTransactions =>
      $$WalletTransactionsTableTableManager(_db, _db.walletTransactions);
  $$HouseholdBudgetsTableTableManager get householdBudgets =>
      $$HouseholdBudgetsTableTableManager(_db, _db.householdBudgets);
  $$TrackedSuppliesTableTableManager get trackedSupplies =>
      $$TrackedSuppliesTableTableManager(_db, _db.trackedSupplies);
  $$ConsumptionRecordsTableTableManager get consumptionRecords =>
      $$ConsumptionRecordsTableTableManager(_db, _db.consumptionRecords);
  $$SupplyPredictionsTableTableManager get supplyPredictions =>
      $$SupplyPredictionsTableTableManager(_db, _db.supplyPredictions);
  $$RecurringBillsTableTableManager get recurringBills =>
      $$RecurringBillsTableTableManager(_db, _db.recurringBills);
  $$HouseholdNotificationsTableTableManager get householdNotifications =>
      $$HouseholdNotificationsTableTableManager(
          _db, _db.householdNotifications);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
