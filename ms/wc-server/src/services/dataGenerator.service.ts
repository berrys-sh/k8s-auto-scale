import { injectable } from 'inversify';
import * as crypto from 'crypto';

@injectable()
export class DataGeneratorService {
  constructor() {}

  generate(size: number): string {
    const data = crypto.randomBytes(size);
    return data.toString();
  }
}
