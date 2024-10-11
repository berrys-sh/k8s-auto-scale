import { Container } from 'inversify';
import { Logger } from './logger';
import { DataGeneratorService } from './services/dataGenerator.service';
import { MetricsService } from './services/metrics.service';
import { IConfig } from './entities';
import { DI_TYPES } from './consts';
import Config  from './config/config';

// const env = require('./config/config');
export const container = new Container();

container.bind<IConfig>(DI_TYPES.IConfig).toConstantValue(Config);
container.bind(DataGeneratorService).toSelf().inSingletonScope();
container.bind(MetricsService).toSelf().inSingletonScope();
container.bind(Logger).toSelf().inSingletonScope();

