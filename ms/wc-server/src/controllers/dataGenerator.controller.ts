import * as express from "express";
import { BaseHttpController, controller, httpGet, queryParam, request, response } from 'inversify-express-utils';
import { inject } from 'inversify';
import { DataGeneratorService } from '../services/dataGenerator.service';
import { Logger } from '../logger';
import { MetricsService } from '../services/metrics.service';

@controller('/generate')
export class DataGeneratorController extends BaseHttpController {
  constructor(@inject(DataGeneratorService) private readonly dataGeneratorService: DataGeneratorService,
              @inject(MetricsService) private readonly metricService: MetricsService,
              @inject(Logger) private readonly logger: Logger) {
    super();
  }
//  curl "http://localhost:3001/generate?size=1000" --output -
  @httpGet('/')
  generate(@queryParam("size") size: string, @request() req: express.Request, @response() res: express.Response) {
    const start = Date.now();
    try {
      this.logger.debug(`size = ${size}`);
      return this.dataGeneratorService.generate(parseInt(size));
    }catch (e: any) {
      res.send(e.message);
    } finally {
      const responseTimeInMs = Date.now() - start;
      this.metricService.httpRequestTimer.labels(req.method, req.route.path, res.statusCode.toString()).observe(responseTimeInMs);
    }
  }
}
