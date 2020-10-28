//
// class FnBackendHandler {
//   // ignore: non_constant_identifier_names
//   static int MIN_TICKET_SIZE;
//   // ignore: non_constant_identifier_names
//   static int MIN_CLOSE_SHIFT_SIZE;
//
//   FnBackend(Properties properties)  {
//   try {
//     logger.info("Starting FN backend");
//     FSTransport transport = FSTransportJCFactory.getInstance(terminal);
//     fiscalStorage = FiscalStorageFactory.getInstance(transport);
//     localQueue = new LocalQueue(queueFile);
//     String ofdIp = properties.getProperty("ofdHost");
//     int ofdPort = Integer.parseInt(properties.getProperty("ofdPort"));
//     int soTimeout = Integer.parseInt(properties.getProperty("soTimeout", "3000"));
//     networkManager = new NetworkManager(ofdIp, ofdPort, soTimeout);
//   } catch(FiscalStorageException | IOException e) {
//     throw new FnException("Unable to create backend", e);
//   }
//     checkConsistency();
//     netExecutorSvc = Executors.newSingleThreadScheduledExecutor();
//     netExecutorSvc.scheduleAtFixedRate(
//     NetExecutor(this, localQueue, networkManager), 0, 1, TimeUnit.SECONDS);
//   }
// }