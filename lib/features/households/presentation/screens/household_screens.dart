import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/household_member.dart';
import '../providers/household_providers.dart';

/// 1. HOUSEHOLD SELECTION & SWITCHER SCREEN
class HouseholdSelectionScreen extends ConsumerWidget {
  const HouseholdSelectionScreen({super.key});

  Future<void> _confirmDeleteHousehold({
    required BuildContext context,
    required WidgetRef ref,
    required String householdId,
    required String householdName,
  }) async {
    final confirmed = await showDestructiveConfirmationDialog(
      context: context,
      title: ref.tr(
        'Delete "$householdName"?',
        'Futa Nyumba "$householdName"?',
      ),
      message: ref.tr(
        'Are you sure you want to permanently delete "$householdName" and all of its wallet transactions, members, and supply records?',
        'Je, una uhakika unataka kufuta "$householdName" pamoja na miamala, wanafamilia na rekodi zake zote?',
      ),
      confirmLabel: ref.tr('Delete Household', 'Futa Nyumba'),
    );
    if (!confirmed) return;

    final repo = ref.read(householdLedgerRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);
    await repo.deleteHousehold(
      householdId: householdId,
      actorUserId: userId,
    );
    ref.read(ledgerRevisionProvider.notifier).state++;
    final remaining = repo.getHouseholdsForUser(userId);
    ref.read(selectedHouseholdIdProvider.notifier).state =
        remaining.isNotEmpty ? remaining.first.id : null;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreen,
          content: Text(
            ref.tr(
              '"$householdName" deleted.',
              '"$householdName" imefutwa.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final households = ref.watch(userHouseholdsProvider);
    final activeHousehold = ref.watch(activeHouseholdProvider);
    final repo = ref.watch(householdLedgerRepositoryProvider);
    final userId = ref.watch(currentUserIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('Manage Households', 'Simamia Nyumba')),
        actions: [
          IconButton(
            tooltip: ref.tr('Create Household', 'Unda Nyumba'),
            icon: const Icon(Icons.add_home_work_outlined),
            onPressed: () => context.push('/households/create'),
          ),
        ],
      ),
      body: households.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyStateCard(
                icon: Icons.home_work_outlined,
                title: ref.tr('No Households Yet', 'Hakuna Nyumba Bado'),
                subtitle: ref.tr(
                  'Create a household to start tracking shared contributions, expenses, and supplies.',
                  'Unda nyumba ili uanze kufuatilia michango na matumizi ya pamoja.',
                ),
                actionLabel: ref.tr('New Household', 'Nyumba Mpya'),
                onAction: () => context.push('/households/create'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: households.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final h = households[index];
                final isSelected = activeHousehold?.id == h.id;
                final wallet =
                    repo.getWallet(householdId: h.id, actorUserId: userId);
                final members =
                    repo.getMembers(householdId: h.id, actorUserId: userId);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : (isDark
                              ? AppColors.darkSoftGreenBorder
                              : AppColors.softGreenBorder),
                      width: isSelected ? 2 : 1.2,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ref.read(selectedHouseholdIdProvider.notifier).state =
                          h.id;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ref.tr(
                              'Switched active household to "${h.name}"',
                              'Umebadilisha kwenda nyumba ya "${h.name}"',
                            ),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : (isDark
                                          ? AppColors.darkSoftGreen
                                          : AppColors.primaryBlueLight),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.home_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            h.name,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: primaryText,
                                            ),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.successGreenLight,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'ACTIVE',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.successGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (h.description != null &&
                                        h.description!.isNotEmpty)
                                      Text(
                                        h.description!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                key: Key('delete_household_btn_${h.id}'),
                                tooltip: ref.tr(
                                  'Delete Household',
                                  'Futa Nyumba',
                                ),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                ),
                                onPressed: () => _confirmDeleteHousehold(
                                  context: context,
                                  ref: ref,
                                  householdId: h.id,
                                  householdName: h.name,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ref.tr(
                                      'Available Balance',
                                      'Salio Lililopo',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    AppFormatters.formatCurrency(
                                      wallet.availableBalance,
                                      symbol: h.currencySymbol,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: primaryText,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ref.tr('Members', 'Wanafamilia'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${members.length} ${ref.tr('members', 'wanafamilia')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 4,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(
                                        selectedHouseholdIdProvider.notifier,
                                      )
                                      .state = h.id;
                                  context.push('/households/details');
                                },
                                icon: const Icon(Icons.info_outline, size: 18),
                                label: Text(ref.tr('Details', 'Maelezo')),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(
                                        selectedHouseholdIdProvider.notifier,
                                      )
                                      .state = h.id;
                                  context.push('/households/members');
                                },
                                icon: const Icon(
                                  Icons.group_outlined,
                                  size: 18,
                                ),
                                label: Text(ref.tr('Members', 'Wanafamilia')),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(
                                        selectedHouseholdIdProvider.notifier,
                                      )
                                      .state = h.id;
                                  context.push('/households/edit');
                                },
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: Text(ref.tr('Edit', 'Hariri')),
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                onPressed: () => _confirmDeleteHousehold(
                                  context: context,
                                  ref: ref,
                                  householdId: h.id,
                                  householdName: h.name,
                                ),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                label: Text(ref.tr('Delete', 'Futa')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('fab_create_household'),
        onPressed: () => context.push('/households/create'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(ref.tr('New Household', 'Nyumba Mpya')),
      ),
    );
  }
}

/// 2. CREATE HOUSEHOLD SCREEN
class CreateHouseholdScreen extends ConsumerStatefulWidget {
  const CreateHouseholdScreen({super.key});

  @override
  ConsumerState<CreateHouseholdScreen> createState() =>
      _CreateHouseholdScreenState();
}

class _CreateHouseholdScreenState extends ConsumerState<CreateHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _thresholdCtrl = TextEditingController(text: '25000');
  SupportedCurrency _selectedCurrency = SupportedCurrency.all.first;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _thresholdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(householdLedgerRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);
      final userProfile = ref.read(authControllerProvider).valueOrNull;
      final threshold = double.tryParse(_thresholdCtrl.text.trim()) ?? 25000.0;

      final created = await repo.createHousehold(
        ownerId: userId,
        adminDisplayName: userProfile?.fullName.split(' ').first ?? 'Admin',
        name: _nameCtrl.text,
        description: _descCtrl.text,
        address: _addressCtrl.text,
        currencyCode: _selectedCurrency.code,
        currencySymbol: _selectedCurrency.symbol,
        lowBalanceThreshold: threshold,
      );

      ref.read(ledgerRevisionProvider.notifier).state++;
      ref.read(selectedHouseholdIdProvider.notifier).state = created.id;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Household "${created.name}" created!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Household')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Each household has its own independent wallet, members, categories, consumption records, and predictions.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('create_household_name_field'),
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Household Name (e.g. My Family, My Apartment)',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (val) => val == null || val.trim().length < 2
                    ? 'Enter a valid household name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Location / Address (e.g. Mikocheni, Dar es Salaam)',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SupportedCurrency>(
                value: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Primary Household Currency',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                items: SupportedCurrency.all
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.name} (${c.symbol} - ${c.code})'),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCurrency = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thresholdCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'Low Balance Alert Threshold (${_selectedCurrency.symbol})',
                  prefixIcon: const Icon(Icons.warning_amber_outlined),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('create_household_submit_btn'),
                onPressed: _isSaving ? null : _submit,
                child: const Text('Create Household'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3. EDIT HOUSEHOLD SCREEN
class EditHouseholdScreen extends ConsumerStatefulWidget {
  const EditHouseholdScreen({super.key});

  @override
  ConsumerState<EditHouseholdScreen> createState() =>
      _EditHouseholdScreenState();
}

class _EditHouseholdScreenState extends ConsumerState<EditHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _thresholdCtrl;

  @override
  void initState() {
    super.initState();
    final h = ref.read(activeHouseholdProvider);
    _nameCtrl = TextEditingController(text: h?.name ?? '');
    _descCtrl = TextEditingController(text: h?.description ?? '');
    _addressCtrl = TextEditingController(text: h?.address ?? '');
    _thresholdCtrl = TextEditingController(
      text: h?.lowBalanceThreshold.toStringAsFixed(0) ?? '25000',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _thresholdCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final h = ref.read(activeHouseholdProvider);
    if (h == null) return;
    final repo = ref.read(householdLedgerRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    await repo.updateHousehold(
      householdId: h.id,
      actorUserId: userId,
      name: _nameCtrl.text,
      description: _descCtrl.text,
      address: _addressCtrl.text,
      lowBalanceThreshold:
          double.tryParse(_thresholdCtrl.text) ?? h.lowBalanceThreshold,
    );
    ref.read(ledgerRevisionProvider.notifier).state++;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Household settings updated.')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Household')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Household Name'),
                validator: (v) =>
                    v == null || v.trim().length < 2 ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thresholdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Low Wallet Balance Alert Threshold',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. HOUSEHOLD DETAILS SCREEN
class HouseholdDetailsScreen extends ConsumerWidget {
  const HouseholdDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(activeHouseholdProvider);
    final wallet = ref.watch(activeHouseholdWalletProvider);
    final members = ref.watch(activeHouseholdMembersProvider);
    final categories = ref.watch(activeHouseholdCategoriesProvider);

    if (household == null || wallet == null) {
      return const Scaffold(body: Center(child: Text('No active household')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(household.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/households/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    household.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (household.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      household.description!,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  if (household.address != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          household.address!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Currency:'),
                      Text(
                        '${household.currencyCode} (${household.currencySymbol})',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Timezone:'),
                      Text(
                        household.timezone,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Available Wallet Balance:'),
                      Text(
                        AppFormatters.formatCurrency(
                          wallet.availableBalance,
                          symbol: household.currencySymbol,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurface
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSoftGreenBorder
                    : AppColors.softGreenBorder,
                width: 1.2,
              ),
            ),
            leading: const Icon(Icons.group_outlined, color: AppColors.primaryBlue),
            title: Text('Household Members (${members.length})'),
            subtitle: const Text('Add or view members who share household expenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/households/members'),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurface
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSoftGreenBorder
                    : AppColors.softGreenBorder,
                width: 1.2,
              ),
            ),
            leading: const Icon(Icons.category_outlined, color: AppColors.secondaryOrange),
            title: Text('Expense Categories (${categories.length})'),
            subtitle: const Text('Manage default and custom household categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/households/categories'),
          ),
        ],
      ),
    );
  }
}

/// 5. MANAGE HOUSEHOLD MEMBERS & MEMBER DETAILS SCREEN
class ManageHouseholdMembersScreen extends ConsumerStatefulWidget {
  final bool embeddedInTab;
  final VoidCallback? onBack;

  const ManageHouseholdMembersScreen({
    super.key,
    this.embeddedInTab = false,
    this.onBack,
  });

  @override
  ConsumerState<ManageHouseholdMembersScreen> createState() =>
      _ManageHouseholdMembersScreenState();
}

class _ManageHouseholdMembersScreenState
    extends ConsumerState<ManageHouseholdMembersScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _addMemberInline() async {
    final h = ref.read(activeHouseholdProvider);
    if (h == null) return;
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write the member name.')),
      );
      return;
    }
    try {
      final added =
          await ref.read(householdLedgerRepositoryProvider).addMember(
                householdId: h.id,
                actorUserId: ref.read(currentUserIdProvider),
                displayName: _nameCtrl.text,
                phoneNumber: _phoneCtrl.text,
              );
      _nameCtrl.clear();
      _phoneCtrl.clear();
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGreen,
            content: Text('Member "${added.displayName}" added to ${h.name}!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _confirmDeleteMember(HouseholdMember member) async {
    final h = ref.read(activeHouseholdProvider);
    if (h == null) return;
    final confirmed = await showDestructiveConfirmationDialog(
      context: context,
      title: ref.tr(
        'Remove Contributor "${member.displayName}"?',
        'Ondoa Mshiriki "${member.displayName}"?',
      ),
      message: ref.tr(
        'Are you sure you want to remove ${member.displayName} from ${h.name}? Their past recorded transactions in the ledger will be preserved.',
        'Je, una uhakika unataka kumwondoa ${member.displayName} kwenye ${h.name}? Miamala yake ya nyuma itabaki kwenye kumbukumbu.',
      ),
      confirmLabel: ref.tr('Remove', 'Ondoa'),
    );
    if (!confirmed) return;

    try {
      await ref.read(householdLedgerRepositoryProvider).removeMember(
            householdId: h.id,
            actorUserId: ref.read(currentUserIdProvider),
            memberId: member.id,
          );
      ref.read(ledgerRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGreen,
            content: Text(
              ref.tr(
                'Removed "${member.displayName}" from ${h.name}.',
                '"${member.displayName}" ameondolewa kwenye ${h.name}.',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showMemberDetailsSheet({
    required HouseholdMember member,
    required String currencySymbol,
    required double totalContributed,
    required double totalPurchasesMade,
    required int contributionCount,
    required int expenseCount,
  }) {
    final transactions = ref
        .read(activeHouseholdTransactionsProvider)
        .where((tx) => tx.memberId == member.id)
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.softGreen,
                  child: Text(
                    member.displayName.characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.phoneNumber?.isNotEmpty == true
                            ? member.phoneNumber!
                            : ref.tr(
                                'Household Member • Shared Wallet Participant',
                                'Mwanafamilia • Mshiriki wa Mkoba wa Pamoja',
                              ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(
                  label: member.isAdmin
                      ? ref.tr('Admin', 'Msimamizi')
                      : ref.tr('Member', 'Mshiriki'),
                ),
                if (!member.isAdmin) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    tooltip: ref.tr('Remove Contributor', 'Ondoa Mshiriki'),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _confirmDeleteMember(member);
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppSurfaceCard(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: AppColors.softGreen,
                    borderColor: AppColors.softGreenBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.tr(
                            'Contributed ($contributionCount)',
                            'Michango ($contributionCount)',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.formatCurrency(
                            totalContributed,
                            symbol: currencySymbol,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppSurfaceCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.tr(
                            'Purchases Made ($expenseCount)',
                            'Manunuzi Aliyofanya ($expenseCount)',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.formatCurrency(
                            totalPurchasesMade,
                            symbol: currencySymbol,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SectionHeader(
              title: ref.tr(
                'Activity by ${member.displayName}',
                'Miamala ya ${member.displayName}',
              ),
            ),
            if (transactions.isEmpty)
              EmptyStateCard(
                icon: Icons.history_rounded,
                title: ref.tr('No Activity Yet', 'Hakuna Miamala Bado'),
                subtitle: ref.tr(
                  'Contributions and purchases recorded for this member will appear here.',
                  'Michango na manunuzi ya mwanafamilia huyu yataonekana hapa.',
                ),
              )
            else
              ...transactions.map(
                (tx) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TransactionRowCard(
                    title: tx.description,
                    memberName: tx.memberName,
                    categoryName: tx.categoryName,
                    date: tx.transactionDate,
                    signedAmount: tx.signedAmount,
                    currencySymbol: currencySymbol,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    final members = ref.watch(activeHouseholdMembersProvider);
    final contributions = ref.watch(activeHouseholdContributionsProvider);
    final expenses = ref.watch(activeHouseholdExpensesProvider);
    final symbol = household?.currencySymbol ?? 'TSh';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: widget.onBack,
              )
            : null,
        title: Text(
          '${ref.tr('Household Members', 'Wanafamilia')} • ${household?.name ?? ''}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          AppSurfaceCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSoftGreen
                            : AppColors.softGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: isDark
                            ? const Color(0xFF34C486)
                            : AppColors.primaryGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.tr(
                              'Write & Add Household Member',
                              'Andika na Ongeza Mwanafamilia',
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ref.tr(
                              'Write each member\'s name manually to track their contributions and purchases.',
                              'Andika jina la mshiriki kufuatilia michango na manunuzi yake.',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('add_member_name_field'),
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: ref.tr(
                      'Write Member Name (e.g. Dida, Asha, Juma)',
                      'Andika Jina la Mwanafamilia (mf. Dida, Asha, Juma)',
                    ),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: ref.tr(
                      'Phone Number (Optional)',
                      'Namba ya Simu (Hiari)',
                    ),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  key: const Key('add_member_save_btn'),
                  onPressed: _addMemberInline,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(ref.tr('Add Member', 'Ongeza Mwanafamilia')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title:
                '${ref.tr('Household Members', 'Wanafamilia')} (${members.length})',
          ),
          ...members.map((m) {
            final memberContribs =
                contributions.where((c) => c.memberId == m.id).toList();
            final memberExpenses =
                expenses.where((e) => e.paidByMemberId == m.id).toList();
            final memberTotalContributed = memberContribs.fold<double>(
              0.0,
              (sum, c) => sum + c.amount,
            );
            final memberTotalPurchases = memberExpenses.fold<double>(
              0.0,
              (sum, e) => sum + e.amount,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AppSurfaceCard(
                padding: const EdgeInsets.all(16),
                onTap: () => _showMemberDetailsSheet(
                  member: m,
                  currencySymbol: symbol,
                  totalContributed: memberTotalContributed,
                  totalPurchasesMade: memberTotalPurchases,
                  contributionCount: memberContribs.length,
                  expenseCount: memberExpenses.length,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: isDark
                          ? AppColors.darkSoftGreen
                          : AppColors.softGreen,
                      child: Text(
                        m.displayName.characters.first.toUpperCase(),
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF34C486)
                              : AppColors.primaryGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  m.displayName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: primaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusPill(
                                label: m.isAdmin
                                    ? ref.tr('Admin', 'Msimamizi')
                                    : ref.tr('Member', 'Mshiriki'),
                                foregroundColor: m.isAdmin
                                    ? (isDark
                                        ? const Color(0xFF34C486)
                                        : AppColors.primaryGreen)
                                    : secondaryText,
                                backgroundColor: m.isAdmin
                                    ? (isDark
                                        ? AppColors.darkSoftGreen
                                        : AppColors.softGreen)
                                    : (isDark
                                        ? AppColors.darkSurfaceMuted
                                        : AppColors.surfaceMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${ref.tr('Contributed', 'Amechangia')}: ${AppFormatters.formatCurrency(memberTotalContributed, symbol: symbol)} • ${ref.tr('Purchases', 'Manunuzi')}: ${memberExpenses.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!m.isAdmin)
                      IconButton(
                        key: Key('delete_member_btn_${m.id}'),
                        tooltip: ref.tr(
                          'Remove Contributor',
                          'Ondoa Mshiriki',
                        ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 21,
                        ),
                        onPressed: () => _confirmDeleteMember(m),
                      )
                    else
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 6. MANAGE EXPENSE CATEGORIES SCREEN (DEFAULT + CUSTOM PER HOUSEHOLD)
class ManageCategoriesScreen extends ConsumerStatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  ConsumerState<ManageCategoriesScreen> createState() =>
      _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends ConsumerState<ManageCategoriesScreen> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _showCreateCategoryDialog() async {
    _nameCtrl.clear();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Custom Category'),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Category Name (e.g. Security Guard, Waste Collection)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final h = ref.read(activeHouseholdProvider);
              if (h == null) return;
              await ref
                  .read(householdLedgerRepositoryProvider)
                  .createCustomCategory(
                    householdId: h.id,
                    actorUserId: ref.read(currentUserIdProvider),
                    name: _nameCtrl.text,
                  );
              ref.read(ledgerRevisionProvider.notifier).state++;
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save Category'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    final categories = ref.watch(activeHouseholdCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(ref.tr('Expense Categories', 'Makundi ya Matumizi')),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return AppSurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SwitchListTile(
              activeColor: AppColors.primaryGreen,
              value: cat.isActive,
              title: Text(
                cat.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                cat.isDefault
                    ? ref.tr(
                        'Default Household Category',
                        'Kundi la Msingi la Nyumbani',
                      )
                    : ref.tr('Custom Category', 'Kundi Maalum'),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              onChanged: (val) async {
                if (household == null) return;
                await ref
                    .read(householdLedgerRepositoryProvider)
                    .updateCategory(
                      householdId: household.id,
                      actorUserId: ref.read(currentUserIdProvider),
                      categoryId: cat.id,
                      isActive: val,
                    );
                ref.read(ledgerRevisionProvider.notifier).state++;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCategoryDialog,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(ref.tr('Custom Category', 'Ongeza Kundi')),
      ),
    );
  }
}

