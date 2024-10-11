import 'dotenv/config';
import 'reflect-metadata';
import { InversifyExpressServer } from 'inversify-express-utils';
import { container } from './inversify.config';
import { serverConfig, serverErrorConfig } from './config/server.config';

import './controllers/dataGenerator.controller';
import './controllers/metrics.controller';
import { Logger } from './logger';
import { IConfig } from './entities';
import { DI_TYPES } from './consts';

(async () => {
  const server = new InversifyExpressServer(container);
  server.setConfig(serverConfig);
  server.setErrorConfig(serverErrorConfig);
  const config = container.get<IConfig>(DI_TYPES.IConfig);
  const app = server.build();
  app.listen(config.PORT, () =>
    new Logger().info(`Server up on http://0.0.0.0:${config.PORT}/`)
  );
})()


