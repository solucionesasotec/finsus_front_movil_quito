// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/type_credit.dart';
import 'package:bancamovil/features/account_details/providers/movements_provider.dart';
import 'package:bancamovil/features/account_details/screens/account_details_screen.dart';
import 'package:bancamovil/features/credit_details/screens/credit_details_screen.dart';
import 'package:bancamovil/features/deposite_data/providers/bank_account_provider.dart';
import 'package:bancamovil/features/deposite_data/screens/deposite_date_screen.dart';
import 'package:bancamovil/features/extras/providers/clasif_credit_provider.dart';
import 'package:bancamovil/features/extras/providers/ifi_provider.dart';
import 'package:bancamovil/features/extras/providers/type_credit_provider.dart';
import 'package:bancamovil/features/extras/screens/maintenance_screen.dart';
import 'package:bancamovil/features/garantias/providers/garantia_provider.dart';
import 'package:bancamovil/features/garantias/screens/garantia_screen.dart';
import 'package:bancamovil/features/home/screens/home_screen.dart';
import 'package:bancamovil/features/login_change_password/providers/web_login_provider.dart';
import 'package:bancamovil/features/login_change_password/screens/change_password_screen.dart';
import 'package:bancamovil/features/login_recover_password/providers/recover_password_provider.dart';
import 'package:bancamovil/features/login_recover_password/screens/recover_password_screen.dart';
import 'package:bancamovil/features/products/providers/accounts_provider.dart';
import 'package:bancamovil/features/products/providers/partner_accounts_provider.dart';
import 'package:bancamovil/features/products/providers/credit_table_provider.dart';
import 'package:bancamovil/features/products/providers/credits_provider.dart';
import 'package:bancamovil/features/products/providers/investments_provider.dart';
import 'package:bancamovil/features/products/providers/products_provider.dart';
import 'package:bancamovil/features/simulators/screens/simulator_tab_screen.dart';
import 'package:bancamovil/features/solicitudes/providers/sgf_sol_credit_provider.dart';
import 'package:bancamovil/features/solicitudes/screens/credit_sol_screen.dart';
import 'package:bancamovil/features/test/test_screen.dart';
import 'package:bancamovil/features/transactions/provider/transaction_provider.dart';
import 'package:bancamovil/features/transactions/screens/transaction_receipt.dart';
import 'package:bancamovil/features/transactions/screens/transactions_screen.dart';
import 'package:bancamovil/features/transactions/screens/verification_interbank_screen.dart';
import 'package:bancamovil/features/transactions/screens/verification_internal_screen.dart';
import 'package:bancamovil/features/transfer_receipt/providers/comprobante_dep_provider.dart';
import 'package:bancamovil/features/transfer_receipt/providers/int_spi_opi_pend_provider.dart';
import 'package:bancamovil/features/transfer_receipt/screens/transfer_receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/login/providers/auth_provider.dart';
import 'features/login/screens/login_screen.dart';
import 'features/profile/screens/profile_screen.dart';

// void main() {
//   runApp(MyApp());
// }
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(const Duration(seconds: 3), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WebLoginProvider()),
        ChangeNotifierProvider(create: (_) => RecoverPasswordProvider()),
        ChangeNotifierProvider(create: (_) => PartnerAccountsProvider()),
        ChangeNotifierProvider(create: (_) => AccountsProvider()),
        ChangeNotifierProvider(create: (_) => CreditsProvider()),
        ChangeNotifierProvider(create: (_) => CreditTableProvider()),
        ChangeNotifierProvider(create: (_) => InvestmentsProvider()),
        ChangeNotifierProvider(create: (_) => MovementsProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => TypeCreditProvider()),
        ChangeNotifierProvider(create: (_) => ClasifCreditProvider()),
        ChangeNotifierProvider(create: (_) => IfiProvider()),
        ChangeNotifierProvider(create: (_) => IntSpiOpiPendProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SgfSolCreditoProvider()),
        ChangeNotifierProvider(create: (_) => GarantiaProvider()),
        ChangeNotifierProvider(create: (_) => ComprobanteDepProvider()),
        ChangeNotifierProvider(create: (_) => BankAccountProvider()),
        // create: (context) => TypeCreditProvider()..getTypeCredits(), //LLama el metodo
      ],
      child: MaterialApp(
        title: 'Banca Móvil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false, // Desactiva Material 3
          primarySwatch: Colors.pink,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/updatepassword': (context) => ChangePasswordScreen(),
          '/recoverpassword': (context) => RecoverPasswordScreen(),
          '/home': (context) => HomeScreen(),
          '/saving/details': (context) => AccountDetailsScreen(),
          '/credit/details': (context) => CreditDetailsScreen(),
          '/transactions': (context) => TransactionsScreen(),
          '/simulators': (context) => SimulatorTabScreen(),
          '/savereceipt': (context) => TransferReceiptScreen(),
          '/solicitudcredito': (context) => CreditSolScreen(),
          '/validator/internal': (context) => VerificationInternalScreen(),
          '/validator/interbank': (context) => VerificationInterbankScreen(),
          '/receipt': (context) => TransactionReceipt(
                fecha: "",
                monto: "",
                cuentaOrigen: "",
                cuentaDestino: "",
                referencia: "",
                nombreSocioOrdenante: "",
                nombreSocio: "",
                nombreBanco: "",
              ),
          '/profile': (context) => ProfileScreen(),
          '/maintenance': (context) => MaintenanceScreen(),
          '/depositedata': (context) => DepositeDataScreen(),
          '/garantias': (context) => GarantiaScreen(),
          '/test': (context) => TestScreen(),
        },
      ),
    );
  }
}
