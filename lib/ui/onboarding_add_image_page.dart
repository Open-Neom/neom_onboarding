import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/custom_image.dart';
import 'package:neom_commons/ui/widgets/images/media_preview_image.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_commons/utils/external_utilities.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_widgets.dart';


class OnBoardingAddImagePage extends StatelessWidget {
  const OnBoardingAddImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = kIsWeb && MediaQuery.of(context).size.width > 800;

    return SintBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      builder: (controller) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: SintAppBar(backgroundColor: Colors.transparent),
        backgroundColor: AppColor.scaffold,
        body: Container(
          width: AppTheme.fullWidth(context),
          height: AppTheme.fullHeight(context),
          decoration: AppTheme.appBoxDecoration,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 40 : AppTheme.padding20,
                  vertical: isWide ? 24 : 0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 900 : double.infinity),
                    child: isWide
                        ? _buildWebLayout(context, controller)
                        : _buildMobileLayout(context, controller),
                  ),
                ),
              ),
              if(controller.isLoading.value) Container(
                color: Colors.black87,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.dodgetBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Web: 2-column glassmorphism layout ───
  Widget _buildWebLayout(BuildContext context, OnBoardingController controller) {
    return Column(
      children: [
        const SizedBox(height: 48),
        // Welcome header
        Text(
          "${AppTranslationConstants.welcome.tr}, ${AppProperties.getAppName()}!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.userServiceImpl.user.photoUrl.isEmpty
              ? OnBoardingTranslationConstants.addProfileImgMsg.tr
              : controller.userServiceImpl.profile.id.isEmpty
                  ? OnBoardingTranslationConstants.addLastProfileInfoMsg.tr
                  : OnBoardingTranslationConstants.addNewProfileInfoMsg.tr,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const SizedBox(height: 36),
        // Main card
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.bondiBlue.withValues(alpha: 0.15)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.bondiBlue.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left column: Avatar + basic info (flex: 2)
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Center(child: _buildCircularAvatar(controller)),
                          const SizedBox(height: 28),
                          _buildTextField(
                            AppTranslationConstants.username.tr,
                            controller.controllerUsername,
                            TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _buildTextField(
                              "${OnBoardingTranslationConstants.tellAboutYou.tr}...",
                              controller.controllerAboutMe,
                              TextInputType.multiline,
                              maxLines: 4,
                              optional: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right column: Details + actions (flex: 3)
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildEntryDateField(controller.dateOfBirth.value,
                              context: context, dateFunction: controller.setDateOfBirth),
                          const SizedBox(height: 16),
                          if(controller.userServiceImpl.user.phoneNumber.isEmpty)
                            buildPhoneField(onBoardingController: controller),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "${AppTranslationConstants.couponCode.tr} (${AppTranslationConstants.optional.tr})",
                            controller.controllerCouponCode,
                            TextInputType.text,
                            maxLength: 10,
                            capitalize: true,
                          ),
                          const SizedBox(height: 24),
                          _buildTermsAndButton(context, controller),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  // ─── Mobile: single-column layout ───
  Widget _buildMobileLayout(BuildContext context, OnBoardingController controller) {
    return Column(
      children: <Widget>[
        AppTheme.heightSpace50,
        AppTheme.heightSpace20,
        _buildCircularAvatar(controller),
        const SizedBox(height: 20),
        buildLabel(context, "${AppTranslationConstants.welcome.tr}, ${AppProperties.getAppName()}!",
            controller.userServiceImpl.user.photoUrl.isEmpty
              ? OnBoardingTranslationConstants.addProfileImgMsg.tr
              : controller.userServiceImpl.profile.id.isEmpty
                ? OnBoardingTranslationConstants.addLastProfileInfoMsg.tr
                : OnBoardingTranslationConstants.addNewProfileInfoMsg.tr
        ),
        buildContainerTextField(AppTranslationConstants.username.tr,
            controller: controller.controllerUsername, textInputType: TextInputType.text),
        buildContainerTextField("${OnBoardingTranslationConstants.tellAboutYou.tr} (${AppTranslationConstants.optional.tr})",
            controller: controller.controllerAboutMe, maxLines: 20),
        AppTheme.heightSpace20,
        Column(
          children: [
            buildEntryDateField(controller.dateOfBirth.value,
                context: context, dateFunction: controller.setDateOfBirth),
            AppTheme.heightSpace10,
            if(controller.userServiceImpl.user.phoneNumber.isEmpty) buildPhoneField(onBoardingController: controller),
            Padding(
                padding: const EdgeInsets.only(
                    left: AppTheme.padding20,
                    right: AppTheme.padding20
                ),
                child: TextFormField(
                  controller: controller.controllerCouponCode,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: "${AppTranslationConstants.couponCode.tr} (${AppTranslationConstants.optional.tr})"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                )
            )
          ],
        ),
        AppTheme.heightSpace5,
        _buildTermsAndButton(context, controller),
      ],
    );
  }

  // ─── Circular Avatar with drag & drop (web) or tap (mobile) ───
  Widget _buildCircularAvatar(OnBoardingController controller) {
    final hasFile = _hasMediaFile(controller);
    final hasPhotoUrl = controller.userServiceImpl.user.photoUrl.isNotEmpty;
    final size = kIsWeb ? 160.0 : 140.0;

    Widget avatarContent;
    if (hasFile) {
      final imageProvider = buildMediaImageProvider(controller.mediaUploadServiceImpl);
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: imageProvider != null
              ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
              : null,
          border: Border.all(color: AppColor.bondiBlue.withValues(alpha: 0.5), width: 3),
        ),
      );
    } else if (hasPhotoUrl) {
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: platformImageProvider(controller.userServiceImpl.user.photoUrl)!,
            fit: BoxFit.cover,
          ),
          border: Border.all(color: AppColor.bondiBlue.withValues(alpha: 0.5), width: 3),
        ),
      );
    } else {
      // Empty state: dashed circle with icon
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: size * 0.4, color: Colors.white38),
            if (kIsWeb) ...[
              const SizedBox(height: 4),
              Icon(Icons.cloud_upload_outlined, size: 16, color: Colors.white30),
            ],
          ],
        ),
      );
    }

    final hasImage = hasFile || hasPhotoUrl;

    // Wrap with action button
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => controller.handleImage(),
        child: Stack(
          children: [
            avatarContent,
            // Action button (bottom-right)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasImage ? Colors.red.shade700 : AppColor.bondiBlue,
                  border: Border.all(color: AppColor.scaffold, width: 3),
                ),
                child: IconButton(
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    hasImage ? Icons.close : (kIsWeb ? Icons.cloud_upload_outlined : Icons.camera_alt),
                    color: Colors.white,
                  ),
                  onPressed: hasImage
                      ? () {
                          controller.mediaUploadServiceImpl?.clearMedia();
                          controller.userServiceImpl.user.photoUrl = '';
                          controller.update([AppPageIdConstants.onBoarding]);
                        }
                      : () => controller.handleImage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Styled text field for web ───
  Widget _buildTextField(
    String label,
    TextEditingController? controller,
    TextInputType keyboardType, {
    int maxLines = 1,
    int? maxLength,
    bool optional = false,
    bool capitalize = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        color: Colors.white.withValues(alpha: 0.04),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: capitalize ? TextCapitalization.characters : TextCapitalization.none,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          if (capitalize) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
      ),
    );
  }

  // ─── Shared: terms checkbox + finish button ───
  Widget _buildTermsAndButton(BuildContext context, OnBoardingController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: controller.agreeTerms.value,
              onChanged: (value) {
                if (value == true && !controller.agreeTerms.value) {
                  // Show terms modal first
                  _showTermsModal(context, controller);
                } else {
                  controller.setTermsAgreement(value ?? false);
                }
              },
            ),
            Flexible(
              child: Text('${CommonTranslationConstants.iHaveReadAndAccept.tr} ',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(CommonTranslationConstants.termsAndConditions.tr,
                style: const TextStyle(fontSize: 14, color: AppColor.bondiBlue),
              ),
              onPressed: () => _showTermsModal(context, controller),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: controller.agreeTerms.value ? BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [AppColor.getMain(), AppColor.bondiBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.bondiBlue.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ) : null,
          child: ElevatedButton(
            onPressed: controller.agreeTerms.value ? () async => {
              if(controller.userServiceImpl.user.currentProfileId.isEmpty) {
                await controller.finishAccount()
              } else {
                await controller.createAdditionalProfile()
              }
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.agreeTerms.value
                  ? Colors.transparent : Colors.white.withValues(alpha: 0.08),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white38,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 0,
            ),
            child: Text(
              (controller.userServiceImpl.user.currentProfileId.isEmpty)
                  ? OnBoardingTranslationConstants.finishAccount.tr
                  : OnBoardingTranslationConstants.finishProfile.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasMediaFile(OnBoardingController controller) {
    if (controller.mediaUploadServiceImpl == null) return false;
    return controller.mediaUploadServiceImpl!.mediaFileExists();
  }

  void _showTermsModal(BuildContext context, OnBoardingController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TermsModal(
        onAccept: () {
          Navigator.of(ctx).pop();
          controller.setTermsAgreement(true);
        },
        onDecline: () {
          Navigator.of(ctx).pop();
          controller.setTermsAgreement(false);
        },
      ),
    );
  }
}

/// Apple-style Terms modal: full content with scroll, accept at bottom.
class _TermsModal extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _TermsModal({required this.onAccept, required this.onDecline});

  @override
  State<_TermsModal> createState() => _TermsModalState();
}

class _TermsModalState extends State<_TermsModal> {
  String _content = '';
  bool _loading = true;
  bool _scrolledToEnd = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTerms();
    _scrollController.addListener(_checkScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_scrolledToEnd) setState(() => _scrolledToEnd = true);
    }
  }

  Future<void> _loadTerms() async {
    try {
      final assetPath = _getAssetPath();
      final raw = await rootBundle.loadString(assetPath);
      final appName = AppProperties.getAppName();
      final email = _getContactEmail();

      setState(() {
        _content = raw
            .replaceAll('{{APP_NAME}}', appName.isNotEmpty ? appName : 'App')
            .replaceAll('{{CONTACT_EMAIL}}', email);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _content = 'No se pudieron cargar los terminos de servicio.';
        _loading = false;
      });
    }
  }

  String _getAssetPath() {
    final app = AppConfig.instance.appInUse;
    switch (app) {
      case AppInUse.e:
        return 'packages/neom_commons/assets/legal/terms_emxi.md';
      case AppInUse.g:
        return 'packages/neom_commons/assets/legal/terms_gigmeout.md';
      case AppInUse.c:
        return 'packages/neom_commons/assets/legal/terms_cyberneom.md';
      case AppInUse.i:
        return 'packages/neom_commons/assets/legal/terms_itzli.md';
      default:
        return 'packages/neom_commons/assets/legal/terms_emxi.md';
    }
  }

  String _getContactEmail() {
    switch (AppConfig.instance.appInUse) {
      case AppInUse.e: return 'contacto@emxi.org';
      case AppInUse.g: return 'contacto@gigmeout.com';
      case AppInUse.c: return 'contacto@cyberneom.xyz';
      case AppInUse.i: return 'contacto@itzli.mx';
      default: return AppProperties.getEmail().isNotEmpty
          ? AppProperties.getEmail() : 'contacto@neom.app';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final maxW = isWide ? 680.0 : MediaQuery.of(context).size.width * 0.92;
    final maxH = MediaQuery.of(context).size.height * 0.85;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: maxW,
          constraints: BoxConstraints(maxHeight: maxH),
          decoration: BoxDecoration(
            color: Color.lerp(AppColor.darkBackground, AppColor.getMain(), 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColor.getAccentColor().withAlpha(40),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppColor.bondiBlue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        CommonTranslationConstants.termsAndConditions.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: widget.onDecline,
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(60),
                        child: CircularProgressIndicator(),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(24),
                          child: _buildContent(),
                        ),
                      ),
              ),
              // Footer with buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    if (!_scrolledToEnd)
                      Expanded(
                        child: Text(
                          'Desplaza para leer todo el documento',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ),
                    if (_scrolledToEnd) const Spacer(),
                    TextButton(
                      onPressed: widget.onDecline,
                      child: Text(
                        AppTranslationConstants.cancel.tr,
                        style: const TextStyle(color: Colors.white54, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _scrolledToEnd ? widget.onAccept : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _scrolledToEnd
                            ? AppColor.bondiBlue
                            : Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppTranslationConstants.accept.tr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final lines = _content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 6));
      } else if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(line.substring(2),
            style: TextStyle(color: AppColor.bondiBlue, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 6),
          child: Text(line.substring(3),
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(' •  ', style: TextStyle(color: Colors.white54, fontSize: 13)),
              Expanded(child: _buildRichLine(line.substring(2))),
            ],
          ),
        ));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: _buildRichLine(line),
        ));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  Widget _buildRichLine(String text) {
    final spans = <InlineSpan>[];
    final bold = RegExp(r'\*\*(.*?)\*\*');
    int last = 0;
    for (final m in bold.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start),
          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)));
      }
      spans.add(TextSpan(text: m.group(1),
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, height: 1.5)));
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last),
        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)));
    }
    if (spans.isEmpty) {
      return Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5));
    }
    return RichText(text: TextSpan(children: spans));
  }
}
