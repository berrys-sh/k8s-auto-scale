import * as express from 'express';
import { BaseHttpController, controller, httpGet, request, response } from 'inversify-express-utils';
import { inject } from 'inversify';
import { Logger } from '../logger';
import { MetricsService } from '../services/metrics.service';

@controller('/metrics')
export class MetricsController extends BaseHttpController {
  constructor(@inject(MetricsService) private readonly metricService: MetricsService,
              @inject(Logger) private readonly logger: Logger) {
    super();
  }

  @httpGet('/')
  async generate(@request() _req: express.Request, @response() res: express.Response) {
    this.logger.debug('metrics');
    res.setHeader('Content-Type', this.metricService.register.contentType);
    res.send(await this.metricService.register.metrics());
  }
}
