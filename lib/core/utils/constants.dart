
// App
const String appEmpresa = 'CAJA DE AHORRO FINSUS';
const String appName = 'Banca Móvil';
const String version = '2.0.0';

const String numEmpresa = '+593967814555';
const String msgEmpresa = 'Hola, necesito información';

const String baseUrl = 'http://192.168.1.171:9000/wsConsulta-2.0.2'; //Oficina
// const String baseUrl = 'http://190.123.34.157:9000/wsConsulta-2.0.2'; //ServOficina
// const String baseUrl = 'http://192.168.0.105:9000/wsConsulta-2.0.2'; //casa
//const String baseUrl = 'http://190.123.34.157:9000/wsConsultaF-2.0.2'; //Dev
// const String baseUrl = 'http://191.99.63.135:9000/wsConsulta-2.0.2'; //Finsus

const String empresaEndpoint = '/empresa/get'; //empresa para solicitud de credito

const String loginEndpoint = '/login/auth';
const String actualizaClaveEndpoint = '/login/actualizar';
const String socioEndpoint = '/socio';
const String socioCuentasEndpoint = '/socio/cuentas';
const String socioCuentaDetallesEndpoint = '/socio/cuentas/detalle';
const String socioCreditosEndpoint = '/socio/creditos';
const String socioCreditoTablaEndpoint = '/socio/creditos/detalle';
const String socioInversionesEndpoint = '/socio/inversiones';

const String socioCuentaEndpoint = '/socio/cuenta'; // Cuenta

const String tipoCreditoEndpoint = '/tipocredito/filter';
const String clasifCreditoEndpoint = '/credito/clasificacion';

const String sendSmsEndpoint = '/sms/create';
const String validateSmsEndpoint = '/sms/filter';
const String internalTransactionEndpoint = '/socio/transacciones/nctransferencia';
const String spiTransactionEndpoint = '/spi/create';

const String ifiEndpoint = '/ifi/listar';
const String spiConceptEndpoint = '/spiconcepto/listar';

const String intSpiOpiPendDepositoEndpoint = '/intspiopipend/deposito';

const String productoEndpoint = '/producto';

const String solCreditoEndpoint = '/creditos/solicitud/create';
const String garantiasEndpoint = '/socio/garantias';

const String comprobanteDepositoEndpoint = '/comprobantes/deposito/mail'; // Cuenta

const String bankAccountEndpoint = '/banco/cuentas';

const String changePasswordEndpoint = '/clave/cambiar'; // cambiar contraseña
