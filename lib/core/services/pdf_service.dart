import 'dart:io';
import 'dart:typed_data';
import 'package:bancamovil/core/models/company.dart';
import 'package:bancamovil/core/models/user.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfService {
  Future<void> generateCreditRequestForm({
    required User socio,
    required Company empresa,
    required double montoCredito,
    required int plazoMeses,
  }) async {
    final pdf = pw.Document();

    final Uint8List logoData = await rootBundle
        .load('lib/images/logo_finsus.png')
        .then((data) => data.buffer.asUint8List());
    final logoEmpresa = pw.MemoryImage(logoData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          var strCivil;
          switch (socio.stsCivil) {
            case 'C':
              strCivil = 'Casado/a';
              break;
            case 'S':
              strCivil = 'Soleto/a';
              break;
            case 'D':
              strCivil = 'Divorciado/a';
              break;
            case 'U':
              strCivil = 'Union libre';
              break;
            case 'V':
              strCivil = 'Viudo/a';
              break;
            default:
              strCivil = '${socio.stsCivil}-ND';
          }
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo y nombre de la empresa
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoEmpresa, height: 100),
                  pw.Text(
                    empresa.nomEmpresa,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              // Título centrado
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Solicitud de Crédito",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "DATOS DEL SOLICITANTE",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text("Nombre completo: ${socio.apeSocio} ${socio.nomSocio}"),
              pw.Text("Cédula/Pasaporte: ${socio.numId}"),
              pw.Text("Estado Civil: $strCivil"),
              pw.Text("Teléfono: ${socio.telCelular}"),
              pw.Text("Correo electrónico: ${socio.dirCorreo}"),
              pw.Text("Dirección de domicilio: ${socio.dirDom}"),
              pw.SizedBox(height: 20),
              pw.Text(
                "DATOS DE CRÉDITO",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                  "Monto a solicitar: \$${montoCredito.toStringAsFixed(2)}"),
              pw.Text("Plazo en Meses: $plazoMeses"),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Protección de Datos: Autorizo(amos) expresamente e indefinidamente a la ${empresa.nomEmpresa}, para que, obtenga de cualquier fuente de información, incluida la Central de Riesgos y Burós de Información Crediticia autorizados para operar en el país, mis(nuestras) referencias personales y/o patrimoniales anteriores o posteriores a la suscripción de esta autorización, sea como deudor principal, codeudor o garante, sobre mi(nuestro) comportamiento crediticio, manejo de mi(s)(nuestras) cuenta(s), corriente(s), de ahorro, tarjetas de crédito, etc., y en general al cumplimiento de mi(nuestras) obligaciones y demás activos, pasivos, datos personales y/o patrimoniales, aplicables para uno o más de los servicios y productos que brindan las Instituciones del Sistema Financiero, según corresponda."),
              pw.SizedBox(height: 20),
              pw.Text(
                "Firma del Solicitante:",
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 60),
              pw.Container(
                height: 1,
                color: PdfColors.grey,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  "Fecha: ${DateTime.now().toLocal().toString().split(' ')[0]}"),
            ],
          );
        },
      ),
    );

    // Guardar el archivo
    final output = await getTemporaryDirectory();
    final file = File(
        "${output.path}/SOLICITUD CREDITO - ${socio.apeSocio} ${socio.nomSocio}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Abrir el PDF en el dispositivo
    OpenFile.open(file.path);
  }
}
