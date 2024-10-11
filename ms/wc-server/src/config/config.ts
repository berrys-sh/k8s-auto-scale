import * as dotenv from 'dotenv';
import * as process from 'process';
import { IConfig } from '../entities';

const configFilePath = 'env.local'
dotenv.config({path: configFilePath});

const Config: IConfig =  {
  PORT: parseInt(process.env.PORT)
}
export default Config
